import 'package:shadcn_flutter/shadcn_flutter.dart';

/// An inline banner for messages/warnings. Wraps shadcn_flutter's `Alert`.
///
/// Pass [backgroundColor], [borderColor] and/or [padding] to override the
/// alert surface's default styling.
Widget bofAlert({
  Key? key,
  Widget? leading,
  Widget? title,
  Widget? content,
  Widget? trailing,
  bool destructive = false,
  Color? backgroundColor,
  Color? borderColor,
  EdgeInsetsGeometry? padding,
}) {
  final alert = Alert(
    key: key,
    leading: leading,
    title: title,
    content: content,
    trailing: trailing,
    destructive: destructive,
  );
  if (backgroundColor == null && borderColor == null && padding == null) {
    return alert;
  }
  return ComponentTheme<AlertTheme>(
    data: AlertTheme(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      padding: padding,
    ),
    child: alert,
  );
}
