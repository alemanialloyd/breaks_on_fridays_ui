import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A phone number input. Wraps shadcn_flutter's `PhoneInput`.
///
/// `PhoneInput` has no `enabled` parameter upstream, so this cannot be
/// disabled.
Widget bofPhoneField({
  Key? key,
  PhoneNumber? initialValue,
  ValueChanged<PhoneNumber?>? onChanged,
}) {
  return PhoneInput(
    key: key,
    initialValue: initialValue,
    onChanged: onChanged,
  );
}
