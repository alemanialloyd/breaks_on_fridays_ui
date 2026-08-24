import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A compact tag/filter chip. Wraps shadcn_flutter's `Chip`.
///
/// Pass [style] to override the chip's button styling.
Widget bofChip(
  Widget child, {
  Key? key,
  Widget? leading,
  Widget? trailing,
  VoidCallback? onPressed,
  AbstractButtonStyle? style,
}) {
  return Chip(
    key: key,
    leading: leading,
    trailing: trailing,
    onPressed: onPressed,
    style: style,
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
