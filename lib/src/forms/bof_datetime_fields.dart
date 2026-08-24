import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../widgets/date_time.dart';
import 'bof_field.dart';

/// A popover/dialog date picker. Maps to shadcn_flutter's `ControlledDatePicker`.
class BoFDatePickerField extends BoFField<DateTime> {
  @override
  final DateTime? initialValue;

  final Widget? placeholder;

  const BoFDatePickerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
    this.placeholder,
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
      onChanged: onChanged,
    );
  }
}

/// A segmented, typed date entry. Maps to shadcn_flutter's `DateInput`.
class BoFDateInputField extends BoFField<DateTime> {
  @override
  final DateTime? initialValue;

  const BoFDateInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
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
    );
  }
}

/// A popover/dialog time picker. Maps to shadcn_flutter's `ControlledTimePicker`.
class BoFTimePickerField extends BoFField<TimeOfDay> {
  @override
  final TimeOfDay? initialValue;

  final bool showSeconds;

  const BoFTimePickerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
    this.showSeconds = false,
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
      onChanged: onChanged,
    );
  }
}

/// A segmented, typed time entry. Maps to shadcn_flutter's `TimeInput`.
class BoFTimeInputField extends BoFField<TimeOfDay> {
  @override
  final TimeOfDay? initialValue;

  final bool showSeconds;

  const BoFTimeInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
    this.showSeconds = false,
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
    );
  }
}

/// A popover/dialog duration picker. Maps to shadcn_flutter's `DurationPicker`.
class BoFDurationPickerField extends BoFField<Duration> {
  @override
  final Duration initialValue;

  const BoFDurationPickerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue = Duration.zero,
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
    );
  }
}

/// A segmented, typed duration entry. Maps to shadcn_flutter's `DurationInput`.
class BoFDurationInputField extends BoFField<Duration> {
  @override
  final Duration? initialValue;

  final bool showSeconds;

  const BoFDurationInputField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
    this.showSeconds = false,
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
    );
  }
}
