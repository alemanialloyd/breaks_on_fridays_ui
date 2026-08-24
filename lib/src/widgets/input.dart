import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A single-line text input. Wraps shadcn_flutter's `TextField`.
Widget bofTextField({
  Key? key,
  String? initialValue,
  Widget? placeholder,
  bool obscureText = false,
  TextInputType? keyboardType,
  int? maxLines = 1,
  bool enabled = true,
  ValueChanged<String>? onChanged,
}) {
  return TextField(
    key: key,
    initialValue: initialValue,
    placeholder: placeholder,
    obscureText: obscureText,
    keyboardType: keyboardType,
    maxLines: maxLines,
    enabled: enabled,
    onChanged: onChanged,
  );
}

/// A multi-line text input. Wraps shadcn_flutter's `TextArea`.
Widget bofTextAreaField({
  Key? key,
  String? initialValue,
  Widget? placeholder,
  double minHeight = 100,
  double maxHeight = double.infinity,
  bool enabled = true,
  ValueChanged<String>? onChanged,
}) {
  return TextArea(
    key: key,
    initialValue: initialValue,
    placeholder: placeholder,
    minHeight: minHeight,
    maxHeight: maxHeight,
    enabled: enabled,
    onChanged: onChanged,
  );
}

/// A numeric text input.
///
/// shadcn_flutter has no dedicated number-input widget, so this wraps
/// `TextField` with a numeric keyboard and parses the text to [num].
Widget bofNumberField({
  Key? key,
  num? initialValue,
  Widget? placeholder,
  bool allowDecimal = true,
  bool enabled = true,
  ValueChanged<num?>? onChanged,
}) {
  return TextField(
    key: key,
    initialValue: initialValue?.toString(),
    placeholder: placeholder,
    enabled: enabled,
    keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
    onChanged: onChanged == null
        ? null
        : (text) => onChanged(num.tryParse(text)),
  );
}
