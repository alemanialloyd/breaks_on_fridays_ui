import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Anything that can go in the list passed to [bofForm]: either a field spec
/// ([BoFField]) or a layout entry ([BoFRow], [BoFColumn], [BoFCustom],
/// [BoFDynamic]).
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

/// Builds part of the form from the current field values, so options or
/// whole fields can depend on what the user picked earlier — for example a
/// region select whose options come from the selected country.
///
/// [builder] runs on every rebuild of the form with a snapshot of all field
/// values, and returns the items to show in this entry's place. They are
/// laid out as if they were written inline, and may be fields or any other
/// [BoFFormItem], including another [BoFDynamic].
///
/// Whenever a field named in [dependsOn] changes, every field [builder]
/// returns is reset to its `initialValue`, so a stale choice never outlives
/// the value it depended on. The reset cascades: a [BoFDynamic] that depends
/// on one of those fields resets too. Fields that [builder] stops returning
/// are dropped from the form's values and errors, so hidden fields are
/// neither validated nor submitted.
///
/// ```dart
/// BoF.form([
///   BoFSelectField<String>(
///     name: 'country',
///     label: BoF.text('Country'),
///     options: countries,
///   ),
///   BoFDynamic(
///     dependsOn: const ['country'],
///     builder: (values) => [
///       BoFSelectField<String>(
///         name: 'region',
///         label: BoF.text('Region'),
///         enabled: values['country'] != null,
///         options: regionsOf(values['country'] as String?),
///       ),
///     ],
///   ),
/// ])
/// ```
class BoFDynamic extends BoFFormItem {
  /// The names of the fields whose changes reset the fields from [builder].
  final List<String> dependsOn;

  /// Returns the items to show, given every field's current value by name.
  final List<BoFFormItem> Function(Map<String, Object?> values) builder;

  const BoFDynamic({required this.builder, this.dependsOn = const []});
}
