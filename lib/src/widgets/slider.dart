import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A slider. Wraps shadcn_flutter's `ControlledSlider`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
/// [trackColor] styles the inactive track and [activeColor] the filled
/// portion; both apply via the theme system since `Slider` has no direct
/// color params of its own.
Widget bofSliderField({
  Key? key,
  SliderValue initialValue = const SliderValue.single(0),
  SliderController? controller,
  double min = 0,
  double max = 1,
  int? divisions,
  bool enabled = true,
  ValueChanged<SliderValue>? onChanged,
  Color? trackColor,
  Color? activeColor,
  double? trackHeight,
}) {
  final slider = ControlledSlider(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    min: min,
    max: max,
    divisions: divisions,
    onChanged: onChanged,
  );
  if (trackColor == null && activeColor == null && trackHeight == null) {
    return slider;
  }
  return ComponentTheme<SliderTheme>(
    data: SliderTheme(
      trackColor: trackColor,
      valueColor: activeColor,
      trackHeight: trackHeight,
    ),
    child: slider,
  );
}
