import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../widgets/choice.dart';
import '../widgets/radio_group.dart';
import '../widgets/select.dart';
import 'bof_field.dart';
import 'bof_option.dart';

/// A single/radio choice field, rendered as a group of radio items (or radio
/// cards when [card] is true). Maps to shadcn_flutter's `ControlledRadioGroup`
/// combined with `RadioItem`/`RadioCard`.
class BoFRadioGroupField<T extends Object> extends BoFField<T> {
  @override
  final T? initialValue;

  @override
  bool get fillsWidth => false;

  final List<BoFOption<T>> options;
  final bool card;
  final Axis direction;

  const BoFRadioGroupField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.options,
    this.initialValue,
    this.card = false,
    this.direction = Axis.vertical,
  });

  @override
  Widget buildInput(
    BuildContext context,
    T? value,
    ValueChanged<T?> onChanged,
    bool enabled,
  ) {
    return bofRadioGroupField<T>(
      options: options,
      initialValue: value,
      card: card,
      direction: direction,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// A single-selection dropdown. [bofForm] stretches it to the full width of
/// its slot; the standalone [bofSelectField] sizes to its widest option or
/// placeholder.
///
/// Shares its appearance options with [bofSelectField].
class BoFSelectField<T extends Object> extends BoFField<T> {
  @override
  final T? initialValue;

  final List<BoFOption<T>> options;
  final Widget? placeholder;
  final bool filled;

  final Widget? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;

  const BoFSelectField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.options,
    this.initialValue,
    this.placeholder,
    this.filled = false,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.padding,
  });

  @override
  Widget buildInput(
    BuildContext context,
    T? value,
    ValueChanged<T?> onChanged,
    bool enabled,
  ) {
    return bofSelectField<T>(
      options: options,
      initialValue: value,
      placeholder: placeholder,
      filled: filled,
      enabled: enabled,
      onChanged: onChanged,
      trailingIcon: trailingIcon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
    );
  }
}

/// A multi-selection dropdown with removable chips and stable option sizing.
///
/// Shares its appearance options with [bofMultiSelectField].
class BoFMultiSelectField<T extends Object> extends BoFField<Iterable<T>> {
  @override
  final Iterable<T>? initialValue;

  final List<BoFOption<T>> options;
  final Widget? placeholder;

  final Widget? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;

  const BoFMultiSelectField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.options,
    this.initialValue,
    this.placeholder,
    this.trailingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.padding,
  });

  @override
  Widget buildInput(
    BuildContext context,
    Iterable<T>? value,
    ValueChanged<Iterable<T>?> onChanged,
    bool enabled,
  ) {
    return bofMultiSelectField<T>(
      options: options,
      initialValue: value,
      placeholder: placeholder,
      enabled: enabled,
      onChanged: onChanged,
      trailingIcon: trailingIcon,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
    );
  }
}

/// An inline single choice, rendered as tappable chips.
///
/// Shares its appearance options with [bofMultipleChoiceField].
class BoFMultipleChoiceField<T extends Object> extends BoFField<T> {
  @override
  final T? initialValue;

  @override
  bool get fillsWidth => false;

  final List<BoFOption<T>> options;
  final bool allowUnselect;

  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final double? selectedFontSize;
  final FontWeight? selectedFontWeight;
  final BorderRadiusGeometry? selectedBorderRadius;
  final Color? selectedBorderColor;
  final double? selectedBorderWidth;
  final EdgeInsetsGeometry? selectedPadding;
  final Color? unselectedBackgroundColor;
  final Color? unselectedForegroundColor;
  final double? unselectedFontSize;
  final FontWeight? unselectedFontWeight;
  final BorderRadiusGeometry? unselectedBorderRadius;
  final Color? unselectedBorderColor;
  final double? unselectedBorderWidth;
  final EdgeInsetsGeometry? unselectedPadding;

