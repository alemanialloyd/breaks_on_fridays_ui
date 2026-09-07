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
              BoF.button('Cancel', type: BoFButtonType.outline, onPressed: () {}),
              BoF.button('Delete', type: BoFButtonType.destructive, onPressed: () {}),
              BoF.button(null, icon: const Icon(Icons.add), onPressed: () {}),
              BoF.button(
                'Next',
                icon: const Icon(Icons.arrow_forward),
                iconPosition: BoFIconPosition.right,
                onPressed: () {},
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
              BoF.container(BoF.text('Outline'), type: BoFContainerType.outline),
              BoF.container(BoF.text('Filled'), type: BoFContainerType.filled),
              BoF.container(BoF.text('Danger'), type: BoFContainerType.destructive),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.alertDialog',
          description: 'Tap to open; confirms via the positive/negative buttons.',
          child: Builder(
            builder: (context) => BoF.button(
              'Delete item',
              type: BoFButtonType.destructive,
              onPressed: () => BoF.alertDialog(
                context,
                title: 'Delete item',
                content: 'This action cannot be undone.',
                positiveText: 'Delete',
                negativeText: 'Cancel',
                positiveType: BoFButtonType.destructive,
              ),
            ),
          ),
        ),
        GalleryEntry(
          title: 'BoF.form',
          child: BoF.form(
            [
              BoFTextField(
                name: 'email',
                label: BoF.text('Email'),
              ),
              BoFCheckboxField(
                name: 'agree',
                label: BoF.text('I agree to the terms'),
              ),
            ],
            onSubmit: (values) {},
          ),
        ),
      ],
    );
  }
}
