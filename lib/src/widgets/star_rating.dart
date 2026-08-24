import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A star rating. Wraps shadcn_flutter's `ControlledStarRating`.
Widget bofStarRatingField({
  Key? key,
  double initialValue = 0,
  double max = 5,
  double step = 0.5,
  bool enabled = true,
  ValueChanged<double>? onChanged,
}) {
  return ControlledStarRating(
    key: key,
    initialValue: initialValue,
    enabled: enabled,
    max: max,
    step: step,
    onChanged: onChanged,
  );
}
