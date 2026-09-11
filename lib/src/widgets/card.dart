import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A card-styled container. Wraps shadcn_flutter's `Card`.
///
/// Distinct from [bofContainer]: `Card` has its own fill/shadow/padding
/// defaults tuned for content cards, whereas `bofContainer` is a bare
/// outlined/filled surface.
///
/// Pass [textStyle] to control the color/size of any [Text] inside [child]
/// that doesn't set its own style.
Widget bofCard(
  Widget child, {
  Key? key,
  EdgeInsetsGeometry? padding,
  bool? filled,
  Color? fillColor,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  Clip? clipBehavior,
  List<BoxShadow>? boxShadow,
  double? surfaceOpacity,
  double? surfaceBlur,
  Duration? duration,
  TextStyle? textStyle,
}) {
  final card = Card(
    key: key,
    padding: padding,
    filled: filled,
    fillColor: fillColor,
    borderRadius: borderRadius,
    borderColor: borderColor,
    borderWidth: borderWidth,
    clipBehavior: clipBehavior,
    boxShadow: boxShadow,
    surfaceOpacity: surfaceOpacity,
    surfaceBlur: surfaceBlur,
    duration: duration,
    child: child,
  );
  return textStyle == null ? card : DefaultTextStyle.merge(style: textStyle, child: card);
}
