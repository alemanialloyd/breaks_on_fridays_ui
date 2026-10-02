import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart' as skeleton;

/// Wraps [child] with a loading skeleton placeholder when [enabled] is true.
/// Uses skeletonizer directly so loading placeholders remain available across
/// shadcn_flutter versions. Leaf handling takes precedence for avatars/images,
/// followed by unite, replacement, and explicit leaf mode.
Widget bofSkeleton(
  Widget child, {
  Key? key,
  bool enabled = true,
  bool leaf = false,
  Widget? replacement,
  bool unite = false,
}) {
  final Widget placeholder;
  if (child is Avatar || child is Image) {
    placeholder = skeleton.Skeleton.leaf(enabled: enabled, child: child);
  } else if (unite) {
    placeholder = skeleton.Skeleton.unite(unite: enabled, child: child);
  } else if (replacement != null) {
    placeholder = skeleton.Skeleton.replace(
      replace: enabled,
      child: replacement,
    );
  } else if (leaf) {
    placeholder = skeleton.Skeleton.leaf(enabled: enabled, child: child);
  } else {
    placeholder = skeleton.Skeletonizer(enabled: enabled, child: child);
  }
  return KeyedSubtree(key: key, child: placeholder);
}
