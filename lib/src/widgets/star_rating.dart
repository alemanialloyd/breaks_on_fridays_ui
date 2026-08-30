import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A star rating. Wraps shadcn_flutter's `ControlledStarRating`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
Widget bofStarRatingField({
  Key? key,
  double initialValue = 0,
  StarRatingController? controller,
  double max = 5,
  double step = 0.5,
  bool enabled = true,
  ValueChanged<double>? onChanged,
}) {
  return ControlledStarRating(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    max: max,
    step: step,
    onChanged: onChanged,
  );
}
