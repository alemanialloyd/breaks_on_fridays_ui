import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../widgets/autocomplete.dart';
import '../widgets/chip_input.dart';
import '../widgets/color.dart';
import '../widgets/otp.dart';
import '../widgets/phone.dart';
import '../widgets/slider.dart';
import '../widgets/star_rating.dart';
import 'bof_field.dart';

/// A color swatch input. Maps to shadcn_flutter's `ControlledColorInput`.
///
/// Shares its appearance options with [bofColorField].
class BoFColorField extends BoFField<Color> {
  @override
  final Color initialValue;

  final bool showAlpha;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;

  const BoFColorField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue = const Color(0xFF000000),
    this.showAlpha = false,
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
    Color? value,
    ValueChanged<Color?> onChanged,
    bool enabled,
  ) {
    return bofColorField(
      initialValue: value ?? initialValue,
      enabled: enabled,
      showAlpha: showAlpha,
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

/// A phone number input. Maps to shadcn_flutter's `PhoneInput`.
///
/// `PhoneInput` has no `enabled` parameter, so a disabled field blocks input
/// and dims the widget instead.
///
/// Shares its appearance options with [bofPhoneField].
class BoFPhoneField extends BoFField<PhoneNumber> {
  @override
  final PhoneNumber? initialValue;

  final Color? backgroundColor;
  final bool? filled;
  final Border? border;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;

  const BoFPhoneField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue,
    this.backgroundColor,
    this.filled,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.padding,
  });

  @override
  Widget buildInput(
    BuildContext context,
    PhoneNumber? value,
    ValueChanged<PhoneNumber?> onChanged,
    bool enabled,
  ) {
    return _lockedUnless(
      enabled,
      bofPhoneField(
        initialValue: value,
        onChanged: onChanged,
        backgroundColor: backgroundColor,
        filled: filled,
        border: border,
        borderColor: borderColor,
        borderWidth: borderWidth,
        padding: padding,
      ),
    );
  }
}

/// A slider. Maps to shadcn_flutter's `ControlledSlider`.
class BoFSliderField extends BoFField<SliderValue> {
  @override
  final SliderValue initialValue;

  final double min;
  final double max;
  final int? divisions;

  const BoFSliderField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue = const SliderValue.single(0),
    this.min = 0,
    this.max = 1,
    this.divisions,
  });

  @override
  Widget buildInput(
    BuildContext context,
    SliderValue? value,
    ValueChanged<SliderValue?> onChanged,
    bool enabled,
  ) {
    return bofSliderField(
      initialValue: value ?? initialValue,
      enabled: enabled,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
    );
  }
}

/// A star rating. Maps to shadcn_flutter's `ControlledStarRating`.
///
/// Shares its appearance options with [bofStarRatingField].
class BoFStarRatingField extends BoFField<double> {
  @override
  final double initialValue;

  @override
  bool get fillsWidth => false;

  final double max;
  final double step;

  final Color? activeColor;
  final Color? backgroundColor;
  final double? starSize;
  final double? starSpacing;

  const BoFStarRatingField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    this.initialValue = 0,
    this.max = 5,
    this.step = 0.5,
    this.activeColor,
    this.backgroundColor,
    this.starSize,
    this.starSpacing,
  });

  @override
  Widget buildInput(
    BuildContext context,
    double? value,
    ValueChanged<double?> onChanged,
    bool enabled,
  ) {
    return bofStarRatingField(
      initialValue: value ?? initialValue,
      enabled: enabled,
      max: max,
      step: step,
      onChanged: onChanged,
      activeColor: activeColor,
      backgroundColor: backgroundColor,
      starSize: starSize,
      starSpacing: starSpacing,
    );
  }
}

/// A one-time-password / PIN input. Maps to shadcn_flutter's `InputOTP`.
///
/// `InputOTP` has no `enabled` parameter, so a disabled field blocks input
/// and dims the widget instead.
///
/// Shares its appearance options with [bofOtpField].
class BoFOtpField extends BoFField<List<int?>> {
  @override
  final List<int?>? initialValue;

  @override
  bool get fillsWidth => false;

  final int length;
  final double? spacing;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;

  const BoFOtpField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.length,
    this.initialValue,
    this.spacing,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget buildInput(
    BuildContext context,
    List<int?>? value,
    ValueChanged<List<int?>?> onChanged,
    bool enabled,
  ) {
    return _lockedUnless(
      enabled,
      bofOtpField(
        length: length,
        initialValue: value,
        onChanged: onChanged,
        spacing: spacing,
        height: height,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        borderRadius: borderRadius,
        borderColor: borderColor,
      ),
    );
  }
}

/// A styled text field with a suggestion popover that preserves typing focus.
///
/// Shares its appearance options with [bofAutoCompleteField].
class BoFAutoCompleteField extends BoFField<String> {
  @override
  final String? initialValue;

  final List<String> suggestions;
  final Widget? placeholder;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool? filled;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Color? selectionColor;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius cursorRadius;
  final bool? showCursor;

  const BoFAutoCompleteField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.suggestions,
    this.initialValue,
    this.placeholder,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.filled,
    this.borderRadius,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.decoration,
    this.selectionColor,
    this.cursorColor,
    this.cursorWidth = 2,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2),
    this.showCursor,
  });

  @override
  Widget buildInput(
    BuildContext context,
    String? value,
    ValueChanged<String?> onChanged,
    bool enabled,
  ) {
    return bofAutoCompleteField(
      suggestions: suggestions,
      initialValue: value,
      placeholder: placeholder,
      enabled: enabled,
      onChanged: onChanged,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      filled: filled,
      borderRadius: borderRadius,
      border: border,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
      decoration: decoration,
      selectionColor: selectionColor,
      cursorColor: cursorColor,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      showCursor: showCursor,
    );
  }
}

/// A free-form list of chips parsed from typed text. Maps to shadcn_flutter's
/// `ChipInput`.
///
/// Shares its appearance options with [bofChipInputField].
class BoFChipInputField<T extends Object> extends BoFField<List<T>> {
  @override
  final List<T>? initialValue;

  /// Builds the visual chip for a committed value.
  final Widget Function(BuildContext context, T value) chipBuilder;

  /// Parses submitted text into a chip value, or returns null to reject it.
  final T? Function(String text) onChipSubmitted;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool? filled;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Color? selectionColor;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius cursorRadius;
  final bool? showCursor;

  const BoFChipInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    super.enabled,
    required this.chipBuilder,
    required this.onChipSubmitted,
    this.initialValue,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.filled,
    this.borderRadius,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.decoration,
    this.selectionColor,
    this.cursorColor,
    this.cursorWidth = 2,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2),
    this.showCursor,
  });

  @override
  Widget buildInput(
    BuildContext context,
    List<T>? value,
    ValueChanged<List<T>?> onChanged,
    bool enabled,
  ) {
    return bofChipInputField<T>(
      chipBuilder: chipBuilder,
      onChipSubmitted: onChipSubmitted,
      initialValue: value,
      enabled: enabled,
      onChanged: onChanged,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      filled: filled,
      borderRadius: borderRadius,
      border: border,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
      decoration: decoration,
      selectionColor: selectionColor,
      cursorColor: cursorColor,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      showCursor: showCursor,
    );
  }
}

/// Disables [child] for upstream widgets that have no `enabled` parameter:
/// blocks taps and focus, and dims it like shadcn_flutter's disabled inputs.
Widget _lockedUnless(bool enabled, Widget child) {
  if (enabled) return child;
  return ExcludeFocus(
    child: IgnorePointer(child: Opacity(opacity: 0.5, child: child)),
  );
}
