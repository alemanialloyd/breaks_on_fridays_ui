import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A single section of a [bofAccordion].
class BoFAccordionItem {
  /// The always-visible, tappable header.
  final Widget title;

  /// The content revealed when this item is expanded.
  final Widget content;

  /// Whether this item starts expanded. Only one item should set this.
  final bool expanded;

  const BoFAccordionItem({
    required this.title,
    required this.content,
    this.expanded = false,
  });
}

/// A list of collapsible sections where only one is expanded at a time.
/// Wraps shadcn_flutter's `Accordion`/`AccordionItem`/`AccordionTrigger`.
Widget bofAccordion({
  Key? key,
  required List<BoFAccordionItem> items,
}) {
  return Accordion(
    key: key,
    items: [
      for (final item in items)
        AccordionItem(
          trigger: AccordionTrigger(child: item.title),
          content: item.content,
          expanded: item.expanded,
        ),
    ],
  );
}
