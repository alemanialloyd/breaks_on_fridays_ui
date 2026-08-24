import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A tri-state checkbox. Wraps shadcn_flutter's `ControlledCheckbox`.
Widget bofCheckboxField({
  Key? key,
  CheckboxState initialValue = CheckboxState.unchecked,
  bool enabled = true,
  ValueChanged<CheckboxState>? onChanged,
}) {
  return ControlledCheckbox(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    onChanged: onChanged,
  );
}

/// A boolean switch. Wraps shadcn_flutter's `ControlledSwitch`.
Widget bofSwitchField({
  Key? key,
  bool initialValue = false,
  bool enabled = true,
  ValueChanged<bool>? onChanged,
}) {
  return ControlledSwitch(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    onChanged: onChanged,
  );
}
