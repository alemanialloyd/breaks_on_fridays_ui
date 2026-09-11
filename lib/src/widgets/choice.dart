import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../extensions/style_override.dart';
import '../forms/bof_option.dart';

/// A tappable chip that reads/writes its selection state from the nearest
/// [Choice] ancestor (provided by `ControlledMultipleChoice`/`ControlledMultipleAnswer`).
class BofChoiceChip<T> extends StatelessWidget {
  final T value;
  final Widget child;
  final bool enabled;
  final AbstractButtonStyle? selectedStyle;
  final AbstractButtonStyle? unselectedStyle;

  const BofChoiceChip({
    super.key,
    required this.value,
    required this.child,
    this.enabled = true,
    this.selectedStyle,
    this.unselectedStyle,
  });

  @override
  Widget build(BuildContext context) {
    final selected = Choice.getValue<T>(context)?.contains(value) ?? false;
    return Button(
      style: selected
          ? (selectedStyle ?? ButtonVariance.primary)
          : (unselectedStyle ?? ButtonVariance.outline),
      enabled: enabled,
      onPressed: () => Choice.choose<T>(context, value),
      child: child,
    );
  }
}

/// An inline single choice, rendered as tappable chips. Wraps
/// shadcn_flutter's `ControlledMultipleChoice`.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue].
///
/// Use [selectedBackgroundColor]/[selectedForegroundColor]/[selectedFontSize]/
/// [selectedBorderRadius] and their `unselected*` counterparts to style the
/// chips without replacing their whole button styling.
Widget bofMultipleChoiceField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  T? initialValue,
  MultipleChoiceController<T>? controller,
  bool allowUnselect = true,
  bool enabled = true,
  ValueChanged<T?>? onChanged,
  Color? selectedBackgroundColor,
  Color? selectedForegroundColor,
  double? selectedFontSize,
  BorderRadiusGeometry? selectedBorderRadius,
  Color? unselectedBackgroundColor,
  Color? unselectedForegroundColor,
  double? unselectedFontSize,
  BorderRadiusGeometry? unselectedBorderRadius,
}) {
  final selectedStyle = bofButtonStyle(
    ButtonVariance.primary,
    backgroundColor: selectedBackgroundColor,
    foregroundColor: selectedForegroundColor,
    fontSize: selectedFontSize,
    borderRadius: selectedBorderRadius,
  );
  final unselectedStyle = bofButtonStyle(
    ButtonVariance.outline,
    backgroundColor: unselectedBackgroundColor,
    foregroundColor: unselectedForegroundColor,
    fontSize: unselectedFontSize,
    borderRadius: unselectedBorderRadius,
  );
  return ControlledMultipleChoice<T>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    allowUnselect: allowUnselect,
    onChanged: onChanged,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          BofChoiceChip<T>(
            value: option.value,
            enabled: enabled && option.enabled,
            selectedStyle: selectedStyle,
            unselectedStyle: unselectedStyle,
            child: option.label,
          ),
      ],
    ),
  );
}

/// An inline multi-choice, rendered as tappable chips. Wraps
/// shadcn_flutter's `ControlledMultipleAnswer`.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue].
///
/// Use [selectedBackgroundColor]/[selectedForegroundColor]/[selectedFontSize]/
/// [selectedBorderRadius] and their `unselected*` counterparts to style the
/// chips without replacing their whole button styling.
Widget bofMultipleAnswerField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  Iterable<T>? initialValue,
  MultipleAnswerController<T>? controller,
  bool enabled = true,
  ValueChanged<Iterable<T>?>? onChanged,
  Color? selectedBackgroundColor,
  Color? selectedForegroundColor,
  double? selectedFontSize,
  BorderRadiusGeometry? selectedBorderRadius,
  Color? unselectedBackgroundColor,
  Color? unselectedForegroundColor,
  double? unselectedFontSize,
  BorderRadiusGeometry? unselectedBorderRadius,
}) {
  final selectedStyle = bofButtonStyle(
    ButtonVariance.primary,
    backgroundColor: selectedBackgroundColor,
    foregroundColor: selectedForegroundColor,
    fontSize: selectedFontSize,
    borderRadius: selectedBorderRadius,
  );
  final unselectedStyle = bofButtonStyle(
    ButtonVariance.outline,
    backgroundColor: unselectedBackgroundColor,
    foregroundColor: unselectedForegroundColor,
    fontSize: unselectedFontSize,
    borderRadius: unselectedBorderRadius,
  );
  return ControlledMultipleAnswer<T>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          BofChoiceChip<T>(
            value: option.value,
            enabled: enabled && option.enabled,
            selectedStyle: selectedStyle,
            unselectedStyle: unselectedStyle,
            child: option.label,
          ),
      ],
    ),
  );
}
