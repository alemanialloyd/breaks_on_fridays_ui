import 'package:shadcn_flutter/shadcn_flutter.dart';

/// The visual style of a [bofBadge].
enum BoFBadgeType { primary, secondary, outline, destructive }

/// A compact badge/tag. Wraps shadcn_flutter's `PrimaryBadge`/`SecondaryBadge`/
/// `OutlineBadge`/`DestructiveBadge`.
///
/// Pass [style] to fully override the badge's button styling regardless of
/// [type].
Widget bofBadge(
  Widget child, {
  Key? key,
  BoFBadgeType type = BoFBadgeType.primary,
  VoidCallback? onPressed,
  Widget? leading,
  Widget? trailing,
  AbstractButtonStyle? style,
}) {
  switch (type) {
    case BoFBadgeType.primary:
      return PrimaryBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: style,
        child: child,
      );
    case BoFBadgeType.secondary:
      return SecondaryBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: style,
        child: child,
      );
    case BoFBadgeType.outline:
      return OutlineBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: style,
        child: child,
      );
    case BoFBadgeType.destructive:
      return DestructiveBadge(
        key: key,
        onPressed: onPressed,
        leading: leading,
        trailing: trailing,
        style: style,
        child: child,
      );
  }
}
