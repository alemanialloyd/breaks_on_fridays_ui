import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A styled text widget.
///
/// This is a plain [Text] widget under the hood, so shadcn_flutter's
/// typography modifiers can be chained directly, e.g.
/// `BoF.text('Title').h1` or `BoF.text('Body').muted`.
Text bofText(
  String data, {
  Key? key,
  TextStyle? style,
  StrutStyle? strutStyle,
  TextAlign? textAlign,
  TextDirection? textDirection,
  Locale? locale,
  bool? softWrap,
  TextOverflow? overflow,
  TextScaler? textScaler,
  int? maxLines,
  String? semanticsLabel,
  String? semanticsIdentifier,
  TextWidthBasis? textWidthBasis,
  TextHeightBehavior? textHeightBehavior,
  Color? selectionColor,
}) {
  return Text(
    data,
    key: key,
    style: style,
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    semanticsIdentifier: semanticsIdentifier,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
    selectionColor: selectionColor,
  );
}
