import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A single item in a [bofDropdownMenu].
class BoFMenuItem {
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final bool enabled;
  final List<BoFMenuItem>? subMenu;

  const BoFMenuItem({
    required this.child,
    this.leading,
    this.trailing,
    this.onPressed,
    this.enabled = true,
    this.subMenu,
  });
}

List<MenuButton> _buildMenuButtons(List<BoFMenuItem> items) {
  return [
    for (final item in items)
      MenuButton(
        leading: item.leading,
        trailing: item.trailing,
        enabled: item.enabled,
        subMenu: item.subMenu == null ? null : _buildMenuButtons(item.subMenu!),
        onPressed: item.onPressed == null ? null : (context) => item.onPressed!(),
        child: item.child,
      ),
  ];
}

/// Shows a dropdown menu anchored near [context]. Wraps shadcn_flutter's
/// `showDropdown`/`DropdownMenu`/`MenuButton`.
///
/// Typically opened from a [BoF.button]'s `onPressed`:
/// ```dart
/// BoF.button('Actions', onPressed: () => BoF.dropdownMenu(
///   context,
///   items: [
///     BoFMenuItem(child: BoF.text('Edit'), onPressed: edit),
///     BoFMenuItem(child: BoF.text('Delete'), onPressed: delete),
///   ],
/// ));
/// ```
OverlayCompleter<Object?> bofDropdownMenu(
  BuildContext context, {
  required List<BoFMenuItem> items,
  AlignmentGeometry? alignment,
  AlignmentGeometry? anchorAlignment,
  Offset? offset,
  bool modal = true,
  bool consumeOutsideTaps = false,
}) {
  return showDropdown<Object?>(
    context: context,
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    offset: offset,
    modal: modal,
    consumeOutsideTaps: consumeOutsideTaps,
    builder: (context) => DropdownMenu(children: _buildMenuButtons(items)),
  );
}
