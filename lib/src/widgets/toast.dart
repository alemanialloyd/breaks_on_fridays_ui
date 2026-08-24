import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'alert.dart';
import 'button.dart';
import 'text.dart';

/// Shows a toast notification. Wraps shadcn_flutter's `showToast`, defaulting
/// its content to [bofAlert] for consistent styling with `BoF.alertDialog`.
///
/// The common case is plain strings ([title]/[message]); pass [content] or
/// [builder] instead for a fully custom toast body ([builder] overrides
/// [content], which overrides [title]/[message]).
///
/// Requires a [ToastLayer] ancestor — shadcn_flutter's `ShadcnApp` already
/// provides one, so no extra setup is needed under it.
ToastOverlay bofToast(
  BuildContext context, {
  String? title,
  String? message,
  Widget? content,
  ToastBuilder? builder,
  bool destructive = false,
  ToastLocation location = ToastLocation.bottomRight,
  bool dismissible = true,
  Curve curve = Curves.easeOutCubic,
  Duration entryDuration = const Duration(milliseconds: 500),
  Duration showDuration = const Duration(seconds: 5),
  VoidCallback? onClosed,
}) {
  return showToast(
    context: context,
    location: location,
    dismissible: dismissible,
    curve: curve,
    entryDuration: entryDuration,
    showDuration: showDuration,
    onClosed: onClosed,
    builder: builder ??
        (context, overlay) => bofAlert(
              title: title == null ? null : bofText(title),
              content: content ?? (message == null ? null : bofText(message)),
              destructive: destructive,
              trailing: dismissible
                  ? bofButton(
                      null,
                      icon: const Icon(Icons.close),
                      type: BoFButtonType.ghost,
                      onPressed: overlay.close,
                    )
                  : null,
            ),
  );
}
