import 'package:shadcn_flutter/shadcn_flutter.dart';

/// The visual style of a [bofButton].
///
/// Mirrors shadcn_flutter's named [Button] constructors.
enum BoFButtonType {
  primary,
  secondary,
  outline,
  ghost,
  link,
  text,
  destructive,
}

/// Where [bofButton]'s `icon` is placed relative to its `label`.
enum BoFIconPosition { left, right, top, bottom }

/// A styled button.
///
/// [type] selects which of [shadcn_flutter]'s named [Button] variants to
/// use, defaulting to [BoFButtonType.primary]. The remaining parameters
/// mirror [Button]'s full API, including [size], [density] and [shape].
///
/// [label] and [icon] are both optional, but at least one must be provided:
/// - [label] only → a plain text button.
/// - [icon] only → an icon-only button (defaults to [ButtonDensity.icon]
///   padding unless [density] is set explicitly).
/// - both → [icon] is placed relative to [label] according to
///   [iconPosition] (`left`/`right` use the button's native leading/trailing
///   slots; `top`/`bottom` stack them in a column).
Widget bofButton(
  String? label, {
  Key? key,
  BoFButtonType type = BoFButtonType.primary,
  Widget? icon,
  BoFIconPosition iconPosition = BoFIconPosition.left,
  double? iconGap,
  VoidCallback? onPressed,
  bool? enabled,
  FocusNode? focusNode,
  AlignmentGeometry? alignment,
  ButtonSize size = ButtonSize.normal,
  ButtonDensity? density,
  ButtonShape shape = ButtonShape.rectangle,
  bool disableTransition = false,
  ValueChanged<bool>? onHover,
  ValueChanged<bool>? onFocus,
  bool disableHoverEffect = false,
  bool? enableFeedback,
  GestureTapDownCallback? onTapDown,
  GestureTapUpCallback? onTapUp,
  GestureTapCancelCallback? onTapCancel,
  GestureTapDownCallback? onSecondaryTapDown,
  GestureTapUpCallback? onSecondaryTapUp,
  GestureTapCancelCallback? onSecondaryTapCancel,
  GestureTapDownCallback? onTertiaryTapDown,
  GestureTapUpCallback? onTertiaryTapUp,
  GestureTapCancelCallback? onTertiaryTapCancel,
  GestureLongPressStartCallback? onLongPressStart,
  GestureLongPressUpCallback? onLongPressUp,
  GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
  GestureLongPressEndCallback? onLongPressEnd,
  GestureLongPressUpCallback? onSecondaryLongPress,
  GestureLongPressUpCallback? onTertiaryLongPress,
  WidgetStatesController? statesController,
  AlignmentGeometry? marginAlignment,
  bool disableFocusOutline = false,
}) {
  assert(
    label != null || icon != null,
    'bofButton needs a label, an icon, or both.',
  );

  Widget? leading;
  Widget? trailing;
  final Widget child;

  if (icon == null) {
    child = Text(label!);
  } else if (label == null) {
    child = icon;
  } else {
    final gap = Gap(iconGap ?? 4);
    switch (iconPosition) {
      case BoFIconPosition.left:
        leading = icon;
        child = Text(label);
      case BoFIconPosition.right:
        trailing = icon;
        child = Text(label);
      case BoFIconPosition.top:
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [icon, gap, Text(label)],
        );
      case BoFIconPosition.bottom:
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(label), gap, icon],
        );
    }
  }

  return Button(
    key: key,
    style: ButtonStyle(
      variance: _variance(type),
      size: size,
      density: density ?? (label == null ? ButtonDensity.icon : ButtonDensity.normal),
      shape: shape,
    ),
    statesController: statesController,
    leading: leading,
    trailing: trailing,
    leadingGap: iconGap,
    trailingGap: iconGap,
    onPressed: onPressed,
    focusNode: focusNode,
    alignment: alignment,
    enabled: enabled,
    disableTransition: disableTransition,
    onFocus: onFocus,
    onHover: onHover,
    disableHoverEffect: disableHoverEffect,
    enableFeedback: enableFeedback,
    onTapDown: onTapDown,
    onTapUp: onTapUp,
    onTapCancel: onTapCancel,
    onSecondaryTapDown: onSecondaryTapDown,
    onSecondaryTapUp: onSecondaryTapUp,
    onSecondaryTapCancel: onSecondaryTapCancel,
    onTertiaryTapDown: onTertiaryTapDown,
    onTertiaryTapUp: onTertiaryTapUp,
    onTertiaryTapCancel: onTertiaryTapCancel,
    onLongPressStart: onLongPressStart,
    onLongPressUp: onLongPressUp,
    onLongPressMoveUpdate: onLongPressMoveUpdate,
    onLongPressEnd: onLongPressEnd,
    onSecondaryLongPress: onSecondaryLongPress,
    onTertiaryLongPress: onTertiaryLongPress,
    marginAlignment: marginAlignment,
    disableFocusOutline: disableFocusOutline,
    child: child,
  );
}

AbstractButtonStyle _variance(BoFButtonType type) {
  switch (type) {
    case BoFButtonType.primary:
      return ButtonVariance.primary;
    case BoFButtonType.secondary:
      return ButtonVariance.secondary;
    case BoFButtonType.outline:
      return ButtonVariance.outline;
    case BoFButtonType.ghost:
      return ButtonVariance.ghost;
    case BoFButtonType.link:
      return ButtonVariance.link;
    case BoFButtonType.text:
      return ButtonVariance.text;
    case BoFButtonType.destructive:
      return ButtonVariance.destructive;
  }
}
