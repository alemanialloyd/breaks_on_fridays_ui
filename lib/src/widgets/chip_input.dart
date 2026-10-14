import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';
import 'input.dart' show bofWithSelectionColor;

/// A free-form list of chips parsed from typed text. Wraps shadcn_flutter's
/// `ChipInput`.
///
/// Pass [controller] to update the chips/text programmatically; when
/// provided it takes precedence over [initialValue].
///
/// Appearance options match `BoF.textField` and are shared with
/// `BoFChipInputField`. Text options style the typed text, not the chips,
/// which come from [chipBuilder].
Widget bofChipInputField<T extends Object>({
  Key? key,
  required Widget Function(BuildContext context, T value) chipBuilder,
  required T? Function(String text) onChipSubmitted,
  List<T>? initialValue,
  ChipEditingController<T>? controller,
  bool enabled = true,
  ValueChanged<List<T>>? onChanged,
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
      builder: (context, filled, border) => ChipInput<T>(
        key: key,
        initialChips: initialValue,
        controller: controller,
        chipBuilder: chipBuilder,
        onChipSubmitted: onChipSubmitted,
        onChipsChanged: onChanged,
        enabled: enabled,
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
