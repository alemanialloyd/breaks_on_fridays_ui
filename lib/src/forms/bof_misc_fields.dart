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
class BoFColorField extends BoFField<Color> {
  @override
  final Color initialValue;

  final bool showAlpha;

  const BoFColorField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue = const Color(0xFF000000),
    this.showAlpha = false,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<Color?> onChanged,
    bool enabled,
  ) {
    return bofColorField(
      initialValue: initialValue,
      enabled: enabled,
      showAlpha: showAlpha,
      onChanged: onChanged,
    );
  }
}

/// A phone number input. Maps to shadcn_flutter's `PhoneInput`.
///
/// `PhoneInput` has no `enabled` parameter, so this field cannot be disabled.
class BoFPhoneField extends BoFField<PhoneNumber> {
  @override
  final PhoneNumber? initialValue;

  const BoFPhoneField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<PhoneNumber?> onChanged,
    bool enabled,
  ) {
    return bofPhoneField(
      initialValue: initialValue,
      onChanged: onChanged,
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
    this.initialValue = const SliderValue.single(0),
    this.min = 0,
    this.max = 1,
    this.divisions,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<SliderValue?> onChanged,
    bool enabled,
  ) {
    return bofSliderField(
      initialValue: initialValue,
      enabled: enabled,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
    );
  }
}

/// A star rating. Maps to shadcn_flutter's `ControlledStarRating`.
class BoFStarRatingField extends BoFField<double> {
  @override
  final double initialValue;

  final double max;
  final double step;

  const BoFStarRatingField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue = 0,
    this.max = 5,
    this.step = 0.5,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<double?> onChanged,
    bool enabled,
  ) {
    return bofStarRatingField(
      initialValue: initialValue,
      enabled: enabled,
      max: max,
      step: step,
      onChanged: onChanged,
    );
  }
}

/// A one-time-password / PIN input. Maps to shadcn_flutter's `InputOTP`.
///
/// `InputOTP` has no `enabled` parameter, so this field cannot be disabled.
class BoFOtpField extends BoFField<List<int?>> {
  @override
  final List<int?>? initialValue;

  final int length;

  const BoFOtpField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.length,
    this.initialValue,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<List<int?>?> onChanged,
    bool enabled,
  ) {
    return bofOtpField(
      length: length,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}

/// A text field with a suggestion popover. Maps to shadcn_flutter's
/// `AutoComplete` wrapping a `TextField`.
class BoFAutoCompleteField extends BoFField<String> {
  @override
  final String? initialValue;

  final List<String> suggestions;
  final Widget? placeholder;

  const BoFAutoCompleteField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.suggestions,
    this.initialValue,
    this.placeholder,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<String?> onChanged,
    bool enabled,
  ) {
    return bofAutoCompleteField(
      suggestions: suggestions,
      initialValue: initialValue,
      placeholder: placeholder,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// A free-form list of chips parsed from typed text. Maps to shadcn_flutter's
/// `ChipInput`.
class BoFChipInputField<T extends Object> extends BoFField<List<T>> {
  @override
  final List<T>? initialValue;

  /// Builds the visual chip for a committed value.
  final Widget Function(BuildContext context, T value) chipBuilder;

  /// Parses submitted text into a chip value, or returns null to reject it.
  final T? Function(String text) onChipSubmitted;

  const BoFChipInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.chipBuilder,
    required this.onChipSubmitted,
    this.initialValue,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<List<T>?> onChanged,
    bool enabled,
  ) {
    return bofChipInputField<T>(
      chipBuilder: chipBuilder,
      onChipSubmitted: onChipSubmitted,
      initialValue: initialValue,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}
