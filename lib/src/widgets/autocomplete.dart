import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A text input with a suggestion popover. Wraps shadcn_flutter's
/// `AutoComplete` around a `TextField`.
Widget bofAutoCompleteField({
  Key? key,
  required List<String> suggestions,
  String? initialValue,
  Widget? placeholder,
  bool enabled = true,
  ValueChanged<String>? onChanged,
}) {
  return AutoComplete(
    key: key,
    suggestions: suggestions,
    child: TextField(
      initialValue: initialValue,
      placeholder: placeholder,
      enabled: enabled,
      onChanged: onChanged,
    ),
  );
}
