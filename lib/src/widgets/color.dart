import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A color swatch input. Wraps shadcn_flutter's `ControlledColorInput`.
///
/// shadcn_flutter represents colors internally as `ColorDerivative`; this
/// converts to/from [Color] at the boundary so callers only ever deal with
/// plain [Color] values.
Widget bofColorField({
  Key? key,
  Color initialValue = const Color(0xFF000000),
  bool showAlpha = false,
  bool enabled = true,
  ValueChanged<Color>? onChanged,
}) {
  return ControlledColorInput(
    key: key,
    initialValue: ColorDerivative.fromColor(initialValue),
    enabled: enabled,
    showAlpha: showAlpha,
    onChanged: onChanged == null
        ? null
        : (derivative) => onChanged(derivative.toColor()),
  );
}