  const BoFMultipleChoiceField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.options,
    this.initialValue,
    this.allowUnselect = true,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.selectedFontSize,
    this.selectedFontWeight,
    this.selectedBorderRadius,
    this.selectedBorderColor,
    this.selectedBorderWidth,
    this.selectedPadding,
    this.unselectedBackgroundColor,
    this.unselectedForegroundColor,
    this.unselectedFontSize,
    this.unselectedFontWeight,
    this.unselectedBorderRadius,
    this.unselectedBorderColor,
    this.unselectedBorderWidth,
    this.unselectedPadding,
  });

  @override
  Widget buildInput(
    BuildContext context,
    T? value,
    ValueChanged<T?> onChanged,
    bool enabled,
  ) {
    return bofMultipleChoiceField<T>(
      options: options,
      initialValue: value,
      allowUnselect: allowUnselect,
      enabled: enabled,
      onChanged: onChanged,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      selectedFontSize: selectedFontSize,
      selectedFontWeight: selectedFontWeight,
      selectedBorderRadius: selectedBorderRadius,
      selectedBorderColor: selectedBorderColor,
      selectedBorderWidth: selectedBorderWidth,
      selectedPadding: selectedPadding,
      unselectedBackgroundColor: unselectedBackgroundColor,
      unselectedForegroundColor: unselectedForegroundColor,
      unselectedFontSize: unselectedFontSize,
      unselectedFontWeight: unselectedFontWeight,
      unselectedBorderRadius: unselectedBorderRadius,
      unselectedBorderColor: unselectedBorderColor,
      unselectedBorderWidth: unselectedBorderWidth,
      unselectedPadding: unselectedPadding,
    );
  }
}

/// An inline multi-choice, rendered as independently toggleable chips.
///
/// Shares its appearance options with [bofMultipleAnswerField].
class BoFMultipleAnswerField<T extends Object> extends BoFField<Iterable<T>> {
  @override
  final Iterable<T>? initialValue;

  @override
  bool get fillsWidth => false;

  final List<BoFOption<T>> options;

  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final double? selectedFontSize;
  final FontWeight? selectedFontWeight;
  final BorderRadiusGeometry? selectedBorderRadius;
  final Color? selectedBorderColor;
  final double? selectedBorderWidth;
  final EdgeInsetsGeometry? selectedPadding;
  final Color? unselectedBackgroundColor;
  final Color? unselectedForegroundColor;
  final double? unselectedFontSize;
  final FontWeight? unselectedFontWeight;
  final BorderRadiusGeometry? unselectedBorderRadius;
  final Color? unselectedBorderColor;
  final double? unselectedBorderWidth;
  final EdgeInsetsGeometry? unselectedPadding;

  const BoFMultipleAnswerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.options,
    this.initialValue,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.selectedFontSize,
    this.selectedFontWeight,
    this.selectedBorderRadius,
    this.selectedBorderColor,
    this.selectedBorderWidth,
    this.selectedPadding,
    this.unselectedBackgroundColor,
    this.unselectedForegroundColor,
    this.unselectedFontSize,
    this.unselectedFontWeight,
    this.unselectedBorderRadius,
    this.unselectedBorderColor,
    this.unselectedBorderWidth,
    this.unselectedPadding,
  });

  @override
  Widget buildInput(
    BuildContext context,
    Iterable<T>? value,
    ValueChanged<Iterable<T>?> onChanged,
    bool enabled,
  ) {
    return bofMultipleAnswerField<T>(
      options: options,
      initialValue: value,
      enabled: enabled,
      onChanged: onChanged,
      selectedBackgroundColor: selectedBackgroundColor,
      selectedForegroundColor: selectedForegroundColor,
      selectedFontSize: selectedFontSize,
      selectedFontWeight: selectedFontWeight,
      selectedBorderRadius: selectedBorderRadius,
      selectedBorderColor: selectedBorderColor,
      selectedBorderWidth: selectedBorderWidth,
      selectedPadding: selectedPadding,
      unselectedBackgroundColor: unselectedBackgroundColor,
      unselectedForegroundColor: unselectedForegroundColor,
      unselectedFontSize: unselectedFontSize,
      unselectedFontWeight: unselectedFontWeight,
      unselectedBorderRadius: unselectedBorderRadius,
      unselectedBorderColor: unselectedBorderColor,
      unselectedBorderWidth: unselectedBorderWidth,
      unselectedPadding: unselectedPadding,
    );
  }
}
