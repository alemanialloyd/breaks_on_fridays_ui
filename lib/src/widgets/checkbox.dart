import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A tri-state checkbox. Wraps shadcn_flutter's `ControlledCheckbox`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofCheckboxField({
  Key? key,
  CheckboxState initialValue = CheckboxState.unchecked,
  CheckboxController? controller,
  bool enabled = true,
  ValueChanged<CheckboxState>? onChanged,
}) {
  return ControlledCheckbox(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
  );
}

/// A boolean switch. Wraps shadcn_flutter's `ControlledSwitch`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofSwitchField({
  Key? key,
  bool initialValue = false,
  SwitchController? controller,
  bool enabled = true,
  ValueChanged<bool>? onChanged,
}) {
  return ControlledSwitch(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
  );
}
