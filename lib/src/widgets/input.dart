import 'package:flutter/services.dart'
    show TextCapitalization, TextInputAction, TextInputFormatter;
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
  final input = _TextFieldBackground(
    color: backgroundColor,
    filled: filled,
    border: border,
    borderColor: borderColor,
    borderWidth: borderWidth,
    child: TextField(
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
      style: foregroundColor == null && fontSize == null && fontWeight == null
          ? style
          : (style ?? const TextStyle()).copyWith(
              color: foregroundColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      filled: filled,
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
  return selectionColor == null
      ? input
      : DefaultSelectionStyle.merge(
          selectionColor: selectionColor,
          child: input,
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
  return _TextFieldBackground(
    color: backgroundColor,
    child: TextArea(
      key: key,
      initialValue: initialValue,
      controller: controller,
      placeholder: placeholder,
      minHeight: minHeight,
      maxHeight: maxHeight,
      enabled: enabled,
      onChanged: onChanged,
      style: foregroundColor == null && fontSize == null
          ? null
          : TextStyle(color: foregroundColor, fontSize: fontSize),
      borderRadius: borderRadius,
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
  return _TextFieldBackground(
    color: backgroundColor,
    child: TextField(
      key: key,
      initialValue: initialValue?.toString(),
      controller: controller,
      placeholder: placeholder,
      enabled: enabled,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      onChanged: onChanged == null
          ? null
          : (text) => onChanged(num.tryParse(text)),
      style: foregroundColor == null && fontSize == null
          ? null
          : TextStyle(color: foregroundColor, fontSize: fontSize),
      borderRadius: borderRadius,
    ),
  );
}

/// Applies a field-local fill without replacing shadcn's decoration.
///
/// `TextField.decoration` is a complete decoration override, so using it for a
/// color alone also removes the border, radius, and any component-theme
/// styling. A filled shadcn field gets its color from `colorScheme.muted`; this
/// scopes that color to one field and retains the surrounding text-field theme.
class _TextFieldBackground extends StatelessWidget {
  const _TextFieldBackground({
    required this.color,
    required this.child,
    this.filled,
    this.border,
    this.borderColor,
    this.borderWidth,
  });

  final Color? color;
  final bool? filled;
  final Border? border;
  final Color? borderColor;
  final double? borderWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (color == null &&
        filled == null &&
        border == null &&
        borderColor == null &&
        borderWidth == null) {
      return child;
    }

    final theme = Theme.of(context);
    final fieldTheme = ComponentTheme.maybeOf<TextFieldTheme>(context);
    var effectiveBorder = border ?? fieldTheme?.border;
    if (borderColor != null || borderWidth != null) {
      final base =
          effectiveBorder ??
          Border.all(
            color: theme.colorScheme.border,
            strokeAlign: BorderSide.strokeAlignCenter,
          );
      BorderSide overrideSide(BorderSide side) =>
          side.copyWith(color: borderColor, width: borderWidth);
      effectiveBorder = Border(
        top: overrideSide(base.top),
        bottom: overrideSide(base.bottom),
        left: overrideSide(base.left),
        right: overrideSide(base.right),
      );
    }
    return Theme(
      data: color == null
          ? theme
          : theme.copyWith(
              colorScheme: () =>
                  theme.colorScheme.copyWith(muted: () => color!),
            ),
      child: ComponentTheme<TextFieldTheme>(
        data: (fieldTheme ?? const TextFieldTheme()).copyWith(
          filled: () => filled ?? (color != null ? true : fieldTheme?.filled),
          border: () => effectiveBorder,
        ),
        child: child,
      ),
    );
  }
}
