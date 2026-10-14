import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';

/// A one-time-password / PIN input. Wraps shadcn_flutter's `InputOTP`.
///
/// `InputOTP` has no `enabled` parameter upstream, so this cannot be
/// disabled. It also has no controller of its own, so programmatic value
/// updates aren't supported; changing [initialValue] only resets state via a
/// new [key].
///
/// [spacing] and [height] go through `InputOTPTheme`. The cells are drawn from
/// theme colors, so the other appearance options scope the theme around the
/// field: [backgroundColor] fills the cells, [foregroundColor]/[fontSize]/
/// [fontWeight] style the characters, [borderColor] colors the cell borders,
/// and [borderRadius] sets the outer corner radius (using its top-left
/// corner). The cell border width is fixed upstream.
Widget bofOtpField({
  Key? key,
  required int length,
  List<int?>? initialValue,
  ValueChanged<List<int?>>? onChanged,
  double? spacing,
  double? height,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
}) {
  final otp = InputOTP(
    key: key,
    initialValue: initialValue,
    onChanged: onChanged,
    children: List.generate(length, (_) => const CharacterInputOTPChild()),
  );
  return BofScopedSurface(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    borderRadius: borderRadius,
    borderColor: borderColor,
    child: spacing == null && height == null
        ? otp
        : ComponentTheme<InputOTPTheme>(
            data: InputOTPTheme(spacing: spacing, height: height),
            child: otp,
          ),
  );
}
