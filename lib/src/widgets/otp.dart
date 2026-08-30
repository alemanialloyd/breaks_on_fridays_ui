import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A one-time-password / PIN input. Wraps shadcn_flutter's `InputOTP`.
///
/// `InputOTP` has no `enabled` parameter upstream, so this cannot be
/// disabled. It also has no controller of its own, so programmatic value
/// updates aren't supported; changing [initialValue] only resets state via a
/// new [key].
Widget bofOtpField({
  Key? key,
  required int length,
  List<int?>? initialValue,
  ValueChanged<List<int?>>? onChanged,
}) {
  return InputOTP(
    key: key,
    initialValue: initialValue,
    onChanged: onChanged,
    children: List.generate(length, (_) => const CharacterInputOTPChild()),
  );
}
