import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A popover/dialog date picker. Wraps shadcn_flutter's `ControlledDatePicker`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofDatePickerField({
  Key? key,
  DateTime? initialValue,
  DatePickerController? controller,
  Widget? placeholder,
  bool enabled = true,
  ValueChanged<DateTime?>? onChanged,
}) {
  return ControlledDatePicker(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    placeholder: placeholder,
    onChanged: onChanged,
  );
}

/// A segmented, typed date entry. Wraps shadcn_flutter's `DateInput`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofDateInputField({
  Key? key,
  DateTime? initialValue,
  DatePickerController? controller,
  bool enabled = true,
  ValueChanged<DateTime?>? onChanged,
}) {
  return DateInput(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
  );
}

/// A popover/dialog time picker. Wraps shadcn_flutter's `ControlledTimePicker`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofTimePickerField({
  Key? key,
  TimeOfDay? initialValue,
  TimePickerController? controller,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<TimeOfDay?>? onChanged,
}) {
  return ControlledTimePicker(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    showSeconds: showSeconds,
    onChanged: onChanged,
  );
}

/// A segmented, typed time entry. Wraps shadcn_flutter's `TimeInput`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofTimeInputField({
  Key? key,
  TimeOfDay? initialValue,
  ComponentController<TimeOfDay?>? controller,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<TimeOfDay?>? onChanged,
}) {
  return TimeInput(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    showSeconds: showSeconds,
    onChanged: onChanged,
  );
}

/// A popover/dialog duration picker. Wraps shadcn_flutter's `DurationPicker`.
///
/// `DurationPicker` has no `initialValue`/controller support of its own (it's
/// a plain `value`-driven widget), so this wraps it in a small internal
/// adapter that owns the current value. Pass [controller] to update the value
/// programmatically; when provided it takes precedence over [initialValue].
Widget bofDurationPickerField({
  Key? key,
  Duration initialValue = Duration.zero,
  DurationPickerController? controller,
  bool enabled = true,
  ValueChanged<Duration?>? onChanged,
}) {
  return _DurationPickerAdapter(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
  );
}

class _DurationPickerAdapter extends StatefulWidget {
  final Duration initialValue;
  final DurationPickerController? controller;
  final bool enabled;
  final ValueChanged<Duration?>? onChanged;

  const _DurationPickerAdapter({
    super.key,
    required this.initialValue,
    this.controller,
    required this.enabled,
    this.onChanged,
  });

  @override
  State<_DurationPickerAdapter> createState() => _DurationPickerAdapterState();
}

class _DurationPickerAdapterState extends State<_DurationPickerAdapter> {
  late Duration _value = widget.controller?.value ?? widget.initialValue;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _DurationPickerAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() => _value = widget.controller!.value ?? Duration.zero);
  }

  void _handleChanged(Duration? duration) {
    widget.onChanged?.call(duration);
    final controller = widget.controller;
    if (controller != null) {
      controller.value = duration;
    } else {
      setState(() => _value = duration ?? Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DurationPicker(
      value: _value,
      enabled: widget.enabled,
      onChanged: _handleChanged,
    );
  }
}

/// A segmented, typed duration entry. Wraps shadcn_flutter's `DurationInput`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofDurationInputField({
  Key? key,
  Duration? initialValue,
  ComponentController<Duration?>? controller,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<Duration?>? onChanged,
}) {
  return DurationInput(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    showSeconds: showSeconds,
    onChanged: onChanged,
  );
}
