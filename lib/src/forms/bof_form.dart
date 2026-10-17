import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'bof_field.dart';
import 'bof_form_controller.dart';
import 'bof_form_layout.dart';

/// Builds a form from a list of [BoFField] specs.
///
/// Fields are stacked vertically by default. To place them differently, mix
/// layout entries into the list: [BoFRow] puts fields side by side,
/// [BoFColumn] stacks them (e.g. inside one column of a row), and
/// [BoFCustom] renders any other widget, such as a section heading. Fields
/// nested in layout entries behave exactly like top-level ones.
///
/// Each field owns its value internally — there is no
/// [TextEditingController] (or any other controller) to create, wire up or
/// dispose. Read submitted values from [onSubmit], or pass a [controller] to
/// observe/drive the form programmatically, similar to a `useRef` for the
/// whole form. Calling `controller.setValue(name, ...)` updates the
/// rendered field too, not just the tracked value.
///
/// See the package README for a full field-by-field reference.
Widget bofForm(
  List<BoFFormItem> fields, {
  Key? key,
  BoFFormController? controller,
  ValueChanged<Map<String, Object?>>? onSubmit,
  double spacing = 16,
}) {
  return _BofForm(
    key: key,
    items: fields,
    controller: controller,
    onSubmit: onSubmit,
    spacing: spacing,
  );
}

class _BofForm extends StatefulWidget {
  final List<BoFFormItem> items;
  final BoFFormController? controller;
  final ValueChanged<Map<String, Object?>>? onSubmit;
  final double spacing;

  const _BofForm({
    super.key,
    required this.items,
    this.controller,
    this.onSubmit,
    required this.spacing,
  });

  @override
  State<_BofForm> createState() => _BofFormState();
}

class _BofFormState extends State<_BofForm> {
  late final BoFFormController _controller;

  // Bumped per-field to force Flutter to discard and remount that field's
  // input widget — otherwise it would keep its own internal state (e.g.
  // typed text) since it only reads its seed value once, on mount. Only
  // bumped for *programmatic* changes (setValue/reset), never for the
  // field's own onChanged, so typing never gets interrupted.
  final Map<String, int> _fieldGenerations = {};

  /// Every field in the form, in order, including those nested inside
  /// [BoFRow]/[BoFColumn] entries.
  List<BoFField> get _fields {
    final fields = <BoFField>[];
    void collect(Iterable<BoFFormItem> items) {
      for (final item in items) {
        switch (item) {
          case BoFField():
            fields.add(item);
          case BoFRow(:final children) || BoFColumn(:final children):
            collect(children);
          case BoFCustom():
            break;
        }
      }
    }

    collect(widget.items);
    assert(() {
      final seen = <String>{};
      for (final field in fields) {
        if (!seen.add(field.name)) {
          throw FlutterError(
            'bofForm has more than one field named "${field.name}". '
            'Field names must be unique across the whole form, including '
            'fields nested inside BoFRow/BoFColumn.',
          );
        }
      }
      return true;
    }());
    return fields;
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? BoFFormController();
    for (final field in _fields) {
      _controller.reportChange(field.name, field.initialValue);
    }
    _controller.submitHandler = _submit;
    _controller.resetHandler = _reset;
    _controller.applyHandler = _applyValue;
  }

  void _applyValue(String name, Object? value) {
    if (!mounted) return;
    setState(() {
      _fieldGenerations[name] = (_fieldGenerations[name] ?? 0) + 1;
    });
  }

  void _reset() {
    if (!mounted) return;
    setState(() {
      for (final field in _fields) {
        _fieldGenerations[field.name] =
            (_fieldGenerations[field.name] ?? 0) + 1;
        _controller.reportChange(field.name, field.initialValue);
        _controller.setError(field.name, null);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.submitHandler = null;
      _controller.resetHandler = null;
      _controller.applyHandler = null;
    }
    super.dispose();
  }

  Future<void> _runValidator(BoFField field, FormValidationMode mode) async {
    final validator = field.validator;
    if (validator == null || !field.enabled) {
      _controller.setError(field.name, null);
      return;
    }
    final value = _controller.value(field.name);
    final result = await validator.validate(context, value, mode);
    // The form (and its own controller) may have been disposed while an
    // async validator was running.
    if (!mounted) return;
    _controller.setError(field.name, result);
  }

  Future<void> _submit() async {
    for (final field in _fields) {
      await _runValidator(field, FormValidationMode.submitted);
    }
    if (!mounted) return;
    setState(() {});
    if (_controller.isValid) {
      widget.onSubmit?.call(_controller.values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in widget.items) ...[
          _buildItem(item),
          Gap(widget.spacing),
        ],
      ],
    );
  }

  Widget _buildItem(BoFFormItem item) {
    switch (item) {
      case BoFField():
        return _buildField(item);
      case BoFRow():
        return _buildRow(item);
      case BoFColumn():
        return _buildColumn(item);
      case BoFCustom():
        return item.child;
    }
    throw ArgumentError.value(
      item,
      'item',
      'Unsupported BoFFormItem; use a BoFField, BoFRow, BoFColumn or '
          'BoFCustom.',
    );
  }

  Widget _buildRow(BoFRow row) {
    final flex = row.flex;
    assert(
      flex == null || flex.length == row.children.length,
      'BoFRow.flex must have one entry per child '
      '(${row.children.length}), got ${flex.length}.',
    );
    assert(
      flex == null || flex.every((f) => f > 0),
      'BoFRow.flex entries must be positive.',
    );
    final spacing = row.spacing ?? widget.spacing;
    return Row(
      crossAxisAlignment: row.crossAxisAlignment,
      children: [
        for (var i = 0; i < row.children.length; i++) ...[
          if (i > 0) Gap(spacing),
          Expanded(flex: flex?[i] ?? 1, child: _buildItem(row.children[i])),
        ],
      ],
    );
  }

  Widget _buildColumn(BoFColumn column) {
    final spacing = column.spacing ?? widget.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < column.children.length; i++) ...[
          if (i > 0) Gap(spacing),
          _buildItem(column.children[i]),
        ],
      ],
    );
  }

  Widget _buildField(BoFField field) {
    return _BofFieldShell(
      label: field.label,
      hint: field.hint,
      error: _controller.errorOf(field.name),
      child: KeyedSubtree(
        key: ValueKey('${field.name}#${_fieldGenerations[field.name] ?? 0}'),
        child: field.buildInput(context, _controller.value(field.name), (
          value,
        ) {
          _controller.reportChange(field.name, value);
          _runValidator(field, FormValidationMode.changed);
          setState(() {});
        }, field.enabled),
      ),
    );
  }
}

class _BofFieldShell extends StatelessWidget {
  final Widget label;
  final Widget? hint;
  final ValidationResult? error;
  final Widget child;

  const _BofFieldShell({
    required this.label,
    this.hint,
    this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final invalidResult = error;
    final invalid = invalidResult is InvalidResult;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle.merge(
          style: invalid
              ? TextStyle(color: theme.colorScheme.destructive)
              : null,
          child: label,
        ).small,
        const Gap(8),
        child,
        if (hint != null) ...[const Gap(4), hint!.xSmall.muted],
        if (invalid) ...[
          const Gap(4),
          DefaultTextStyle.merge(
            style: TextStyle(color: theme.colorScheme.destructive),
            child: Text(invalidResult.message).xSmall,
          ),
        ],
      ],
    );
  }
}
