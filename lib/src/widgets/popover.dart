import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Wraps [child] so a popover card shows on hover or long-press. Wraps
/// shadcn_flutter's `HoverCard`.
///
/// The common case is a plain [content] widget; pass [builder] instead if
/// the popover needs to be rebuilt per-show (it overrides [content]).
Widget bofPopover(
  Widget child, {
  Key? key,
  Widget? content,
  WidgetBuilder? builder,
  Duration? wait,
  Duration? debounce,
  AlignmentGeometry? alignment,
  AlignmentGeometry? anchorAlignment,
  Offset? offset,
}) {
  assert(
    content != null || builder != null,
    'bofPopover needs content or a builder.',
  );
  return HoverCard(
    key: key,
    hoverBuilder: builder ?? (context) => content!,
    wait: wait,
    debounce: debounce,
    popoverAlignment: alignment,
    anchorAlignment: anchorAlignment,
    popoverOffset: offset,
    child: child,
  );
}
