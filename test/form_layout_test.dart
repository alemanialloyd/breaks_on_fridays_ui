import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

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

  testWidgets('BoFRow places fields side by side with flex widths', (
    tester,
  ) async {
    await pumpForm(
      tester,
      BoF.form([
        BoFRow(
          [
            BoFTextField(name: 'city', label: BoF.text('City')),
            BoFTextField(name: 'zip', label: BoF.text('ZIP')),
          ],
          flex: const [2, 1],
          spacing: 10,
        ),
        BoFTextField(name: 'email', label: BoF.text('Email')),
      ]),
    );

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(3));
    final city = tester.getRect(fields.at(0));
    final zip = tester.getRect(fields.at(1));
    final email = tester.getRect(fields.at(2));

    expect(city.top, zip.top);
    expect(zip.left - city.right, moreOrLessEquals(10));
    expect(city.width, moreOrLessEquals(zip.width * 2));
    expect(email.top, greaterThan(city.bottom));
    expect(email.width, moreOrLessEquals(city.width + zip.width + 10));
  });

  testWidgets('nested fields are validated, submitted and reset', (
    tester,
  ) async {
    final controller = BoFFormController();
    addTearDown(controller.dispose);
    Map<String, Object?>? submitted;

    await pumpForm(
      tester,
      BoF.form(
        [
          BoFCustom(BoF.text('Shipping')),
          BoFRow([
            BoFColumn([
              BoFTextField(
                name: 'first',
                label: BoF.text('First name'),
                validator: const NotEmptyValidator(),
              ),
              BoFTextField(name: 'middle', label: BoF.text('Middle name')),
            ]),
            BoFTextField(
              name: 'last',
              label: BoF.text('Last name'),
              initialValue: 'Doe',
            ),
          ]),
        ],
        controller: controller,
        onSubmit: (values) => submitted = values,
      ),
    );

    expect(find.text('Shipping'), findsOneWidget);
    expect(controller.value<String>('last'), 'Doe');

    await controller.submit();
    await tester.pump();
    expect(submitted, isNull);
    expect(controller.errorOf('first'), isA<InvalidResult>());

    await tester.enterText(find.byType(TextField).first, 'Jane');
    await tester.pump();
    await controller.submit();
    await tester.pump();
    expect(submitted, isNotNull);
    expect(submitted!['first'], 'Jane');
    expect(submitted!['last'], 'Doe');
    expect(submitted!.containsKey('middle'), isTrue);

    controller.setValue('last', 'Smith');
    await tester.pump();
    expect(find.text('Smith'), findsOneWidget);

    controller.reset();
    await tester.pump();
    expect(controller.value<String>('first'), isNull);
    expect(controller.value<String>('last'), 'Doe');
    expect(find.text('Doe'), findsOneWidget);
  });

  testWidgets('duplicate field names across layout entries are rejected', (
    tester,
  ) async {
    await pumpForm(
      tester,
      BoF.form([
        BoFTextField(name: 'email', label: BoF.text('Email')),
        BoFRow([BoFTextField(name: 'email', label: BoF.text('Email again'))]),
      ]),
    );
    expect(tester.takeException(), isA<FlutterError>());
  });
}
