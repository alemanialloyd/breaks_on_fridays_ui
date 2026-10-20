import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

const _regions = {
  'PH': ['Luzon', 'Visayas'],
  'JP': ['Kanto', 'Kansai'],
};

const _cities = {
  'Luzon': ['Manila', 'Baguio'],
  'Visayas': ['Cebu'],
  'Kanto': ['Tokyo'],
  'Kansai': ['Osaka'],
};

List<BoFOption<String>> _optionsOf(Iterable<String>? values) => [
  for (final value in values ?? const <String>[])
    BoFOption(value: value, label: Text(value)),
];

/// Country → region → city, each select built from the one before it.
List<BoFFormItem> _address() => [
  BoFSelectField<String>(
    name: 'country',
    label: const Text('Country'),
    options: _optionsOf(_regions.keys),
  ),
  BoFDynamic(
    dependsOn: const ['country'],
    builder: (values) => [
      BoFSelectField<String>(
        name: 'region',
        label: const Text('Region'),
        enabled: values['country'] != null,
        options: _optionsOf(_regions[values['country']]),
      ),
    ],
  ),
  BoFDynamic(
    dependsOn: const ['region'],
    builder: (values) => [
      BoFSelectField<String>(
        name: 'city',
        label: const Text('City'),
        enabled: values['region'] != null,
        options: _optionsOf(_cities[values['region']]),
      ),
    ],
  ),
];

void main() {
  Future<void> pumpForm(WidgetTester tester, Widget form) {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(child: SingleChildScrollView(child: form)),
      ),
    );
  }

  Future<void> pick(
    WidgetTester tester,
    String fieldLabel,
    String option,
  ) async {
    final field = find.ancestor(
      of: find.text(fieldLabel),
      matching: find.byType(Column),
    );
    await tester.tap(
      find.descendant(of: field.first, matching: find.byType(Select<String>)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  testWidgets('options follow the selected parent and stale picks reset', (
    tester,
  ) async {
    final controller = BoFFormController();
    addTearDown(controller.dispose);
    await pumpForm(tester, BoF.form(_address(), controller: controller));

    expect(controller.values, {'country': null, 'region': null, 'city': null});

    await pick(tester, 'Country', 'PH');
    await pick(tester, 'Region', 'Luzon');
    await pick(tester, 'City', 'Baguio');
    expect(controller.values, {
      'country': 'PH',
      'region': 'Luzon',
      'city': 'Baguio',
    });

    // Changing the country clears the region, which cascades to the city.
    await pick(tester, 'Country', 'JP');
    expect(controller.values, {'country': 'JP', 'region': null, 'city': null});
    expect(find.text('Luzon'), findsNothing);
    expect(find.text('Baguio'), findsNothing);

    await pick(tester, 'Region', 'Kansai');
    expect(controller.value('region'), 'Kansai');
    expect(tester.takeException(), isNull);
  });

  testWidgets('setValue and reset also reset dependent fields', (tester) async {
    final controller = BoFFormController();
    addTearDown(controller.dispose);
    await pumpForm(tester, BoF.form(_address(), controller: controller));

    controller.setValue('country', 'PH');
    await tester.pumpAndSettle();
    controller.setValue('region', 'Visayas');
    await tester.pumpAndSettle();
    expect(find.text('Visayas'), findsOneWidget);

    controller.setValue('country', 'JP');
    await tester.pumpAndSettle();
    expect(controller.value('region'), isNull);
    expect(find.text('Visayas'), findsNothing);

    controller.setValue('region', 'Kanto');
    await tester.pumpAndSettle();
    controller.reset();
    await tester.pumpAndSettle();
    expect(controller.values, {'country': null, 'region': null, 'city': null});
  });

  testWidgets(
    'fields a builder stops returning are not validated or submitted',
    (tester) async {
      final controller = BoFFormController();
      addTearDown(controller.dispose);
      Map<String, Object?>? submitted;
      await pumpForm(
        tester,
        BoF.form(
          [
            BoFSwitchField(name: 'company', label: const Text('Company')),
            BoFDynamic(
              dependsOn: const ['company'],
              builder: (values) => [
                if (values['company'] == true)
                  BoFTextField(
                    name: 'companyName',
                    label: const Text('Company name'),
                    validator: const NotEmptyValidator(),
                  ),
              ],
            ),
          ],
          controller: controller,
          onSubmit: (values) => submitted = values,
        ),
      );
      expect(find.text('Company name'), findsNothing);

      controller.setValue('company', true);
      await tester.pumpAndSettle();
      expect(find.text('Company name'), findsOneWidget);
      await controller.submit();
      await tester.pumpAndSettle();
      expect(submitted, isNull);
      expect(controller.isValid, isFalse);

      controller.setValue('company', false);
      await tester.pumpAndSettle();
      expect(find.text('Company name'), findsNothing);
      expect(controller.isValid, isTrue);
      await controller.submit();
      await tester.pumpAndSettle();
      expect(submitted, {'company': false});
    },
  );

  testWidgets('initial values seed the fields they make a builder return', (
    tester,
  ) async {
    final controller = BoFFormController();
    addTearDown(controller.dispose);
    await pumpForm(
      tester,
      BoF.form([
        BoFSelectField<String>(
          name: 'country',
          label: const Text('Country'),
          options: _optionsOf(_regions.keys),
          initialValue: 'JP',
        ),
        BoFDynamic(
          dependsOn: const ['country'],
          builder: (values) => [
            BoFSelectField<String>(
              name: 'region',
              label: const Text('Region'),
              options: _optionsOf(_regions[values['country']]),
              initialValue: _regions[values['country']]?.first,
            ),
          ],
        ),
      ], controller: controller),
    );
    expect(controller.values, {'country': 'JP', 'region': 'Kanto'});
    expect(find.text('Kanto'), findsOneWidget);

    controller.setValue('country', 'PH');
    await tester.pumpAndSettle();
    expect(controller.value('region'), 'Luzon');
    expect(find.text('Luzon'), findsOneWidget);

    controller.reset();
    await tester.pumpAndSettle();
    expect(controller.values, {'country': 'JP', 'region': 'Kanto'});
    expect(find.text('Kanto'), findsOneWidget);
  });

  testWidgets('a dynamic entry inside a BoFRow shares one column', (
    tester,
  ) async {
    await pumpForm(
      tester,
      BoF.form([
        BoFRow([
          BoFTextField(name: 'street', label: const Text('Street')),
          BoFDynamic(
            builder: (values) => [
              BoFTextField(name: 'city', label: const Text('City')),
              BoFTextField(name: 'zip', label: const Text('ZIP')),
            ],
          ),
        ]),
      ]),
    );
    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(3));
    final street = tester.getRect(fields.at(0));
    final city = tester.getRect(fields.at(1));
    final zip = tester.getRect(fields.at(2));
    expect(city.top, street.top);
    expect(zip.left, city.left);
    expect(zip.top, greaterThan(city.bottom));
  });
}
