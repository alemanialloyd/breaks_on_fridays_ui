import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A color swatch input. Wraps shadcn_flutter's `ControlledColorInput`.
///
/// shadcn_flutter represents colors internally as `ColorDerivative`; this
/// converts to/from [Color] at the boundary so callers only ever deal with
/// plain [Color] values.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue]. Note the controller itself deals in
/// `ColorDerivative` (via `ColorInputController.setColor`), not [Color].
Widget bofColorField({
  Key? key,
  Color initialValue = const Color(0xFF000000),
  ColorInputController? controller,
  bool showAlpha = false,
  bool enabled = true,
  ValueChanged<Color>? onChanged,
}) {
  return ControlledColorInput(
    key: key,
    initialValue: ColorDerivative.fromColor(initialValue),
    controller: controller,
    enabled: enabled,
    showAlpha: showAlpha,
    onChanged: onChanged == null
        ? null
        : (derivative) => onChanged(derivative.toColor()),
  );
}
