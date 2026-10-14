import 'package:flutter/services.dart'
    show TextCapitalization, TextInputAction, TextInputFormatter;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';

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
/// Appearance options are shared with `BoFTextField`. Null values retain
/// inherited defaults. [backgroundColor] implies a fill unless [filled] is
/// explicitly false. Individual text overrides take precedence over [style];
/// [decoration] replaces the entire surface, including fill, border and radius.
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
  int? minLines,
  bool expands = false,
  int? maxLength,
  List<TextInputFormatter>? inputFormatters,
  bool enabled = true,
  bool readOnly = false,
  bool autofocus = false,
  FocusNode? focusNode,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  TextAlign textAlign = TextAlign.start,
  TextAlignVertical? textAlignVertical,
  TextDirection? textDirection,
  bool? filled,
  BorderRadiusGeometry? borderRadius,
  Border? border,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
  BoxDecoration? decoration,
  Color? selectionColor,
  Color? cursorColor,
  double cursorWidth = 2,
  double? cursorHeight,
  Radius cursorRadius = const Radius.circular(2),
  bool? showCursor,
}) {
  final effectiveFeatures = <InputFeature>[
    if (leadingIcon != null) InputFeature.leading(leadingIcon),
    if (trailingIcon != null) InputFeature.trailing(trailingIcon),
    if (showPasswordToggle) InputFeature.passwordToggle(mode: passwordPeekMode),
    ...?features,
  ];
  final input = BofTextFieldSurface.builder(
    color: backgroundColor,
    filled: filled,
    border: border,
    borderColor: borderColor,
    borderWidth: borderWidth,
    builder: (context, filled, border) => TextField(
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
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: bofFieldTextStyle(
        style,
        foregroundColor: foregroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      filled: filled,
      border: border,
      borderRadius: borderRadius,
      padding: padding,
      decoration: decoration,
      cursorColor: cursorColor,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      showCursor: showCursor,
    ),
  );
  return bofWithSelectionColor(selectionColor, input);
}

/// Scopes [selectionColor] to [child], or returns [child] when it is null.
Widget bofWithSelectionColor(Color? selectionColor, Widget child) {
  return selectionColor == null
      ? child
      : DefaultSelectionStyle.merge(
          selectionColor: selectionColor,
          child: child,
        );
}

/// A multi-line text input. Wraps shadcn_flutter's `TextArea`.
///
/// Pass [controller] to update the text programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Appearance options match [bofTextField] and are shared with
/// `BoFTextAreaField`.
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
  FontWeight? fontWeight,
  TextStyle? style,
  TextAlign textAlign = TextAlign.start,
  TextAlignVertical? textAlignVertical,
  TextDirection? textDirection,
  bool? filled,
  BorderRadiusGeometry? borderRadius,
  Border? border,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
  BoxDecoration? decoration,
  Color? selectionColor,
  Color? cursorColor,
  double cursorWidth = 2,
  double? cursorHeight,
  Radius cursorRadius = const Radius.circular(2),
  bool? showCursor,
}) {
  return bofWithSelectionColor(
    selectionColor,
    BofTextFieldSurface.builder(
      color: backgroundColor,
      filled: filled,
      border: border,
      borderColor: borderColor,
      borderWidth: borderWidth,
      builder: (context, filled, border) => TextArea(
        key: key,
        initialValue: initialValue,
        controller: controller,
        placeholder: placeholder,
        minHeight: minHeight,
        maxHeight: maxHeight,
        enabled: enabled,
        onChanged: onChanged,
        style: bofFieldTextStyle(
          style,
          foregroundColor: foregroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        textDirection: textDirection,
        filled: filled,
        border: border,
        borderRadius: borderRadius,
        padding: padding,
        decoration: decoration,
        cursorColor: cursorColor,
        cursorWidth: cursorWidth,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        showCursor: showCursor,
      ),
    ),
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
/// Appearance options match [bofTextField] and are shared with
/// `BoFNumberField`.
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
  FontWeight? fontWeight,
  TextStyle? style,
  TextAlign textAlign = TextAlign.start,
  TextAlignVertical? textAlignVertical,
  TextDirection? textDirection,
  bool? filled,
  BorderRadiusGeometry? borderRadius,
  Border? border,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
  BoxDecoration? decoration,
  Color? selectionColor,
  Color? cursorColor,
  double cursorWidth = 2,
  double? cursorHeight,
  Radius cursorRadius = const Radius.circular(2),
  bool? showCursor,
}) {
  return bofWithSelectionColor(
    selectionColor,
    BofTextFieldSurface.builder(
      color: backgroundColor,
      filled: filled,
      border: border,
      borderColor: borderColor,
      borderWidth: borderWidth,
      builder: (context, filled, border) => TextField(
        key: key,
        initialValue: initialValue?.toString(),
        controller: controller,
        placeholder: placeholder,
        enabled: enabled,
        keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
        onChanged: onChanged == null
            ? null
            : (text) => onChanged(num.tryParse(text)),
        style: bofFieldTextStyle(
          style,
          foregroundColor: foregroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        textDirection: textDirection,
        filled: filled,
        border: border,
        borderRadius: borderRadius,
        padding: padding,
        decoration: decoration,
        cursorColor: cursorColor,
        cursorWidth: cursorWidth,
        cursorHeight: cursorHeight,
        cursorRadius: cursorRadius,
        showCursor: showCursor,
      ),
    ),
  );
}
