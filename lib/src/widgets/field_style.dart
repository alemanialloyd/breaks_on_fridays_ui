import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../extensions/style_override.dart';

/// Merges the individual text overrides into [style], returning null when
/// nothing is overridden so the widget keeps its own default text style.
TextStyle? bofFieldTextStyle(
  TextStyle? style, {
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  if (foregroundColor == null && fontSize == null && fontWeight == null) {
    return style;
  }
  return (style ?? const TextStyle()).copyWith(
    color: foregroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}

/// Builds a text input with the fill and border resolved by
/// [BofTextFieldSurface.builder].
typedef BofTextFieldSurfaceBuilder =
    Widget Function(BuildContext context, bool? filled, Border? border);

/// Applies a field-local fill and border to every shadcn `TextField` below it
/// without replacing shadcn's decoration.
///
/// `TextField.decoration` is a complete decoration override, so using it for a
/// color alone also removes the border, radius, and any component-theme
/// styling. A filled shadcn field gets its color from `colorScheme.muted`; this
/// scopes that color to one field and retains the surrounding text-field theme.
///
/// [borderRadius] and [padding] are only needed for composite widgets that
/// build their text field internally; widgets that take these directly should
/// pass them there instead.
///
/// Use [BofTextFieldSurface.builder] for a text input that can take the
/// resolved fill and border directly. Some inputs (shadcn_flutter 0.0.55's
/// `TextArea`, for one) give their inner field an explicit theme, which hides
/// the component theme this widget provides.
class BofTextFieldSurface extends StatelessWidget {
  const BofTextFieldSurface({
    super.key,
    required this.color,
    required Widget this.child,
    this.filled,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
  }) : builder = null;

  const BofTextFieldSurface.builder({
    super.key,
    required this.color,
    required BofTextFieldSurfaceBuilder this.builder,
    this.filled,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
  }) : child = null;

  final Color? color;
  final bool? filled;
  final Border? border;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final BofTextFieldSurfaceBuilder? builder;

  @override
  Widget build(BuildContext context) {
    if (color == null &&
        filled == null &&
        border == null &&
        borderColor == null &&
        borderWidth == null &&
        borderRadius == null &&
        padding == null) {
      return child ?? builder!(context, filled, border);
    }

    final theme = Theme.of(context);
    final fieldTheme = ComponentTheme.maybeOf<TextFieldTheme>(context);
    var effectiveBorder = border ?? fieldTheme?.border;
    if (borderColor != null || borderWidth != null) {
      final base =
          effectiveBorder ??
          Border.all(
            color: theme.colorScheme.border,
            strokeAlign: BorderSide.strokeAlignCenter,
          );
      BorderSide overrideSide(BorderSide side) =>
          side.copyWith(color: borderColor, width: borderWidth);
      effectiveBorder = Border(
        top: overrideSide(base.top),
        bottom: overrideSide(base.bottom),
        left: overrideSide(base.left),
        right: overrideSide(base.right),
      );
    }
    final effectiveFilled =
        filled ?? (color != null ? true : fieldTheme?.filled);
    return Theme(
      data: color == null
          ? theme
          : theme.copyWith(
              colorScheme: () =>
                  theme.colorScheme.copyWith(muted: () => color!),
            ),
      child: ComponentTheme<TextFieldTheme>(
        data: (fieldTheme ?? const TextFieldTheme()).copyWith(
          filled: () => effectiveFilled,
          border: () => effectiveBorder,
          borderRadius: () => borderRadius ?? fieldTheme?.borderRadius,
          padding: () => padding ?? fieldTheme?.padding,
        ),
        child:
            child ??
            Builder(
              builder: (context) =>
                  builder!(context, effectiveFilled, effectiveBorder),
            ),
      ),
    );
  }
}

/// Restyles the outline (or, with [secondary], the filled) button that a
/// picker or select uses as its trigger, since those widgets only expose it
/// through shadcn's button component themes.
///
/// The override is limited to buttons inside [child]: popovers and dialogs
/// opened from the trigger inherit component themes, but not the private
/// marker this places around [child], so their own buttons keep the inherited
/// look. Any app-level button theme still applies underneath the overrides.
class BofTriggerStyle extends StatelessWidget {
  const BofTriggerStyle({
    super.key,
    required this.child,
    this.secondary = false,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.padding,
  });

  final Widget child;
  final bool secondary;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;

  bool get _isEmpty =>
      backgroundColor == null &&
      foregroundColor == null &&
      fontSize == null &&
      fontWeight == null &&
      style == null &&
      borderRadius == null &&
      borderColor == null &&
      borderWidth == null &&
      padding == null;

  ButtonStatePropertyDelegate<Decoration> _decoration(
    ButtonStatePropertyDelegate<Decoration>? parent,
  ) => (context, states, value) {
    final base = parent?.call(context, states, value) ?? value;
    if (!_BofTriggerMarker.isInside(context)) return base;
    return bofOverrideDecoration(
      base,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  };

  ButtonStatePropertyDelegate<TextStyle> _textStyle(
    ButtonStatePropertyDelegate<TextStyle>? parent,
  ) => (context, states, value) {
    final base = parent?.call(context, states, value) ?? value;
    if (!_BofTriggerMarker.isInside(context)) return base;
    return bofOverrideTextStyle(
      base.merge(style),
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  };

  ButtonStatePropertyDelegate<IconThemeData> _iconTheme(
    ButtonStatePropertyDelegate<IconThemeData>? parent,
  ) => (context, states, value) {
    final base = parent?.call(context, states, value) ?? value;
    if (foregroundColor == null || !_BofTriggerMarker.isInside(context)) {
      return base;
    }
    return base.copyWith(color: foregroundColor);
  };

  ButtonStatePropertyDelegate<EdgeInsetsGeometry> _padding(
    ButtonStatePropertyDelegate<EdgeInsetsGeometry>? parent,
  ) => (context, states, value) {
    final base = parent?.call(context, states, value) ?? value;
    if (padding == null || !_BofTriggerMarker.isInside(context)) return base;
    return padding!;
  };

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) return child;
    final marked = _BofTriggerMarker(child: child);
    if (secondary) {
      final parent = ComponentTheme.maybeOf<SecondaryButtonTheme>(context);
      return ComponentTheme<SecondaryButtonTheme>(
        data: (parent ?? const SecondaryButtonTheme()).copyWith(
          decoration: () => _decoration(parent?.decoration),
          textStyle: () => _textStyle(parent?.textStyle),
          iconTheme: () => _iconTheme(parent?.iconTheme),
          padding: () => _padding(parent?.padding),
        ),
        child: marked,
      );
    }
    final parent = ComponentTheme.maybeOf<OutlineButtonTheme>(context);
    return ComponentTheme<OutlineButtonTheme>(
      data: (parent ?? const OutlineButtonTheme()).copyWith(
        decoration: () => _decoration(parent?.decoration),
        textStyle: () => _textStyle(parent?.textStyle),
        iconTheme: () => _iconTheme(parent?.iconTheme),
        padding: () => _padding(parent?.padding),
      ),
      child: marked,
    );
  }
}

/// A plain inherited widget, deliberately not an `InheritedTheme`, so it is
/// not carried into popovers and dialogs that capture the trigger's themes.
class _BofTriggerMarker extends InheritedWidget {
  const _BofTriggerMarker({required super.child});

  static bool isInside(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_BofTriggerMarker>() != null;

  @override
  bool updateShouldNotify(_BofTriggerMarker oldWidget) => false;
}

/// Restyles composite inputs whose surface is drawn from theme colors rather
/// than exposed as parameters (the segmented date/time/duration inputs and
/// the OTP cells).
///
/// It scopes the theme around [child]: [borderColor] replaces
/// `colorScheme.border`, [foregroundColor] replaces `colorScheme.foreground`,
/// and [borderRadius] rescales the theme radius so its medium radius matches
/// the top-left corner of [borderRadius]. [backgroundColor] is painted behind
/// the input, whose own translucent fill is cleared, so the color shows
/// exactly as given. Text overrides go through both the default text style
/// and the theme's small text style.
///
/// Anything opened from [child] inherits the scoped theme; callers that own a
/// popup should wrap it in [BofScopedSurface.restore].
class BofScopedSurface extends StatelessWidget {
  const BofScopedSurface({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  });

  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;

  /// Re-applies the theme that was in effect outside the nearest
  /// [BofScopedSurface], for popup content built inside it.
  static Widget restore(BuildContext context, Widget child) {
    final original = context
        .getInheritedWidgetOfExactType<_BofOriginalTheme>()
        ?.theme;
    return original == null ? child : Theme(data: original, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = bofFieldTextStyle(
      style,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
    if (backgroundColor == null &&
        textStyle == null &&
        borderRadius == null &&
        borderColor == null &&
        borderWidth == null) {
      return child;
    }

    final theme = Theme.of(context);
    var scoped = theme;
    final radius = borderRadius
        ?.resolve(Directionality.maybeOf(context) ?? TextDirection.ltr)
        .topLeft
        .x;
    if (radius != null && theme.radiusMd > 0) {
      scoped = scoped.copyWith(
        radius: () => theme.radius * radius / theme.radiusMd,
      );
    }
    if (backgroundColor != null ||
        borderColor != null ||
        foregroundColor != null) {
      scoped = scoped.copyWith(
        colorScheme: () => theme.colorScheme.copyWith(
          input: backgroundColor == null ? null : () => const Color(0x00000000),
          border: borderColor == null ? null : () => borderColor!,
          foreground: foregroundColor == null ? null : () => foregroundColor!,
        ),
      );
    }
    if (fontSize != null || fontWeight != null) {
      scoped = scoped.copyWith(
        typography: () => theme.typography.copyWith(
          small: () => theme.typography.small.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      );
    }

    Widget result = child;
    if (textStyle != null) {
      result = DefaultTextStyle.merge(style: textStyle, child: result);
    }
    if (borderWidth != null) {
      final containerTheme = ComponentTheme.maybeOf<OutlinedContainerTheme>(
        context,
      );
      result = ComponentTheme<OutlinedContainerTheme>(
        data: (containerTheme ?? const OutlinedContainerTheme()).copyWith(
          borderWidth: () => borderWidth,
        ),
        child: result,
      );
    }
    result = _BofOriginalTheme(
      theme: theme,
      child: Theme(data: scoped, child: result),
    );
    if (backgroundColor != null) {
      result = DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: scoped.borderRadiusMd,
        ),
        child: result,
      );
    }
    return result;
  }
}

// An `InheritedTheme`, unlike the trigger marker, so popups opened from the
// surface carry it and can restore the unscoped theme.
class _BofOriginalTheme extends InheritedTheme {
  const _BofOriginalTheme({required this.theme, required super.child});

  final ThemeData theme;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _BofOriginalTheme(theme: theme, child: child);

  @override
  bool updateShouldNotify(_BofOriginalTheme oldWidget) =>
      theme != oldWidget.theme;
}
