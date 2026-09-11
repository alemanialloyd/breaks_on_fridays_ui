import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A one-time-password / PIN input. Wraps shadcn_flutter's `InputOTP`.
///
/// `InputOTP` has no `enabled` parameter upstream, so this cannot be
/// disabled. It also has no controller of its own, so programmatic value
/// updates aren't supported; changing [initialValue] only resets state via a
/// new [key].
///
/// `InputOTP`'s only stylable properties upstream are [spacing] and
/// [height] — per-cell background/text color aren't customizable.
Widget bofOtpField({
  Key? key,
  required int length,
  List<int?>? initialValue,
  ValueChanged<List<int?>>? onChanged,
  double? spacing,
  double? height,
}) {
  final otp = InputOTP(
    key: key,
    initialValue: initialValue,
    onChanged: onChanged,
    children: List.generate(length, (_) => const CharacterInputOTPChild()),
  );
  return spacing == null && height == null
      ? otp
      : ComponentTheme<InputOTPTheme>(
          data: InputOTPTheme(spacing: spacing, height: height),
          child: otp,
        );
}
