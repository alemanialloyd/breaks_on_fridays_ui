import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'button.dart';
import 'text.dart';

/// Shows a styled alert dialog, built on shadcn_flutter's `AlertDialog`.
///
/// The common case just needs plain strings:
/// ```dart
/// final confirmed = await BoF.alertDialog(
///   context,
///   title: 'Delete item',
///   content: 'This action cannot be undone.',
///   positiveText: 'Delete',
///   negativeText: 'Cancel',
///   positiveType: BoFButtonType.destructive,
/// );
/// if (confirmed == true) { ... }
/// ```
///
/// For anything the string params can't express, pass a widget instead —
/// [titleWidget]/[contentWidget] override [title]/[content], and [actions]
/// overrides [positiveText]/[negativeText] entirely. Button styling for the
/// default positive/negative buttons reuses [BoFButtonType] (the same enum
/// [bofButton] uses) via [positiveType]/[negativeType], rather than
/// introducing a separate enum for it.
///
/// Use [padding] to override the dialog's internal content padding and
/// [trailing] to add a widget at the end of its header.
/// [borderRadius] overrides the modal surface and backdrop shape.
/// [surfaceBlur]/[surfaceOpacity] default to the app theme; [barrierColor]
/// defaults to the upstream backdrop color.
Future<Object?> bofAlertDialog(
  BuildContext context, {
  String? title,
  Widget? titleWidget,
  String? content,
  Widget? contentWidget,
  String? positiveText,
  String? negativeText,
  VoidCallback? onPositive,
  VoidCallback? onNegative,
  List<Widget>? actions,
  BoFButtonType positiveType = BoFButtonType.primary,
  BoFButtonType negativeType = BoFButtonType.outline,
  Widget? leading,
  Widget? trailing,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
  double? surfaceBlur,
  double? surfaceOpacity,
  Color? barrierColor,
  bool barrierDismissible = true,
}) {
  final effectiveTitle = titleWidget ?? (title == null ? null : bofText(title));
  final effectiveContent =
      contentWidget ?? (content == null ? null : bofText(content));

  return showGeneralDialog<Object?>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    pageBuilder: (dialogContext, _, _) {
      // Built with dialogContext (not the outer context) so the default
      // buttons pop the dialog's own route, even if the caller's context
      // sits inside a different Navigator than the route used here.
      final effectiveActions =
          actions ??
          [
            if (negativeText != null)
              bofButton(
                negativeText,
                type: negativeType,
                onPressed: () {
                  if (onNegative != null) {
                    onNegative();
                  } else {
                    Navigator.pop(dialogContext, false);
                  }
                },
              ),
            if (positiveText != null)
              bofButton(
                positiveText,
                type: positiveType,
                onPressed: () {
                  if (onPositive != null) {
                    onPositive();
                  } else {
                    Navigator.pop(dialogContext, true);
                  }
                },
              ),
          ];
      // The general route works under ShadcnApp without requiring Material
      // localizations. Center keeps the dialog shrink-wrapped on web, while
      // SafeArea prevents it from overlapping system UI on mobile.
      return SafeArea(
        child: Center(
          child: borderRadius != null
              ? _RadiusAlertDialog(
                  borderRadius: borderRadius,
                  leading: leading,
                  trailing: trailing,
                  title: effectiveTitle,
                  content: effectiveContent,
                  actions: effectiveActions,
                  padding: padding,
                  surfaceBlur: surfaceBlur,
                  surfaceOpacity: surfaceOpacity,
                  barrierColor: barrierColor,
                )
              : AlertDialog(
                  leading: leading,
                  trailing: trailing,
                  title: effectiveTitle,
                  content: effectiveContent,
                  actions: effectiveActions.isEmpty ? null : effectiveActions,
                  padding: padding,
                  surfaceBlur: surfaceBlur,
                  surfaceOpacity: surfaceOpacity,
                  barrierColor: barrierColor,
                ),
        ),
      );
    },
  );
}

// AlertDialog in shadcn_flutter 0.0.53 has no radius parameter. Keep its
// layout and modal behavior while setting the same shape on both layers.
class _RadiusAlertDialog extends StatelessWidget {
  const _RadiusAlertDialog({
    required this.borderRadius,
    required this.actions,
    this.leading,
    this.trailing,
    this.title,
    this.content,
    this.padding,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.barrierColor,
  });

  final BorderRadiusGeometry borderRadius;
  final List<Widget> actions;
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? content;
  final EdgeInsetsGeometry? padding;
  final double? surfaceBlur;
  final double? surfaceOpacity;
  final Color? barrierColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gap = theme.density.baseGap * theme.scaling;
    return ModalBackdrop(
      borderRadius: borderRadius,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.8),
      surfaceClip: ModalBackdrop.shouldClipSurface(
        surfaceOpacity ?? theme.surfaceOpacity,
      ),
      child: ModalContainer(
        fillColor: theme.colorScheme.popover,
        filled: true,
        borderRadius: borderRadius,
        borderWidth: theme.scaling,
        borderColor: theme.colorScheme.muted,
        padding:
            padding ??
            EdgeInsets.all(
              theme.density.baseContainerPadding * theme.scaling * 1.5,
            ),
        surfaceBlur: surfaceBlur ?? theme.surfaceBlur,
        surfaceOpacity: surfaceOpacity ?? theme.surfaceOpacity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null)
                    leading!.iconXLarge().iconMutedForeground(),
                  if (title != null || content != null)
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null) title!.large().semiBold(),
                          if (content != null) content!.small().muted(),
                        ],
                      ).gap(gap),
                    ),
                  if (trailing != null)
                    trailing!.iconXLarge().iconMutedForeground(),
                ],
              ).gap(gap * 2),
            ),
            if (actions.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: join(actions, SizedBox(width: gap)).toList(),
              ),
          ],
        ).gap(gap * 2),
      ),
    );
  }
}
