import 'package:shadcn_flutter/shadcn_flutter.dart';

/// One entry of a [bofMetaLine], such as an author, a date or a time.
///
/// Use the default constructor for text, which gets the line's small muted
/// style ([highlighted] switches it to the primary color), or
/// [BoFMetaItem.widget] for any other widget, e.g. an icon with a label.
/// Pass [onPressed] to make the entry tappable, and [prefix] for lead-in text
/// such as "by " that keeps the muted style and is not part of the tap target.
class BoFMetaItem {
  /// The text to display, or null for a [BoFMetaItem.widget] entry.
  final String? text;

  /// The widget to display, or null for a text entry.
  final Widget? child;

  /// Whether a text entry uses the primary color instead of the muted one.
  final bool highlighted;

  /// Called when the entry is tapped. Null leaves it non-interactive.
  final VoidCallback? onPressed;

  /// Merged over the line's text style for this entry only.
  final TextStyle? style;

  /// Muted text shown right before the entry, e.g. 'by '. Include any
  /// trailing space you want.
  final String? prefix;

  const BoFMetaItem(
    String this.text, {
    this.prefix,
    this.highlighted = false,
    this.onPressed,
    this.style,
  }) : child = null;

  const BoFMetaItem.widget(Widget this.child, {this.prefix, this.onPressed})
    : text = null,
      highlighted = false,
      style = null;
}

/// A line of metadata, e.g. "by jc@gmail.com · September 30, 2026 · 12:49 PM".
///
/// Entries are joined by [separator], which is either a [String] (styled like
/// the text entries) or a [Widget] (used as-is). Each separator stays at the
/// end of the entry before it, and the line wraps between entries, never
/// inside one, so a narrow screen moves whole entries to the next line.
/// A single entry wider than the line still wraps its own text.
///
/// Text entries use the theme's small typography in the muted foreground
/// color. [style] is merged over that for every entry and string separator,
/// and [highlightColor] replaces the primary color used by highlighted
/// entries. [spacing] is the horizontal gap around separators and
/// [runSpacing] the vertical gap between wrapped lines.
Widget bofMetaLine(
  List<BoFMetaItem> items, {
  Key? key,
  Object separator = '·',
  double spacing = 4,
  double runSpacing = 2,
  TextStyle? style,
  Color? highlightColor,
  WrapAlignment alignment = WrapAlignment.start,
}) {
  assert(
    separator is String || separator is Widget,
    'separator must be a String or a Widget, got ${separator.runtimeType}.',
  );
  return Builder(
    key: key,
    builder: (context) {
      final theme = Theme.of(context);
      final baseStyle = theme.typography.small
          .copyWith(color: theme.colorScheme.mutedForeground)
          .merge(style);

      Widget buildItem(BoFMetaItem item) {
        Widget content =
            item.child ??
            Text(
              item.text!,
              style: baseStyle
                  .copyWith(
                    color: item.highlighted
                        ? highlightColor ?? theme.colorScheme.primary
                        : null,
                  )
                  .merge(item.style),
            );
        if (item.onPressed != null) {
          content = Semantics(
            button: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: item.onPressed,
                child: content,
              ),
            ),
          );
        }
        if (item.prefix != null) {
          content = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.prefix!, style: baseStyle),
              Flexible(child: content),
            ],
          );
        }
        return content;
      }

      final separatorWidget = separator is Widget
          ? separator
          : Text(separator as String, style: baseStyle);

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: alignment,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < items.length; i++)
            if (i == items.length - 1)
              buildItem(items[i])
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: buildItem(items[i])),
                  SizedBox(width: spacing),
                  separatorWidget,
                ],
              ),
        ],
      );
    },
  );
}
