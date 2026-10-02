import 'package:flutter/material.dart' as material show Icons;
import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

import '../gallery_section.dart';

class DisplaySection extends StatelessWidget {
  const DisplaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Display & layout',
      children: [
        GalleryEntry(
          title: 'BoF.avatar',
          child: Wrap(
            spacing: 12,
            children: [
              BoF.avatar(initials: 'JD'),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.badge',
          child: Wrap(
            spacing: 12,
            children: [
              BoF.badge(BoF.text('New')),
              BoF.badge(BoF.text('Alert'), type: BoFBadgeType.destructive),
              BoF.badge(
                BoF.text('Verified'),
                type: BoFBadgeType.outline,
                leading: const Icon(material.Icons.check),
                trailing: const Icon(material.Icons.star),
                leadingGap: 8,
                trailingGap: 12,
                borderColor: Colors.teal,
                borderWidth: 2,
              ),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.chip',
          child: BoF.chip(
            BoF.text('Filter'),
            trailing: BoF.chipButton(child: const Icon(material.Icons.close), onPressed: () {}),
          ),
        ),
        GalleryEntry(
          title: 'BoF.divider',
          child: Column(
            children: [
              BoF.divider(),
              const SizedBox(height: 16),
              BoF.divider(child: BoF.text('OR')),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.verticalDivider',
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                BoF.text('A'),
                BoF.verticalDivider(),
                BoF.text('B'),
              ],
            ),
          ),
        ),
        GalleryEntry(
          title: 'BoF.tooltip',
          description: 'Hover to reveal the tooltip.',
          child: BoF.tooltip(
            BoF.button('Hover me', onPressed: () {}),
            message: 'Tooltip text',
          ),
        ),
        GalleryEntry(
          title: 'BoF.popover',
          description: 'Hover or long-press to reveal.',
          child: BoF.popover(
            const Icon(material.Icons.info_outline),
            content: BoF.text('Popover content'),
          ),
        ),
        GalleryEntry(
          title: 'BoF.progress',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoF.progress(progress: 0.65),
              const SizedBox(height: 12),
              BoF.progress(),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.circularProgress',
          child: Wrap(
            spacing: 16,
            children: [
              BoF.circularProgress(value: 0.65),
              BoF.circularProgress(),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.skeleton',
          child: BoF.skeleton(BoF.text('Loading...'), enabled: true),
        ),
        GalleryEntry(
          title: 'BoF.alert',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoF.alert(title: BoF.text('Heads up'), content: BoF.text('Something happened.')),
              const SizedBox(height: 12),
              BoF.alert(title: BoF.text('Error'), destructive: true),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.accordion',
          description: 'Custom header/content containers with separators removed.',
          child: BoF.accordion(
            dividerHeight: 0,
            items: [
              BoFAccordionItem(
                title: BoF.text('Section 1'),
                content: BoF.text('Body 1'),
                headerDecoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                headerPadding: const EdgeInsets.symmetric(horizontal: 12),
                contentPadding: const EdgeInsets.all(12),
              ),
              BoFAccordionItem(
                title: BoF.text('Section 2'),
                content: BoF.text('Body 2'),
                headerPadding: const EdgeInsets.symmetric(horizontal: 12),
                contentPadding: const EdgeInsets.all(12),
              ),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.card',
          child: BoF.card(BoF.text('Card body'), filled: true),
        ),
        GalleryEntry(
          title: 'BoF.toast',
          description: 'Tap to show a toast notification (bottom-right by default).',
          child: Builder(
            builder: (context) => BoF.button(
              'Show toast',
              onPressed: () => BoF.toast(context, title: 'Saved', message: 'Your changes were saved.'),
            ),
          ),
        ),
        GalleryEntry(
          title: 'BoF.dropdownMenu',
          description: 'Tap to open a menu anchored to the button.',
          child: Builder(
            builder: (context) => BoF.button(
              'Open menu',
              onPressed: () => BoF.dropdownMenu(context, items: [
                BoFMenuItem(child: BoF.text('Edit'), onPressed: () {}),
                BoFMenuItem(child: BoF.text('Delete'), onPressed: () {}),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
