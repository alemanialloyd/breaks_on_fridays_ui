import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A slider. Wraps shadcn_flutter's `ControlledSlider`.
Widget bofSliderField({
  Key? key,
  SliderValue initialValue = const SliderValue.single(0),
  double min = 0,
  double max = 1,
  int? divisions,
  bool enabled = true,
  ValueChanged<SliderValue>? onChanged,
}) {
  return ControlledSlider(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    min: min,
    max: max,
    divisions: divisions,
    onChanged: onChanged,
  );
}
