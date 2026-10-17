import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

void main() {
  const formWidth = 600.0;

  Future<void> pumpField(WidgetTester tester, BoFField field) {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: formWidth,
              child: SingleChildScrollView(
                child: BoF.form([field, BoFCustom(const Text('end'))]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The width of the input [BoFField.buildInput] returned, inside its key.
  double inputWidth(WidgetTester tester, String name) {
    final keyed = find.byWidgetPredicate(
      (w) => w is KeyedSubtree && w.key == ValueKey('$name#0'),
    );
    return tester.getSize(keyed).width;
  }

  const options = [
    BoFOption(value: 'a', label: Text('A')),
    BoFOption(value: 'b', label: Text('B')),
  ];

  final fields = <BoFField>[
    BoFTextField(name: 'text', label: const Text('Text')),
    BoFTextAreaField(name: 'textArea', label: const Text('Text area')),
    BoFNumberField(name: 'number', label: const Text('Number')),
    BoFSelectField<String>(
      name: 'select',
      label: const Text('Select'),
      options: options,
    ),
    BoFMultiSelectField<String>(
      name: 'multiSelect',
      label: const Text('Multi select'),
      options: options,
    ),
    BoFDatePickerField(name: 'datePicker', label: const Text('Date')),
    BoFDateInputField(name: 'dateInput', label: const Text('Date input')),
    BoFTimePickerField(name: 'timePicker', label: const Text('Time')),
    BoFTimeInputField(name: 'timeInput', label: const Text('Time input')),
    BoFDurationPickerField(name: 'durationPicker', label: const Text('Dur')),
    BoFDurationInputField(name: 'durationInput', label: const Text('Dur in')),
    BoFColorField(name: 'color', label: const Text('Color')),
    BoFPhoneField(name: 'phone', label: const Text('Phone')),
    BoFSliderField(name: 'slider', label: const Text('Slider')),
    BoFAutoCompleteField(
      name: 'autoComplete',
      label: const Text('Auto complete'),
      suggestions: const ['one', 'two'],
    ),
    BoFChipInputField<String>(
      name: 'chipInput',
      label: const Text('Chips'),
      chipBuilder: (context, value) => Text(value),
      onChipSubmitted: (text) => text,
    ),
  ];

  for (final field in fields) {
    testWidgets('${field.runtimeType} fills the form width', (tester) async {
      await pumpField(tester, field);
      expect(inputWidth(tester, field.name), moreOrLessEquals(formWidth));
    });
  }

  testWidgets('compact fields keep their natural width', (tester) async {
    await pumpField(
      tester,
      BoFCheckboxField(name: 'agree', label: const Text('Agree')),
    );
    expect(inputWidth(tester, 'agree'), lessThan(formWidth / 2));
  });
}
