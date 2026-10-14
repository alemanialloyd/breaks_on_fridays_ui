import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';

/// A color swatch input. Wraps shadcn_flutter's `ControlledColorInput`.
///
/// shadcn_flutter represents colors internally as `ColorDerivative`; this
/// converts to/from [Color] at the boundary so callers only ever deal with
/// plain [Color] values.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue]. Note the controller itself deals in
/// `ColorDerivative` (via `ColorInputController.setColor`), not [Color].
///
/// The appearance options restyle the swatch's trigger button only; the color
/// picker it opens keeps its themed look. [foregroundColor]/[fontSize]/
/// [fontWeight] override the matching properties of [style].
Widget bofColorField({
  Key? key,
  Color initialValue = const Color(0xFF000000),
  ColorInputController? controller,
  bool showAlpha = false,
  bool enabled = true,
  ValueChanged<Color>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  return BofTriggerStyle(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    style: style,
    borderRadius: borderRadius,
    borderColor: borderColor,
    borderWidth: borderWidth,
    padding: padding,
    child: ControlledColorInput(
      key: key,
      initialValue: ColorDerivative.fromColor(initialValue),
      controller: controller,
      enabled: enabled,
      showAlpha: showAlpha,
      onChanged: onChanged == null
          ? null
          : (derivative) => onChanged(derivative.toColor()),
    ),
  );
}
