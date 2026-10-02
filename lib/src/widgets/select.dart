import 'package:flutter/rendering.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../forms/bof_option.dart';
import 'controlled.dart';

Widget _buildSelectItem<T>(List<BoFOption<T>> options, T value) {
  final match = options.where((o) => o.value == value);
  return match.isEmpty ? Text('$value') : match.first.label;
}

// Scrolling the label also accommodates wide custom rows inside narrow fields.
Widget _selectLabel(Widget label) => ClipRect(
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: _IntrinsicSafeLabel(child: label),
  ),
);

SelectPopupBuilder _buildSelectPopup<T>(List<BoFOption<T>> options) {
  return (context) => SelectPopup(
    items: SelectItemList(
      children: [
        for (final option in options)
          SelectItemButton<T>(
            value: option.value,
            enabled: option.enabled,
            child: _selectLabel(option.label),
          ),
      ],
    ),
  );
}

/// A single-selection dropdown, sized to its widest option or placeholder.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue], including an empty selection.
Widget bofSelectField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  T? initialValue,
  SelectController<T>? controller,
  Widget? placeholder,
  bool filled = false,
  bool enabled = true,
  ValueChanged<T?>? onChanged,
  BorderRadiusGeometry? borderRadius,
}) {
  final emptyLabel = placeholder ?? const Text('Select an option');
  Widget content(Widget child) => _SelectContentWidth(
    samples: [
      _selectLabel(emptyLabel),
      for (final option in options) _selectLabel(option.label),
    ],
    child: _selectLabel(child),
  );
  return BofControlledAdapter<T?>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
    builder: (context, data) => Select<T>(
      value: data.value,
      onChanged: data.onChanged,
      enabled: data.enabled,
      filled: filled,
      placeholder: content(emptyLabel),
      borderRadius: borderRadius,
      itemBuilder: (context, value) =>
          content(_buildSelectItem(options, value)),
      popup: _buildSelectPopup(options),
    ),
  );
}

/// A multi-selection dropdown, sized to its widest option chip or placeholder.
/// Selected chips wrap within the field rather than changing its width.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue], including an empty selection.
Widget bofMultiSelectField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  Iterable<T>? initialValue,
  MultiSelectController<T>? controller,
  Widget? placeholder,
  bool enabled = true,
  ValueChanged<Iterable<T>?>? onChanged,
  BorderRadiusGeometry? borderRadius,
}) {
  final emptyLabel = placeholder ?? const Text('Select options');
  Widget chip(T value, Widget label) => MultiSelectChip(
    value: value,
    style: const ButtonStyle.secondary(),
    child: _selectLabel(label),
  );
  Widget content(Widget child) => _SelectContentWidth(
    samples: [
      _selectLabel(emptyLabel),
      for (final option in options) chip(option.value, option.label),
    ],
    child: child,
  );
  return BofControlledAdapter<Iterable<T>?>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
    builder: (context, data) => Select<Iterable<T>>(
      value: data.value,
      onChanged: data.onChanged,
      enabled: data.enabled,
      placeholder: content(_selectLabel(emptyLabel)),
      borderRadius: borderRadius,
      canUnselect: true,
      autoClosePopover: false,
      showValuePredicate: (values) => values.isNotEmpty,
      valueSelectionPredicate: (values, value) =>
          values?.contains(value) ?? false,
      valueSelectionHandler: (values, value, selected) => [
        for (final existing in values ?? <T>[])
          if (existing != value) existing,
        if (selected) value as T,
      ],
      itemBuilder: (context, values) {
        final theme = Theme.of(context);
        final spacing = theme.density.baseGap * theme.scaling * 0.5;
        return content(
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final value in values)
                chip(value, _buildSelectItem(options, value)),
            ],
          ),
        );
      },
      popup: _buildSelectPopup(options),
    ),
  );
}

// LayoutBuilder and lazy viewports cannot supply natural intrinsic dimensions.
// Give these constraint-dependent labels bounded space, including in release
// builds where their intrinsic methods return zero instead of asserting.
class _IntrinsicSafeLabel extends SingleChildRenderObjectWidget {
  const _IntrinsicSafeLabel({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderIntrinsicSafeLabel(Theme.of(context).scaling);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderIntrinsicSafeLabel renderObject,
  ) {
    renderObject.scaling = Theme.of(context).scaling;
  }
}

class _RenderIntrinsicSafeLabel extends RenderProxyBox {
  _RenderIntrinsicSafeLabel(this._scaling);

