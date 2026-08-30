import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A slider. Wraps shadcn_flutter's `ControlledSlider`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofSliderField({
  Key? key,
  SliderValue initialValue = const SliderValue.single(0),
  SliderController? controller,
  double min = 0,
  double max = 1,
  int? divisions,
  bool enabled = true,
  ValueChanged<SliderValue>? onChanged,
}) {
  return ControlledSlider(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    min: min,
    max: max,
    divisions: divisions,
    onChanged: onChanged,
  );
}
