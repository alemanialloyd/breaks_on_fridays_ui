import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../forms/bof_option.dart';

/// A single-choice radio group (or radio cards when [card] is true). Wraps
/// shadcn_flutter's `ControlledRadioGroup` combined with `RadioItem`/`RadioCard`.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue].
///
/// [color], [hoverColor], [borderWidth] and [borderRadius] only affect
/// [RadioCard] (i.e. when [card] is true) — plain [RadioItem]s have no
/// styling surface upstream.
Widget bofRadioGroupField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  T? initialValue,
  RadioGroupController<T?>? controller,
  bool card = false,
  Axis direction = Axis.vertical,
  bool enabled = true,
  ValueChanged<T?>? onChanged,
  Color? color,
  Color? hoverColor,
  double? borderWidth,
  BorderRadiusGeometry? borderRadius,
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
  final group = ControlledRadioGroup<T>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    onChanged: onChanged,
    child: direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: items)
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: items),
  );
  if (!card ||
      (color == null &&
          hoverColor == null &&
          borderWidth == null &&
          borderRadius == null)) {
    return group;
  }
  return ComponentTheme<RadioCardTheme>(
    data: RadioCardTheme(
      color: color,
      hoverColor: hoverColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
    ),
    child: group,
  );
}
