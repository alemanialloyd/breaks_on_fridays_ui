import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Wraps a button-family [AbstractButtonStyle] (used by [Button], the
/// `PrimaryBadge`/`SecondaryBadge`/`OutlineBadge`/`DestructiveBadge` family,
/// and `Chip`), overriding only the given properties and falling back to
/// [base] for everything else — including per-state hover/press/disabled
/// behavior for anything not overridden.
///
/// Returns [base] unchanged when every override is null.
AbstractButtonStyle bofButtonStyle(
  AbstractButtonStyle base, {
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  if (backgroundColor == null &&
      foregroundColor == null &&
      fontSize == null &&
      fontWeight == null &&
      borderRadius == null &&
      borderColor == null &&
      borderWidth == null &&
      padding == null) {
    return base;
  }
  return _ButtonStyleOverride(
    base,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    borderRadius: borderRadius,
    borderColor: borderColor,
    borderWidth: borderWidth,
    padding: padding,
  );
}

class _ButtonStyleOverride implements AbstractButtonStyle {
  const _ButtonStyleOverride(
    this.base, {
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    EdgeInsetsGeometry? padding,
  }) : _paddingOverride = padding;

  final AbstractButtonStyle base;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? _paddingOverride;

  @override
  ButtonStateProperty<Decoration> get decoration => (context, states) {
        final resolved = base.decoration(context, states);
        if (backgroundColor == null &&
            borderRadius == null &&
            borderColor == null &&
            borderWidth == null) {
          return resolved;
        }
        if (resolved is ShapeDecoration) {
          // e.g. ButtonShape.circle — has no BorderRadius/BoxBorder concept,
          // so only the fill color can be overridden here.
          return resolved.copyWithIfShapeDecoration(color: backgroundColor);
        }
        Border? border;
        if (borderColor != null || borderWidth != null) {
          final existing = resolved is BoxDecoration ? resolved.border : null;
          final existingSide = existing is Border ? existing.top : null;
          border = Border.fromBorderSide(BorderSide(
            color: borderColor ?? existingSide?.color ?? Colors.transparent,
            width: borderWidth ?? existingSide?.width ?? 1,
          ));
        }
        return resolved.copyWithIfBoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: border,
        );
      };

  @override
  ButtonStateProperty<TextStyle> get textStyle => (context, states) {
        final resolved = base.textStyle(context, states);
        if (foregroundColor == null && fontSize == null && fontWeight == null) {
          return resolved;
        }
        return resolved.copyWith(
          color: foregroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        );
      };

  @override
  ButtonStateProperty<EdgeInsetsGeometry> get padding {
    final override = _paddingOverride;
    return override == null ? base.padding : (context, states) => override;
  }

  @override
  ButtonStateProperty<MouseCursor> get mouseCursor => base.mouseCursor;

  @override
  ButtonStateProperty<IconThemeData> get iconTheme => base.iconTheme;

  @override
  ButtonStateProperty<EdgeInsetsGeometry> get margin => base.margin;
}
