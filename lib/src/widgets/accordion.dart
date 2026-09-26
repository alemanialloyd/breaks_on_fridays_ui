import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A single section of a [bofAccordion].
class BoFAccordionItem {
  /// The always-visible, tappable header.
  final Widget title;

  /// The content revealed when this item is expanded.
  final Widget content;

  /// Whether this item starts expanded. Only one item should set this.
  final bool expanded;

  /// Decoration applied to the header container.
  final Decoration? headerDecoration;

  /// Padding applied inside the header container.
  final EdgeInsetsGeometry? headerPadding;

  /// Decoration applied to the expanded content container.
  final Decoration? contentDecoration;

  /// Padding applied inside the expanded content container.
  final EdgeInsetsGeometry? contentPadding;

  const BoFAccordionItem({
    required this.title,
    required this.content,
    this.expanded = false,
    this.headerDecoration,
    this.headerPadding,
    this.contentDecoration,
    this.contentPadding,
  });
}

/// A list of collapsible sections where only one is expanded at a time.
/// Wraps shadcn_flutter's `Accordion`/`AccordionItem`/`AccordionTrigger`.
Widget bofAccordion({
  Key? key,
  required List<BoFAccordionItem> items,
  double? dividerHeight,
}) {
  final accordion = Accordion(
    key: key,
    items: items.map((item) {
      final trigger = AccordionTrigger(child: item.title);
      return AccordionItem(
        trigger: item.headerDecoration == null && item.headerPadding == null
            ? trigger
            : Container(
                decoration: item.headerDecoration,
                padding: item.headerPadding,
                child: trigger,
              ),
        content: item.contentDecoration == null && item.contentPadding == null
            ? item.content
            : Container(
                decoration: item.contentDecoration,
                padding: item.contentPadding,
                child: item.content,
              ),
        expanded: item.expanded,
      );
    }).toList(),
  );

  if (dividerHeight == null) return accordion;

  return ComponentTheme<DividerTheme>(
    data: DividerTheme(height: dividerHeight, thickness: dividerHeight),
    child: ComponentTheme<AccordionTheme>(
      data: AccordionTheme(dividerHeight: dividerHeight),
      child: accordion,
    ),
  );
}
