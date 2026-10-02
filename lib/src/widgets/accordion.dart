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
/// Set [dividerHeight] to zero to remove all automatic item separators,
/// including the bottom divider. Custom item decorations are preserved.
Widget bofAccordion({
  Key? key,
  required List<BoFAccordionItem> items,
  double? dividerHeight,
}) {
  final accordionItems = items.map((item) {
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
  }).toList();
  final accordion = dividerHeight == 0
      ? _BorderlessAccordion(key: key, items: accordionItems)
      : Accordion(key: key, items: accordionItems);

  if (dividerHeight == null) return accordion;

  final themedAccordion = ComponentTheme<AccordionTheme>(
    data: AccordionTheme(dividerHeight: dividerHeight),
    child: accordion,
  );

  // A zero-width Divider still paints a hairline. Omitting the generated
  // dividers also avoids hiding any Divider supplied as item content.
  if (dividerHeight == 0) return themedAccordion;

  return ComponentTheme<DividerTheme>(
    data: DividerTheme(height: dividerHeight, thickness: dividerHeight),
    child: themedAccordion,
  );
}

class _BorderlessAccordion extends Accordion {
  const _BorderlessAccordion({super.key, required super.items});

  @override
  AccordionState createState() => _BorderlessAccordionState();
}

class _BorderlessAccordionState extends AccordionState {
  @override
  Widget build(BuildContext context) {
    // Keep the upstream state that coordinates single-item expansion while
    // rendering only its items, without upstream's unconditional final Divider.
    return Data<AccordionState>.inherit(
      data: this,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.items,
        ),
      ),
    );
  }
}
