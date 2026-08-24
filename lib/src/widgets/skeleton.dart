import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Wraps [child] with a loading skeleton placeholder when [enabled] is true.
/// Wraps shadcn_flutter's `SkeletonExtension.asSkeleton`.
Widget bofSkeleton(
  Widget child, {
  Key? key,
  bool enabled = true,
  bool leaf = false,
  Widget? replacement,
  bool unite = false,
}) {
  return KeyedSubtree(
    key: key,
    child: child.asSkeleton(
      enabled: enabled,
      leaf: leaf,
      replacement: replacement,
      unite: unite,
    ),
  );
}
