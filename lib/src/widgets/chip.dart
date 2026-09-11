import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../extensions/style_override.dart';

/// A compact tag/filter chip. Wraps shadcn_flutter's `Chip`.
///
/// Pass [style] to fully override the chip's button styling, or use
/// [backgroundColor], [foregroundColor], [fontSize], [fontWeight] and/or
/// [borderRadius] to tweak individual pieces of the default styling instead
/// ([style], if provided, takes precedence).
Widget bofChip(
  Widget child, {
  Key? key,
  Widget? leading,
  Widget? trailing,
  VoidCallback? onPressed,
  AbstractButtonStyle? style,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  BorderRadiusGeometry? borderRadius,
}) {
  final hasOverride = backgroundColor != null ||
      foregroundColor != null ||
      fontSize != null ||
      fontWeight != null ||
      borderRadius != null;
  return Chip(
    key: key,
    leading: leading,
    trailing: trailing,
    onPressed: onPressed,
    style: style ??
        (hasOverride
            ? bofButtonStyle(
                ButtonVariance.secondary,
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                borderRadius: borderRadius,
              )
            : null),
    child: child,
  );
}

/// A small button meant for a [bofChip]'s `leading`/`trailing` slot (e.g. a
/// close icon). Wraps shadcn_flutter's `ChipButton`.
Widget bofChipButton({
  Key? key,
  required Widget child,
  VoidCallback? onPressed,
}) {
  return ChipButton(key: key, onPressed: onPressed, child: child);
}
