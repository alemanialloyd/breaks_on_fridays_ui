import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A popover/dialog date picker. Wraps shadcn_flutter's `ControlledDatePicker`.
Widget bofDatePickerField({
  Key? key,
  DateTime? initialValue,
  Widget? placeholder,
  bool enabled = true,
  ValueChanged<DateTime?>? onChanged,
}) {
  return ControlledDatePicker(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    placeholder: placeholder,
    onChanged: onChanged,
  );
}

/// A segmented, typed date entry. Wraps shadcn_flutter's `DateInput`.
Widget bofDateInputField({
  Key? key,
  DateTime? initialValue,
  bool enabled = true,
  ValueChanged<DateTime?>? onChanged,
}) {
  return DateInput(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    onChanged: onChanged,
  );
}

/// A popover/dialog time picker. Wraps shadcn_flutter's `ControlledTimePicker`.
Widget bofTimePickerField({
  Key? key,
  TimeOfDay? initialValue,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<TimeOfDay?>? onChanged,
}) {
  return ControlledTimePicker(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    showSeconds: showSeconds,
    onChanged: onChanged,
  );
}

/// A segmented, typed time entry. Wraps shadcn_flutter's `TimeInput`.
Widget bofTimeInputField({
  Key? key,
  TimeOfDay? initialValue,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<TimeOfDay?>? onChanged,
}) {
  return TimeInput(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    showSeconds: showSeconds,
    onChanged: onChanged,
  );
}

/// A popover/dialog duration picker. Wraps shadcn_flutter's `DurationPicker`.
///
/// `DurationPicker` has no `initialValue`/controller support of its own (it's
/// a plain `value`-driven widget), so this wraps it in a small internal
/// adapter that owns the current value.
Widget bofDurationPickerField({
  Key? key,
  Duration initialValue = Duration.zero,
  bool enabled = true,
  ValueChanged<Duration?>? onChanged,
}) {
  return _DurationPickerAdapter(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    onChanged: onChanged,
  );
}

class _DurationPickerAdapter extends StatefulWidget {
  final Duration initialValue;
  final bool enabled;
  final ValueChanged<Duration?>? onChanged;

  const _DurationPickerAdapter({
    super.key,
    required this.initialValue,
    required this.enabled,
    this.onChanged,
  });

  @override
  State<_DurationPickerAdapter> createState() => _DurationPickerAdapterState();
}

class _DurationPickerAdapterState extends State<_DurationPickerAdapter> {
  late Duration _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return DurationPicker(
      value: _value,
      enabled: widget.enabled,
      onChanged: (duration) {
        setState(() => _value = duration ?? Duration.zero);
        widget.onChanged?.call(duration);
      },
    );
  }
}

/// A segmented, typed duration entry. Wraps shadcn_flutter's `DurationInput`.
Widget bofDurationInputField({
  Key? key,
  Duration? initialValue,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<Duration?>? onChanged,
}) {
  return DurationInput(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    showSeconds: showSeconds,
    onChanged: onChanged,
  );
}
