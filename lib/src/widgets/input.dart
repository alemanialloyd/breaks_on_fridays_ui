import 'package:flutter/services.dart' show TextCapitalization, TextInputAction;
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A single-line text input. Wraps shadcn_flutter's `TextField`.
///
/// [obscureText] defaults to matching [showPasswordToggle] when not set
/// explicitly, so `showPasswordToggle: true` alone gives you a normal masked
/// password field with a reveal button; pass `obscureText: false` too if you
/// want it to start revealed but stay toggleable.
///
/// Pass [controller] to update the text programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Pass [backgroundColor], [foregroundColor], [fontSize] and/or
/// [borderRadius] to override the field's default styling.
Widget bofTextField({
  Key? key,
  String? initialValue,
  TextEditingController? controller,
  Widget? placeholder,
  Widget? leadingIcon,
  Widget? trailingIcon,
  bool? obscureText,
  bool showPasswordToggle = false,
  PasswordPeekMode passwordPeekMode = PasswordPeekMode.toggle,
  List<InputFeature>? features,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  TextCapitalization textCapitalization = TextCapitalization.none,
  int? maxLines = 1,
  int? maxLength,
  bool enabled = true,
  bool readOnly = false,
  bool autofocus = false,
  FocusNode? focusNode,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  BorderRadiusGeometry? borderRadius,
}) {
  final effectiveFeatures = <InputFeature>[
    if (leadingIcon != null) InputFeature.leading(leadingIcon),
    if (trailingIcon != null) InputFeature.trailing(trailingIcon),
    if (showPasswordToggle) InputFeature.passwordToggle(mode: passwordPeekMode),
    ...?features,
  ];
  return TextField(
    key: key,
    initialValue: initialValue,
    controller: controller,
    placeholder: placeholder,
    obscureText: obscureText ?? showPasswordToggle,
    features: effectiveFeatures,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    textCapitalization: textCapitalization,
    maxLines: maxLines,
    maxLength: maxLength,
    enabled: enabled,
    readOnly: readOnly,
    autofocus: autofocus,
    focusNode: focusNode,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    decoration: backgroundColor == null ? null : BoxDecoration(color: backgroundColor),
    style: foregroundColor == null && fontSize == null
        ? null
        : TextStyle(color: foregroundColor, fontSize: fontSize),
    borderRadius: borderRadius,
  );
}

/// A multi-line text input. Wraps shadcn_flutter's `TextArea`.
///
/// Pass [controller] to update the text programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Pass [backgroundColor], [foregroundColor], [fontSize] and/or
/// [borderRadius] to override the field's default styling.
Widget bofTextAreaField({
  Key? key,
  String? initialValue,
  TextEditingController? controller,
  Widget? placeholder,
  double minHeight = 100,
  double maxHeight = double.infinity,
  bool enabled = true,
  ValueChanged<String>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  BorderRadiusGeometry? borderRadius,
}) {
  return TextArea(
    key: key,
    initialValue: initialValue,
    controller: controller,
    placeholder: placeholder,
    minHeight: minHeight,
    maxHeight: maxHeight,
    enabled: enabled,
    onChanged: onChanged,
    decoration: backgroundColor == null ? null : BoxDecoration(color: backgroundColor),
    style: foregroundColor == null && fontSize == null
        ? null
        : TextStyle(color: foregroundColor, fontSize: fontSize),
    borderRadius: borderRadius,
  );
}

/// A numeric text input.
///
/// shadcn_flutter has no dedicated number-input widget, so this wraps
/// `TextField` with a numeric keyboard and parses the text to [num].
///
/// Pass [controller] to update the text programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Pass [backgroundColor], [foregroundColor], [fontSize] and/or
/// [borderRadius] to override the field's default styling.
Widget bofNumberField({
  Key? key,
  num? initialValue,
  TextEditingController? controller,
  Widget? placeholder,
  bool allowDecimal = true,
  bool enabled = true,
  ValueChanged<num?>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  BorderRadiusGeometry? borderRadius,
}) {
  return TextField(
    key: key,
    initialValue: initialValue?.toString(),
    controller: controller,
    placeholder: placeholder,
    enabled: enabled,
    keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
    onChanged: onChanged == null
        ? null
        : (text) => onChanged(num.tryParse(text)),
    decoration: backgroundColor == null ? null : BoxDecoration(color: backgroundColor),
    style: foregroundColor == null && fontSize == null
        ? null
        : TextStyle(color: foregroundColor, fontSize: fontSize),
    borderRadius: borderRadius,
  );
}
