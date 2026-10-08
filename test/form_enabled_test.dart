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

  testWidgets('enabled: false disables the rendered input', (tester) async {
    await pumpForm(
      tester,
      BoF.form([
        BoFTextField(name: 'title', label: BoF.text('Title')),
        BoFTextField(name: 'locked', label: BoF.text('Locked'), enabled: false),
      ]),
    );

    final fields = tester.widgetList<TextField>(find.byType(TextField));
    expect(fields.map((f) => f.enabled), [true, false]);
  });

  testWidgets('a disabled select does not open', (tester) async {
    await pumpForm(
      tester,
      BoF.form([
        BoFSelectField<String>(
          name: 'tag',
          label: BoF.text('Tag'),
          options: const [
            BoFOption(value: 'a', label: Text('Alpha')),
            BoFOption(value: 'b', label: Text('Beta')),
          ],
          initialValue: 'a',
          enabled: false,
        ),
      ]),
    );

    await tester.tap(find.byType(Select<String>), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('phone and OTP fields block input when disabled', (tester) async {
    await pumpForm(
      tester,
      BoF.form([
        BoFPhoneField(name: 'phone', label: BoF.text('Phone'), enabled: false),
        BoFOtpField(
          name: 'otp',
          label: BoF.text('Code'),
          length: 4,
          enabled: false,
        ),
      ]),
    );

    for (final type in [PhoneInput, InputOTP]) {
      final blocker = tester.widget<IgnorePointer>(
        find
            .ancestor(
              of: find.byType(type),
              matching: find.byType(IgnorePointer),
            )
            .first,
      );
      expect(blocker.ignoring, isTrue);
    }
  });

  testWidgets('disabled fields skip validation but are still submitted', (
    tester,
  ) async {
    final controller = BoFFormController();
    addTearDown(controller.dispose);
    Map<String, Object?>? submitted;

    await pumpForm(
      tester,
      BoF.form(
        [
          BoFTextField(
            name: 'locked',
            label: BoF.text('Locked'),
            initialValue: '',
            validator: const NotEmptyValidator(),
            enabled: false,
          ),
        ],
        controller: controller,
        onSubmit: (values) => submitted = values,
      ),
    );

    await controller.submit();
    await tester.pump();
    expect(controller.errorOf('locked'), isNull);
    expect(submitted, {'locked': ''});
  });

  testWidgets('validation errors notify controller listeners', (tester) async {
    final controller = BoFFormController();
    addTearDown(controller.dispose);

    await pumpForm(
      tester,
      BoF.form([
        BoFTextField(
          name: 'email',
          label: BoF.text('Email'),
          validator: const NotEmptyValidator(),
        ),
      ], controller: controller),
    );

    final seen = <bool>[];
    controller.addListener(() => seen.add(controller.isValid));

    await controller.submit();
    await tester.pump();
    expect(seen, [false]);

    await tester.enterText(find.byType(TextField), 'a@b.com');
    await tester.pump();
    expect(seen.last, isTrue);
  });
}
