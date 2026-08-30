import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../forms/bof_option.dart';

/// A single-choice radio group (or radio cards when [card] is true). Wraps
/// shadcn_flutter's `ControlledRadioGroup` combined with `RadioItem`/`RadioCard`.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue].
Widget bofRadioGroupField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  T? initialValue,
  RadioGroupController<T?>? controller,
  bool card = false,
  Axis direction = Axis.vertical,
  bool enabled = true,
  ValueChanged<T?>? onChanged,
}) {
  final items = [
    for (final option in options)
      card
          ? RadioCard<T>(
              value: option.value,
              enabled: enabled && option.enabled,
              child: option.label,
            )
          : RadioItem<T>(
              value: option.value,
              enabled: enabled && option.enabled,
              trailing: option.label,
            ),
  ];
  return ControlledRadioGroup<T>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
    child: direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: items)
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: items),
  );
}
