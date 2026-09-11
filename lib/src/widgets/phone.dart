import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A phone number input. Wraps shadcn_flutter's `PhoneInput`.
///
/// `PhoneInput` has no `enabled` parameter upstream, so this cannot be
/// disabled.
///
/// [controller] is a plain `TextEditingController` managing the raw number
/// text (not the [PhoneNumber] value); PhoneInput has no dedicated value
/// controller upstream. When provided it takes precedence over [initialValue].
///
/// `PhoneInput` has no background/border/text style params upstream, so
/// this widget has no styling surface to expose.
Widget bofPhoneField({
  Key? key,
  PhoneNumber? initialValue,
  TextEditingController? controller,
  ValueChanged<PhoneNumber?>? onChanged,
}) {
  return PhoneInput(
    key: key,
    initialValue: initialValue,
    controller: controller,
    onChanged: onChanged,
  );
}
