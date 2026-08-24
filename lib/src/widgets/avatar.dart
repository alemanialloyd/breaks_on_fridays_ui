import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A circular avatar showing an image (via [photoUrl]) or [initials] as a
/// fallback. Wraps shadcn_flutter's `Avatar`/`Avatar.network`.
Widget bofAvatar({
  Key? key,
  required String initials,
  String? photoUrl,
  int? cacheWidth,
  int? cacheHeight,
  Color? backgroundColor,
  double? size,
  double? borderRadius,
  AvatarWidget? badge,
  AlignmentGeometry? badgeAlignment,
  double? badgeGap,
}) {
  if (photoUrl != null) {
    return Avatar.network(
      key: key,
      initials: initials,
      photoUrl: photoUrl,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      backgroundColor: backgroundColor,
      size: size,
      borderRadius: borderRadius,
      badge: badge,
      badgeAlignment: badgeAlignment,
      badgeGap: badgeGap,
    );
  }
  return Avatar(
    key: key,
    initials: initials,
    backgroundColor: backgroundColor,
    size: size,
    borderRadius: borderRadius,
    badge: badge,
    badgeAlignment: badgeAlignment,
    badgeGap: badgeGap,
  );
}
