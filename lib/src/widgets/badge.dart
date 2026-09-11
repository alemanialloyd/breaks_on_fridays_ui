import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../extensions/style_override.dart';

/// The visual style of a [bofBadge].
enum BoFBadgeType { primary, secondary, outline, destructive }

const _badgeSize = ButtonSize.small;
const _badgeDensity = ButtonDensity.dense;

AbstractButtonStyle _defaultBadgeStyle(BoFBadgeType type) {
  switch (type) {
    case BoFBadgeType.primary:
      return const ButtonStyle.primary(size: _badgeSize, density: _badgeDensity);
    case BoFBadgeType.secondary:
      return const ButtonStyle.secondary(size: _badgeSize, density: _badgeDensity);
    case BoFBadgeType.outline:
      return const ButtonStyle.outline(size: _badgeSize, density: _badgeDensity);
    case BoFBadgeType.destructive:
      return const ButtonStyle.destructive(size: _badgeSize, density: _badgeDensity);
  }
}

/// A compact badge/tag. Wraps shadcn_flutter's `PrimaryBadge`/`SecondaryBadge`/
/// `OutlineBadge`/`DestructiveBadge`.
///
/// Pass [style] to fully override the badge's button styling regardless of
/// [type], or use [backgroundColor], [foregroundColor], [fontSize],
/// [fontWeight] and/or [borderRadius] to tweak individual pieces of [type]'s
/// default styling instead ([style], if provided, takes precedence).
Widget bofBadge(
  Widget child, {
  Key? key,
  BoFBadgeType type = BoFBadgeType.primary,
  VoidCallback? onPressed,
  Widget? leading,
  Widget? trailing,
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
  final effectiveStyle = style ??
      (hasOverride
          ? bofButtonStyle(
              _defaultBadgeStyle(type),
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              borderRadius: borderRadius,
            )
          : null);
  switch (type) {
    case BoFBadgeType.primary:
      return PrimaryBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: effectiveStyle,
        child: child,
      );
    case BoFBadgeType.secondary:
      return SecondaryBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: effectiveStyle,
        child: child,
      );
    case BoFBadgeType.outline:
      return OutlineBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: effectiveStyle,
        child: child,
      );
    case BoFBadgeType.destructive:
      return DestructiveBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: effectiveStyle,
        child: child,
      );
  }
}
