import 'package:flutter/material.dart' as material show Icons;
import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

import '../gallery_section.dart';

class CoreSection extends StatelessWidget {
  const CoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Core',
      children: [
        GalleryEntry(
          title: 'BoF.text',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoF.text('Title').h1,
              BoF.text('Section').h3,
              BoF.text('Body copy').muted,
              BoF.text('Emphasis').bold.large,
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.button',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BoF.button('Save', onPressed: () {}),
              BoF.button(
                'Cancel',
                type: BoFButtonType.outline,
                onPressed: () {},
              ),
              BoF.button(
                'Delete',
                type: BoFButtonType.destructive,
                onPressed: () {},
              ),
              BoF.button(
                null,
                icon: const Icon(material.Icons.add),
                onPressed: () {},
              ),
              BoF.button(
                'Next',
                icon: const Icon(material.Icons.arrow_forward),
                iconPosition: BoFIconPosition.right,
                onPressed: () {},
              ),
              SizedBox(
                width: 240,
                child: BoF.button(
                  'Centered full width',
                  icon: const Icon(material.Icons.check),
                  centerContent: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.container',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BoF.container(
                BoF.text('Outline'),
                type: BoFContainerType.outline,
              ),
              BoF.container(BoF.text('Filled'), type: BoFContainerType.filled),
              BoF.container(
                BoF.text('Danger'),
                type: BoFContainerType.destructive,
              ),
            ],
          ),
        ),
        GalleryEntry(
          title: 'Custom styling',
          description:
              'backgroundColor/foregroundColor/fontSize/borderRadius on '
              'BoF.button, BoF.badge and BoF.chip.',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              BoF.button(
                'Custom',
                onPressed: () {},
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                fontSize: 16,
                borderRadius: BorderRadius.circular(20),
              ),
              BoF.badge(
                BoF.text('Featured'),
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              BoF.chip(
                BoF.text('Rounded'),
                backgroundColor: Colors.teal.withValues(alpha: 0.15),
                foregroundColor: Colors.teal,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.alertDialog',
          description:
              'Tap to open; confirms via the positive/negative buttons.',
          child: Builder(
            builder: (context) => BoF.button(
              'Delete item',
              type: BoFButtonType.destructive,
              onPressed: () => BoF.alertDialog(
                context,
                title: 'Delete item',
                borderRadius: BorderRadius.circular(16),
                surfaceBlur: 8,
                surfaceOpacity: 0.9,
                barrierColor: Colors.black.withValues(alpha: 0.4),
                content: 'This action cannot be undone.',
                trailing: const Icon(material.Icons.warning_amber_rounded),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                positiveText: 'Delete',
                negativeText: 'Cancel',
                positiveType: BoFButtonType.destructive,
              ),
            ),
          ),
        ),
        GalleryEntry(
          title: 'BoF.form',
          description:
              'BoFDateInputField masks input as mm/dd/yyyy and '
              'NonNullValidator<DateTime>() rejects an incomplete date — '
              'tap Submit without finishing the date to see it.',
          child: const _FormDemo(),
        ),
      ],
    );
  }
}

class _FormDemo extends StatefulWidget {
  const _FormDemo();

  @override
  State<_FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<_FormDemo> {
  final controller = BoFFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      BoF.form(
        [
          BoFTextField(name: 'email', label: BoF.text('Email')),
          BoFDateInputField(
            name: 'birthday',
            label: BoF.text('Birthday'),
            validator: const NonNullValidator<DateTime>(),
          ),
          BoFCheckboxField(
            name: 'agree',
            label: BoF.text('I agree to the terms'),
          ),
        ],
        controller: controller,
        onSubmit: (values) => BoF.toast(
          context,
          title: 'Form submitted',
          message: 'The example values passed validation.',
        ),
      ),
      const SizedBox(height: 12),
      BoF.button('Submit', onPressed: () => controller.submit()),
    ],
  );
}
