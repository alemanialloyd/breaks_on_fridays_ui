import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';

/// A phone number input. Wraps shadcn_flutter's `PhoneInput`.
///
/// `PhoneInput` has no `enabled` parameter upstream, so this cannot be
/// disabled.
///
/// [controller] is a plain `TextEditingController` managing the raw number
/// text (not the [PhoneNumber] value); PhoneInput has no dedicated value
/// controller upstream. When provided it takes precedence over [initialValue].
///
/// `PhoneInput` builds its country button and number field internally, so the
/// surface options are applied through their component themes:
/// [backgroundColor], [borderColor] and [borderWidth] style both halves, while
/// [filled], [border] and [padding] apply to the number field. These behave
/// like the matching `BoF.textField` options, except that the country list
/// popup also inherits [backgroundColor] as its hover color. The number's text
/// style has no upstream hook and follows the theme.
Widget bofPhoneField({
  Key? key,
  PhoneNumber? initialValue,
  TextEditingController? controller,
  ValueChanged<PhoneNumber?>? onChanged,
  Color? backgroundColor,
  bool? filled,
  Border? border,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  return BofTriggerStyle(
    backgroundColor: backgroundColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    child: BofTextFieldSurface(
      color: backgroundColor,
      filled: filled,
      border: border,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
      child: PhoneInput(
        key: key,
        initialValue: initialValue,
        controller: controller,
        onChanged: onChanged,
      ),
    ),
  );
}