  double _scaling;

  set scaling(double value) {
    if (_scaling == value) return;
    _scaling = value;
    markNeedsLayout();
  }

  double get _fallbackWidth => 240 * _scaling;
  double get _fallbackHeight => 24 * _scaling;

  bool _hasUnavailableIntrinsics(RenderObject object) {
    if (object is RenderAbstractLayoutBuilderMixin<Object?, RenderObject> ||
        object is RenderViewport ||
        object is RenderShrinkWrappingViewport) {
      return true;
    }
    var unsupported = false;
    object.visitChildren((child) {
      unsupported = unsupported || _hasUnavailableIntrinsics(child);
    });
    return unsupported;
  }

  double _intrinsic(double Function() measure, double fallback) {
    if (_hasUnavailableIntrinsics(child!)) return fallback;
    try {
      final value = measure();
      return value.isFinite ? value : fallback;
    } on FlutterError catch (error) {
      if (error.toString().contains('does not support returning intrinsic')) {
        return fallback;
      }
      rethrow;
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _intrinsic(() => child!.getMinIntrinsicWidth(height), _fallbackWidth);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _intrinsic(() => child!.getMaxIntrinsicWidth(height), _fallbackWidth);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _intrinsic(() => child!.getMinIntrinsicHeight(width), _fallbackHeight);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _intrinsic(() => child!.getMaxIntrinsicHeight(width), _fallbackHeight);

  BoxConstraints _labelConstraints(BoxConstraints constraints) {
    final width = computeMaxIntrinsicWidth(double.infinity);
    if (_hasUnavailableIntrinsics(child!)) {
      return BoxConstraints(maxWidth: width, maxHeight: _fallbackHeight);
    }
    return constraints.tighten(width: width);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (_hasUnavailableIntrinsics(child!)) {
      return constraints.constrain(Size(_fallbackWidth, _fallbackHeight));
    }
    return constraints.constrain(
      child!.getDryLayout(_labelConstraints(constraints)),
    );
  }

  @override
  void performLayout() {
    child!.layout(_labelConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(child!.size);
  }
}

/// Measures actual option widgets in the trigger's inherited text/icon theme.
/// The select itself adds its padding and chevron to this content width.
class _SelectContentWidth extends MultiChildRenderObjectWidget {
  _SelectContentWidth({required Widget child, required List<Widget> samples})
    : super(
        children: [
          child,
          for (final sample in samples)
            Offstage(
              child: ExcludeFocus(
                child: TickerMode(enabled: false, child: sample),
              ),
            ),
        ],
      );

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSelectContentWidth();
}

class _SelectContentParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderSelectContentWidth extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _SelectContentParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _SelectContentParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _SelectContentParentData) {
      child.parentData = _SelectContentParentData();
    }
  }

  double _preferredWidth(double height) {
    var width = 0.0;
    var sample = childAfter(firstChild!);
    while (sample != null) {
      // Offstage keeps measurement labels out of focus, semantics and finders.
      final label = (sample as RenderOffstage).child!;
      final candidate = label.getMaxIntrinsicWidth(height);
      if (candidate.isFinite && candidate > width) width = candidate;
      sample = childAfter(sample);
    }
    return width;
  }

  @override
  double computeMinIntrinsicWidth(double height) => _preferredWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) => _preferredWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild!.getMinIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild!.getMaxIntrinsicHeight(width);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final width = constraints.constrainWidth(_preferredWidth(double.infinity));
    return constraints.constrain(
      firstChild!.getDryLayout(constraints.tighten(width: width)),
    );
  }

  @override
  void performLayout() {
    final width = constraints.constrainWidth(_preferredWidth(double.infinity));
    firstChild!.layout(constraints.tighten(width: width), parentUsesSize: true);
    size = constraints.constrain(firstChild!.size);
    var sample = childAfter(firstChild!);
    while (sample != null) {
      final label = (sample as RenderOffstage).child!;
      sample.layout(
        BoxConstraints.tightFor(
          width: label.getMaxIntrinsicWidth(double.infinity),
        ),
      );
      sample = childAfter(sample);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      context.paintChild(firstChild!, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      firstChild!.hitTest(result, position: position);

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) =>
      visitor(firstChild!);
}
