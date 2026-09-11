import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A horizontal progress bar. Wraps shadcn_flutter's `Progress`.
///
/// [progress] is null for an indeterminate (continuously animating) bar.
Widget bofProgress({
  Key? key,
  double? progress,
  double min = 0.0,
  double max = 1.0,
  bool disableAnimation = false,
  Color? color,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
}) {
  final bar = Progress(
    key: key,
    progress: progress,
    min: min,
    max: max,
    disableAnimation: disableAnimation,
    color: color,
    backgroundColor: backgroundColor,
  );
  return borderRadius == null
      ? bar
      : ComponentTheme<ProgressTheme>(
          data: ProgressTheme(borderRadius: borderRadius),
          child: bar,
        );
}

/// A circular progress indicator. Wraps shadcn_flutter's
/// `CircularProgressIndicator`.
///
/// [value] is null for an indeterminate spinner.
Widget bofCircularProgress({
  Key? key,
  double? value,
  double? size,
  Color? color,
  Color? backgroundColor,
  double? strokeWidth,
  Duration duration = kDefaultDuration,
  bool animated = true,
  bool onSurface = false,
}) {
  return CircularProgressIndicator(
    key: key,
    value: value,
    size: size,
    color: color,
    backgroundColor: backgroundColor,
    strokeWidth: strokeWidth,
    duration: duration,
    animated: animated,
    onSurface: onSurface,
  );
}
