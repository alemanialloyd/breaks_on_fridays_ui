import 'package:shadcn_flutter/shadcn_flutter.dart';

/// An inline banner for messages/warnings. Wraps shadcn_flutter's `Alert`.
Widget bofAlert({
  Key? key,
  Widget? leading,
  Widget? title,
  Widget? content,
  Widget? trailing,
  bool destructive = false,
}) {
  return Alert(
    key: key,
    leading: leading,
    title: title,
    content: content,
    trailing: trailing,
    destructive: destructive,
  );
}
