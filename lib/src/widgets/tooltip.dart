import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Wraps [child] so a tooltip shows on hover. Wraps shadcn_flutter's
/// `Tooltip`.
///
/// The common case is a plain [message] string; pass [builder] instead for a
/// fully custom tooltip widget (it overrides [message]).
///
/// [backgroundColor], [borderRadius], [padding] and [textStyle] style the
/// default [message] bubble; they're ignored when [builder] is provided
/// since the caller owns that widget's styling directly.
Widget bofTooltip(
  Widget child, {
  Key? key,
  String? message,
  WidgetBuilder? builder,
  AlignmentGeometry alignment = Alignment.topCenter,
  AlignmentGeometry anchorAlignment = Alignment.bottomCenter,
  Duration waitDuration = const Duration(milliseconds: 500),
  Duration showDuration = const Duration(milliseconds: 200),
  Duration minDuration = Duration.zero,
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry? padding,
  TextStyle? textStyle,
}) {
  assert(
    message != null || builder != null,
    'bofTooltip needs a message or a builder.',
  );
  return Tooltip(
    key: key,
    tooltip: builder ??
        (context) => TooltipContainer(
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              padding: padding,
              child: Text(message!, style: textStyle),
            ),
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    waitDuration: waitDuration,
    showDuration: showDuration,
    minDuration: minDuration,
    child: child,
  );
}
