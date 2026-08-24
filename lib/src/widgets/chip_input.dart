import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A free-form list of chips parsed from typed text. Wraps shadcn_flutter's
/// `ChipInput`.
Widget bofChipInputField<T extends Object>({
  Key? key,
  required Widget Function(BuildContext context, T value) chipBuilder,
  required T? Function(String text) onChipSubmitted,
  List<T>? initialValue,
  bool enabled = true,
  ValueChanged<List<T>>? onChanged,
}) {
  return ChipInput<T>(
    key: key,
    initialChips: initialValue,
    chipBuilder: chipBuilder,
    onChipSubmitted: onChipSubmitted,
    onChipsChanged: onChanged,
    enabled: enabled,
  );
}
