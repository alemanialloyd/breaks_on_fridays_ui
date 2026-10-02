import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A styled text widget.
///
/// This is a [Text] widget under the hood, so shadcn_flutter's
/// typography modifiers can be chained directly, e.g.
/// `BoF.text('Title').h1` or `BoF.text('Body').muted`.
/// The `h2` modifier keeps the heading typography and spacing without a border.
BoFText bofText(
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
  return BoFText(
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

/// Text with BoF's borderless second-level heading modifier.
///
/// Remains a [Text] so callers can use all standard text properties and
/// shadcn_flutter's other typography modifiers.
class BoFText extends Text {
  const BoFText(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.semanticsIdentifier,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  /// Applies heading 2 typography and spacing without a bottom border.
  TextModifier get h2 => WrappedText(
    style: (context, theme) => theme.typography.h2,
    wrapper: (context, child) => Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 8),
      child: child,
    ),
    child: this,
  );
}
