import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'bof_field.dart';
import 'bof_form_controller.dart';

/// Builds a form from a list of [BoFField] specs.
///
/// Each field owns its value internally — there is no
/// [TextEditingController] (or any other controller) to create, wire up or
/// dispose. Read submitted values from [onSubmit], or pass a [controller] to
/// observe/drive the form programmatically, similar to a `useRef` for the
/// whole form.
///
/// See the package README for a full field-by-field reference.
Widget bofForm(
  List<BoFField> fields, {
  Key? key,
  BoFFormController? controller,
  ValueChanged<Map<String, Object?>>? onSubmit,
  double spacing = 16,
}) {
  return _BofForm(
    key: key,
    fields: fields,
    controller: controller,
    onSubmit: onSubmit,
    spacing: spacing,
  );
}

class _BofForm extends StatefulWidget {
  final List<BoFField> fields;
  final BoFFormController? controller;
  final ValueChanged<Map<String, Object?>>? onSubmit;
  final double spacing;

  const _BofForm({
    super.key,
    required this.fields,
    this.controller,
    this.onSubmit,
    required this.spacing,
  });

  @override
  State<_BofForm> createState() => _BofFormState();
}

class _BofFormState extends State<_BofForm> {
  late final BoFFormController _controller;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? BoFFormController();
    for (final field in widget.fields) {
      _controller.setValue(field.name, field.initialValue);
    }
    _controller.submitHandler = _submit;
    _controller.resetHandler = _reset;
  }

  void _reset() {
    if (!mounted) return;
    setState(() {
      // Bumping the generation changes each field's key, forcing Flutter to
      // discard and remount the underlying input widgets — otherwise they'd
      // keep their own internal state (e.g. typed text) since they only
      // read `initialValue` once, on their first build.
      _generation++;
      for (final field in widget.fields) {
        _controller.setValue(field.name, field.initialValue);
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
    }
    super.dispose();
  }

  Future<void> _runValidator(BoFField field, FormValidationMode mode) async {
    final validator = field.validator;
    if (validator == null) return;
    final value = _controller.value(field.name);
    final result = await validator.validate(context, value, mode);
    _controller.setError(field.name, result);
  }

  Future<void> _submit() async {
    for (final field in widget.fields) {
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
        for (final field in widget.fields) ...[
          _buildField(field),
          Gap(widget.spacing),
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
        key: ValueKey('${field.name}#$_generation'),
        child: field.buildInput(
          context,
          (value) {
            _controller.setValue(field.name, value);
            _runValidator(field, FormValidationMode.changed);
            setState(() {});
          },
          true,
        ),
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
        if (hint != null) ...[
          const Gap(4),
          hint!.xSmall.muted,
        ],
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
