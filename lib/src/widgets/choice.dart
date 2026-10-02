import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../extensions/style_override.dart';
import '../forms/bof_option.dart';
import 'controlled.dart';

/// A tappable chip that reads/writes its selection state from the nearest
/// [Choice] ancestor provided by the BoF choice fields.
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

/// An inline single choice, rendered as tappable chips.
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
  return BofControlledAdapter<T?>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
    builder: (context, data) => MultipleChoice<T>(
      value: data.value,
      onChanged: data.onChanged,
      enabled: data.enabled,
      allowUnselect: allowUnselect,
      child: Data<Choice<T>>.inherit(
        // Upstream locks out other options after a choice. Supply an immutable
        // scope that allows switching and notifies chips when the value changes.
        data: _BofChoiceScope<T>(
          value: data.value == null ? null : [data.value as T],
          onSelect: (value) {
            if (!data.enabled) return;
            if (data.value == value) {
              if (allowUnselect) data.onChanged(null);
            } else {
              data.onChanged(value);
            }
          },
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              BofChoiceChip<T>(
                value: option.value,
                enabled: data.enabled && option.enabled,
                selectedStyle: selectedStyle,
                unselectedStyle: unselectedStyle,
                child: option.label,
              ),
          ],
        ),
      ),
    ),
  );
}

/// An inline multi-choice, rendered as independently toggleable chips.
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
  return BofControlledAdapter<Iterable<T>?>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
    builder: (context, data) => MultipleAnswer<T>(
      value: data.value,
      onChanged: data.onChanged,
      enabled: data.enabled,
      allowUnselect: true,
      child: Data<Choice<T>>.inherit(
        data: _BofChoiceScope<T>(
          value: data.value,
          onSelect: (value) {
            if (!data.enabled) return;
            final values = data.value?.toList() ?? <T>[];
            if (values.contains(value)) {
              values.removeWhere((item) => item == value);
            } else {
              values.add(value);
            }
            data.onChanged(List<T>.unmodifiable(values));
          },
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              BofChoiceChip<T>(
                value: option.value,
                enabled: data.enabled && option.enabled,
                selectedStyle: selectedStyle,
                unselectedStyle: unselectedStyle,
                child: option.label,
              ),
          ],
        ),
      ),
    ),
  );
}

class _BofChoiceScope<T> with Choice<T> {
  _BofChoiceScope({required this.value, required this.onSelect});

  @override
  final Iterable<T>? value;
  final ValueChanged<T> onSelect;

  @override
  void selectItem(T item) => onSelect(item);
}
