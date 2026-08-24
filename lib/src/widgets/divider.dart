import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A horizontal rule, optionally with a centered [child] (e.g. "OR"). Wraps
/// shadcn_flutter's `Divider`.
Widget bofDivider({
  Key? key,
  Color? color,
  double? height,
  double? thickness,
  double? indent,
  double? endIndent,
  Widget? child,
  EdgeInsetsGeometry? padding,
  AxisAlignmentGeometry? childAlignment,
}) {
  return Divider(
    key: key,
    color: color,
    height: height,
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
    padding: padding,
    childAlignment: childAlignment,
    child: child,
  );
}

/// A vertical rule, optionally with a centered [child]. Wraps
/// shadcn_flutter's `VerticalDivider`.
Widget bofVerticalDivider({
  Key? key,
  Color? color,
  double? width,
  double? thickness,
  double? indent,
  double? endIndent,
  Widget? child,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 8),
  AxisAlignmentGeometry? childAlignment,
}) {
  return VerticalDivider(
    key: key,
    color: color,
    width: width,
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
    padding: padding,
    childAlignment: childAlignment,
    child: child,
  );
}
