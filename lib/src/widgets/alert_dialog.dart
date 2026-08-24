import 'package:flutter/material.dart' show showDialog;
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
  bool barrierDismissible = true,
}) {
  final effectiveTitle = titleWidget ?? (title == null ? null : bofText(title));
  final effectiveContent =
      contentWidget ?? (content == null ? null : bofText(content));

  return showDialog<Object?>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      // Built with dialogContext (not the outer context) so the default
      // buttons pop the dialog's own route, even if the caller's context
      // sits inside a different Navigator than the one showDialog used.
      final effectiveActions = actions ??
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
      return AlertDialog(
        leading: leading,
        title: effectiveTitle,
        content: effectiveContent,
        actions: effectiveActions.isEmpty ? null : effectiveActions,
      );
    },
  );
}
