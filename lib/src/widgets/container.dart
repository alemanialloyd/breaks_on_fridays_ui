import 'package:shadcn_flutter/shadcn_flutter.dart';

/// The visual style of a [bofContainer].
///
/// Mirrors the color intent of [BoFButtonType], adapted for a static
/// (non-interactive) surface.
enum BoFContainerType {
  /// Solid background using the theme's primary color.
  filled,

  /// Solid background using the theme's secondary color.
  secondary,

  /// Transparent background with a visible border.
  outline,

  /// Fully transparent background and border.
  ghost,

  /// Solid background using the theme's destructive color.
  destructive,
}

({Color background, Color border, double borderWidth}) _resolveContainerColors(
  BoFContainerType type,
  ColorScheme colorScheme,
  double defaultBorderWidth,
) {
  const transparent = Color(0x00000000);
  switch (type) {
    case BoFContainerType.filled:
      return (
        background: colorScheme.primary,
        border: colorScheme.primary,
        borderWidth: 0,
      );
    case BoFContainerType.secondary:
      return (
        background: colorScheme.secondary,
        border: colorScheme.secondary,
        borderWidth: 0,
      );
    case BoFContainerType.destructive:
      return (
        background: colorScheme.destructive,
        border: colorScheme.destructive,
        borderWidth: 0,
      );
    case BoFContainerType.outline:
      return (
        background: colorScheme.background,
        border: colorScheme.border,
        borderWidth: defaultBorderWidth,
      );
    case BoFContainerType.ghost:
      return (
        background: transparent,
        border: transparent,
        borderWidth: 0,
      );
  }
}

/// A styled container.
///
/// [type] selects the surface's color intent, defaulting to
/// [BoFContainerType.outline]. The remaining parameters mirror
/// [OutlinedContainer]'s full API; explicit [backgroundColor], [borderColor]
/// and [borderWidth] values always take precedence over [type].
///
/// Pass [textStyle] to control the color/size of any [Text] inside [child]
/// that doesn't set its own style.
Widget bofContainer(
  Widget child, {
  Key? key,
  BoFContainerType type = BoFContainerType.outline,
  Color? backgroundColor,
  Color? borderColor,
  Clip clipBehavior = Clip.antiAlias,
  BorderRadiusGeometry? borderRadius,
  BorderStyle? borderStyle,
  double? borderWidth,
  List<BoxShadow>? boxShadow,
  EdgeInsetsGeometry? padding,
  double? surfaceOpacity,
  double? surfaceBlur,
  double? width,
  double? height,
  Duration? duration,
  TextStyle? textStyle,
}) {
  return Builder(
    key: key,
    builder: (context) {
      final theme = Theme.of(context);
      final resolved = _resolveContainerColors(
        type,
        theme.colorScheme,
        1 * theme.scaling,
      );
      final container = OutlinedContainer(
        backgroundColor: backgroundColor ?? resolved.background,
        borderColor: borderColor ?? resolved.border,
        borderWidth: borderWidth ?? resolved.borderWidth,
        clipBehavior: clipBehavior,
        borderRadius: borderRadius,
        borderStyle: borderStyle,
        boxShadow: boxShadow,
        padding: padding,
        surfaceOpacity: surfaceOpacity,
        surfaceBlur: surfaceBlur,
        width: width,
        height: height,
        duration: duration,
        child: child,
      );
      return textStyle == null
          ? container
          : DefaultTextStyle.merge(style: textStyle, child: container);
    },
  );
}
