import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../widgets/date_time.dart';
import 'bof_field.dart';

/// A popover/dialog date picker. Maps to shadcn_flutter's `ControlledDatePicker`.
///
/// Shares its appearance options with [bofDatePickerField].
class BoFDatePickerField extends BoFField<DateTime> {
  @override
  final DateTime? initialValue;

  final Widget? placeholder;

  final PromptMode mode;

  final EdgeInsetsGeometry? popoverPadding;

  final Widget? dialogTitle;

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

  const BoFDatePickerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue,
    this.placeholder,
    this.mode = PromptMode.popover,
    this.popoverPadding,
    this.dialogTitle,
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
    DateTime? value,
    ValueChanged<DateTime?> onChanged,
    bool enabled,
  ) {
    return bofDatePickerField(
      initialValue: value,
      enabled: enabled,
      placeholder: placeholder,
      mode: mode,
      popoverPadding: popoverPadding,
      dialogTitle: dialogTitle,
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

/// A segmented, typed date entry. Maps to shadcn_flutter's `DateInput`.
///
/// Shares its appearance options with [bofDateInputField].
class BoFDateInputField extends BoFField<DateTime> {
  @override
  final DateTime? initialValue;

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

  const BoFDateInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue,
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
    DateTime? value,
    ValueChanged<DateTime?> onChanged,
    bool enabled,
  ) {
    return bofDateInputField(
      initialValue: value,
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

/// A popover/dialog time picker. Maps to shadcn_flutter's `ControlledTimePicker`.
///
/// Shares its appearance options with [bofTimePickerField].
class BoFTimePickerField extends BoFField<TimeOfDay> {
  @override
  final TimeOfDay? initialValue;

  final bool showSeconds;

  final PromptMode mode;

  final EdgeInsetsGeometry? popoverPadding;

  final Widget? dialogTitle;

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

  const BoFTimePickerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue,
    this.showSeconds = false,
    this.mode = PromptMode.popover,
    this.popoverPadding,
    this.dialogTitle,
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
    TimeOfDay? value,
    ValueChanged<TimeOfDay?> onChanged,
    bool enabled,
  ) {
    return bofTimePickerField(
      initialValue: value,
      enabled: enabled,
      showSeconds: showSeconds,
      mode: mode,
      popoverPadding: popoverPadding,
      dialogTitle: dialogTitle,
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

/// A segmented, typed time entry. Maps to shadcn_flutter's `TimeInput`.
///
/// Shares its appearance options with [bofTimeInputField].
class BoFTimeInputField extends BoFField<TimeOfDay> {
  @override
  final TimeOfDay? initialValue;

  final bool showSeconds;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;

  const BoFTimeInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue,
    this.showSeconds = false,
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
    TimeOfDay? value,
    ValueChanged<TimeOfDay?> onChanged,
    bool enabled,
  ) {
    return bofTimeInputField(
      initialValue: value,
      enabled: enabled,
      showSeconds: showSeconds,
      onChanged: onChanged,
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

/// A popover/dialog duration picker. Maps to shadcn_flutter's `DurationPicker`.
///
/// Shares its appearance options with [bofDurationPickerField].
class BoFDurationPickerField extends BoFField<Duration> {
  @override
  final Duration initialValue;

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

  const BoFDurationPickerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue = Duration.zero,
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
    Duration? value,
    ValueChanged<Duration?> onChanged,
    bool enabled,
  ) {
    return bofDurationPickerField(
      initialValue: value ?? initialValue,
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

/// A segmented, typed duration entry. Maps to shadcn_flutter's `DurationInput`.
///
/// Shares its appearance options with [bofDurationInputField].
class BoFDurationInputField extends BoFField<Duration> {
  @override
  final Duration? initialValue;

  final bool showSeconds;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;

  const BoFDurationInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue,
    this.showSeconds = false,
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
    Duration? value,
    ValueChanged<Duration?> onChanged,
    bool enabled,
  ) {
    return bofDurationInputField(
      initialValue: value,
      enabled: enabled,
      showSeconds: showSeconds,
      onChanged: onChanged,
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
