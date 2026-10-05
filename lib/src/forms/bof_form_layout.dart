import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Anything that can go in the list passed to [bofForm]: either a field spec
/// ([BoFField]) or a layout entry ([BoFRow], [BoFColumn], [BoFCustom]).
///
/// Layout entries only affect where fields are placed. Every field nested
/// inside them, at any depth, still belongs to the same form: it is
/// validated on submit, cleared by reset, and keyed by its `name` in the
/// submitted values map.
abstract class BoFFormItem {
  const BoFFormItem();
}

/// Places its [children] side by side, each taking a share of the row's
/// width.
///
/// ```dart
/// BoFRow([
///   BoFTextField(name: 'city', label: BoF.text('City')),
///   BoFTextField(name: 'zip', label: BoF.text('ZIP')),
/// ], flex: [2, 1])
/// ```
class BoFRow extends BoFFormItem {
  /// The fields (or nested layout entries) to place side by side.
  final List<BoFFormItem> children;

  /// How much of the row's width each child takes, relative to the others —
  /// the same as [Expanded.flex]. Must have one positive entry per child.
  /// Defaults to an equal share for every child.
  final List<int>? flex;

  /// Horizontal gap between children. Defaults to the form's `spacing`.
  final double? spacing;

  /// How children are aligned vertically. Defaults to
  /// [CrossAxisAlignment.start], so fields stay top-aligned even when one of
  /// them shows a hint or validation error and grows taller.
  final CrossAxisAlignment crossAxisAlignment;

  const BoFRow(
    this.children, {
    this.flex,
    this.spacing,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
}

/// Stacks its [children] vertically, with their own [spacing].
///
/// Mostly useful inside a [BoFRow], to put several fields in one of its
/// columns.
class BoFColumn extends BoFFormItem {
  /// The fields (or nested layout entries) to stack.
  final List<BoFFormItem> children;

  /// Vertical gap between children. Defaults to the form's `spacing`.
  final double? spacing;

  const BoFColumn(this.children, {this.spacing});
}

/// Renders an arbitrary [child] widget among the form's fields — a section
/// heading, a divider, explanatory text. It holds no value and is ignored
/// by validation, reset and submit.
class BoFCustom extends BoFFormItem {
  /// The widget to render.
  final Widget child;

  const BoFCustom(this.child);
}
