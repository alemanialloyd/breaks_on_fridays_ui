import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

import '../gallery_section.dart';

class FormFieldsSection extends StatelessWidget {
  const FormFieldsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'Form fields',
      children: [
        GalleryEntry(
          title: 'BoF.textField',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoF.textField(placeholder: const Text('Search'), onChanged: (_) {}),
              const SizedBox(height: 12),
              BoF.textField(
                placeholder: const Text('Email'),
                leadingIcon: const Icon(Icons.email),
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              BoF.textField(
                placeholder: const Text('Password'),
                showPasswordToggle: true,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        GalleryEntry(
          title: 'BoF.textAreaField',
          child: BoF.textAreaField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.numberField',
          child: BoF.numberField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.checkboxField',
          child: BoF.checkboxField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.switchField',
          child: BoF.switchField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.radioGroupField',
          child: BoF.radioGroupField<String>(
            options: const [
              BoFOption(value: 'free', label: Text('Free')),
              BoFOption(value: 'pro', label: Text('Pro')),
            ],
            onChanged: (_) {},
          ),
        ),
        GalleryEntry(
          title: 'BoF.selectField',
          child: BoF.selectField<String>(
            options: const [
              BoFOption(value: 'us', label: Text('United States')),
              BoFOption(value: 'ph', label: Text('Philippines')),
            ],
            onChanged: (_) {},
          ),
        ),
        GalleryEntry(
          title: 'BoF.multiSelectField',
          child: BoF.multiSelectField<String>(
            options: const [
              BoFOption(value: 'us', label: Text('United States')),
              BoFOption(value: 'ph', label: Text('Philippines')),
            ],
            onChanged: (_) {},
          ),
        ),
        GalleryEntry(
          title: 'BoF.multipleChoiceField',
          child: BoF.multipleChoiceField<String>(
            options: const [
              BoFOption(value: 's', label: Text('S')),
              BoFOption(value: 'm', label: Text('M')),
              BoFOption(value: 'l', label: Text('L')),
            ],
            onChanged: (_) {},
          ),
        ),
        GalleryEntry(
          title: 'BoF.multipleAnswerField',
          child: BoF.multipleAnswerField<String>(
            options: const [
              BoFOption(value: 's', label: Text('S')),
              BoFOption(value: 'm', label: Text('M')),
              BoFOption(value: 'l', label: Text('L')),
            ],
            onChanged: (_) {},
          ),
        ),
        GalleryEntry(
          title: 'BoF.datePickerField',
          child: BoF.datePickerField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.dateInputField',
          child: BoF.dateInputField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.timePickerField',
          child: BoF.timePickerField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.timeInputField',
          child: BoF.timeInputField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.durationPickerField',
          child: BoF.durationPickerField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.durationInputField',
          child: BoF.durationInputField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.colorField',
          child: BoF.colorField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.phoneField',
          child: BoF.phoneField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.sliderField',
          child: BoF.sliderField(min: 0, max: 1000, onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.starRatingField',
          child: BoF.starRatingField(onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.otpField',
          child: BoF.otpField(length: 6, onChanged: (_) {}),
        ),
        GalleryEntry(
          title: 'BoF.autoCompleteField',
          child: BoF.autoCompleteField(
            suggestions: const ['Alice', 'Bob', 'Charlie'],
            onChanged: (_) {},
          ),
        ),
        GalleryEntry(
          title: 'BoF.chipInputField',
          child: BoF.chipInputField<String>(
            chipBuilder: (context, value) => BoF.chip(BoF.text(value)),
            onChipSubmitted: (text) => text,
            onChanged: (_) {},
          ),
        ),
      ],
    );
  }
}
