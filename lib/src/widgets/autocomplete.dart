import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A text input with a suggestion popover. Wraps shadcn_flutter's
/// `AutoComplete` around a `TextField`.
///
/// `AutoComplete` itself has no controller of its own; [controller] is
/// passed through to the inner `TextField` and, when provided, takes
/// precedence over [initialValue].
Widget bofAutoCompleteField({
  Key? key,
  required List<String> suggestions,
  String? initialValue,
  TextEditingController? controller,
  Widget? placeholder,
  bool enabled = true,
  ValueChanged<String>? onChanged,
}) {
  return AutoComplete(
    key: key,
    suggestions: suggestions,
    child: TextField(
      initialValue: initialValue,
      controller: controller,
      placeholder: placeholder,
      enabled: enabled,
      onChanged: onChanged,
    ),
  );
}
