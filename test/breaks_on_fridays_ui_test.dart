import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

void main() {
  testWidgets('BoF.text, BoF.button and BoF.container render', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Column(
            children: [
              BoF.text('Title'),
              BoF.button('Press Me', onPressed: () {}),
              BoF.container(
                BoF.text('Card'),
                type: BoFContainerType.outline,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Press Me'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
  });

  testWidgets('BoF.card renders', (tester) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(child: BoF.card(BoF.text('Card body'))),
      ),
    );

    expect(find.text('Card body'), findsOneWidget);
  });

  testWidgets('BoF.toast shows content and closes programmatically', (
    tester,
  ) async {
    ToastOverlay? toast;

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Builder(
            builder: (context) => BoF.button(
              'Notify',
              onPressed: () {
                toast = BoF.toast(
                  context,
                  title: 'Saved',
                  message: 'Your changes were saved.',
                  // Keep this short so no auto-dismiss timer outlives the test.
                  showDuration: const Duration(milliseconds: 300),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Notify'));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Your changes were saved.'), findsOneWidget);
    expect(toast, isNotNull);
    expect(toast!.isShowing, isTrue);

    toast!.close();
    await tester.pump(const Duration(milliseconds: 600));
    // Let the (short) auto-dismiss timer elapse too, so none is left
    // pending when the test tears down.
    await tester.pump(const Duration(milliseconds: 600));

    expect(toast!.isShowing, isFalse);
  });

  testWidgets('BoF.dropdownMenu shows items and invokes onPressed', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Builder(
            builder: (context) => BoF.button(
              'Actions',
              onPressed: () => BoF.dropdownMenu(
                context,
                items: [
                  BoFMenuItem(
                    child: BoF.text('Delete'),
                    onPressed: () => tapped = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();

    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets(
    'BoF display/layout widgets (avatar, badge, chip, divider, progress, '
    'skeleton, alert, accordion) render',
    (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BoF.avatar(initials: 'JD'),
                  BoF.badge(BoF.text('New'), type: BoFBadgeType.destructive),
                  BoF.chip(
                    BoF.text('Filter'),
                    trailing: BoF.chipButton(
                      child: const Icon(Icons.close),
                      onPressed: () {},
                    ),
                  ),
                  BoF.divider(),
                  BoF.progress(progress: 0.5),
                  BoF.circularProgress(value: 0.5),
                  BoF.skeleton(BoF.text('Loading')),
                  BoF.alert(
                    title: BoF.text('Heads up'),
                    content: BoF.text('Something happened.'),
                    destructive: true,
                  ),
                  BoF.accordion(
                    items: [
                      BoFAccordionItem(
                        title: BoF.text('Section 1'),
                        content: BoF.text('Body 1'),
                        expanded: true,
                      ),
                      BoFAccordionItem(
                        title: BoF.text('Section 2'),
                        content: BoF.text('Body 2'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      // Not pumpAndSettle: the progress bar and skeleton pulse animate
      // indefinitely, so settling would never complete.
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('New'), findsOneWidget);
      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('Heads up'), findsOneWidget);
      expect(find.text('Something happened.'), findsOneWidget);
      expect(find.text('Section 1'), findsOneWidget);
      expect(find.text('Body 1'), findsOneWidget);
      expect(find.text('Section 2'), findsOneWidget);
    },
  );

  testWidgets('BoF.button supports icon-only, label-only and icon+label', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Column(
            children: [
              BoF.button(null, icon: const Icon(Icons.add), onPressed: () {}),
              BoF.button('Save', onPressed: () {}),
              BoF.button(
                'Next',
                icon: const Icon(Icons.arrow_forward),
                iconPosition: BoFIconPosition.right,
                onPressed: () {},
              ),
              BoF.button(
                'Up',
                icon: const Icon(Icons.arrow_upward),
                iconPosition: BoFIconPosition.top,
                onPressed: () {},
              ),
              BoF.button(
                'Down',
                icon: const Icon(Icons.arrow_downward),
                iconPosition: BoFIconPosition.bottom,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    expect(find.text('Up'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    expect(find.text('Down'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
  });

  testWidgets('BoF.alertDialog shows and resolves via the positive button', (
    tester,
  ) async {
    Object? result;

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Builder(
            builder: (context) => BoF.button(
              'Open',
              onPressed: () async {
                result = await BoF.alertDialog(
                  context,
                  title: 'Delete item',
                  content: 'This cannot be undone.',
                  positiveText: 'Delete',
                  negativeText: 'Cancel',
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Delete item'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(result, true);
    expect(find.text('Delete item'), findsNothing);
  });

  testWidgets('standalone BoF form widgets render without a BoF.form', (
    tester,
  ) async {
    String? changedText;

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BoF.textField(onChanged: (v) => changedText = v),
                BoF.checkboxField(),
                BoF.switchField(),
                BoF.radioGroupField<String>(
                  options: const [
                    BoFOption(value: 'a', label: Text('A')),
                    BoFOption(value: 'b', label: Text('B')),
                  ],
                ),
                BoF.selectField<String>(
                  options: const [
                    BoFOption(value: 'a', label: Text('A')),
                  ],
                ),
                BoF.sliderField(),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'hello');
    expect(changedText, 'hello');
  });

  testWidgets('BoF.form renders a representative set of fields and submits', (
    tester,
  ) async {
    final controller = BoFFormController();
    Map<String, Object?>? submitted;

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: SingleChildScrollView(
            child: BoF.form(
              [
                BoFTextField(
                  name: 'email',
                  label: BoF.text('Email'),
                  validator: const EmailValidator(),
                ),
                BoFNumberField(name: 'age', label: BoF.text('Age')),
                BoFCheckboxField(name: 'agree', label: BoF.text('Agree')),
                BoFSwitchField(name: 'notify', label: BoF.text('Notify')),
                BoFRadioGroupField<String>(
                  name: 'plan',
                  label: BoF.text('Plan'),
                  options: const [
                    BoFOption(value: 'free', label: Text('Free')),
                    BoFOption(value: 'pro', label: Text('Pro')),
                  ],
                ),
                BoFSelectField<String>(
                  name: 'country',
                  label: BoF.text('Country'),
                  options: const [
                    BoFOption(value: 'us', label: Text('United States')),
                    BoFOption(value: 'ph', label: Text('Philippines')),
                  ],
                ),
                BoFMultipleChoiceField<String>(
                  name: 'size',
                  label: BoF.text('Size'),
                  options: const [
                    BoFOption(value: 's', label: Text('S')),
                    BoFOption(value: 'm', label: Text('M')),
                  ],
                ),
                BoFSliderField(name: 'volume', label: BoF.text('Volume')),
                BoFStarRatingField(name: 'rating', label: BoF.text('Rating')),
                BoFDatePickerField(name: 'date', label: BoF.text('Date')),
              ],
              controller: controller,
              onSubmit: (values) => submitted = values,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Plan'), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('S'), findsOneWidget);

    await controller.submit();
    await tester.pumpAndSettle();

    expect(submitted, isNotNull);
    expect(submitted!.containsKey('email'), isTrue);
    expect(submitted!.containsKey('plan'), isTrue);
  });

  testWidgets(
    'BoF.form works with a GlobalKey alongside BoFFormController',
    (tester) async {
      final formKey = GlobalKey();
      final controller = BoFFormController();

      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: SingleChildScrollView(
              child: BoF.form(
                [BoFTextField(name: 'email', label: BoF.text('Email'))],
                key: formKey,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      expect(formKey.currentContext, isNotNull);
      expect(
        () => Scrollable.ensureVisible(formKey.currentContext!),
        returnsNormally,
      );
    },
  );

  testWidgets('BoFFormController.reset() clears the rendered field state', (
    tester,
  ) async {
    final controller = BoFFormController();

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: BoF.form(
            [BoFTextField(name: 'email', label: BoF.text('Email'))],
            controller: controller,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'hello@example.com');
    await tester.pump();
    expect(find.text('hello@example.com'), findsOneWidget);
    expect(controller.value<String>('email'), 'hello@example.com');

    controller.reset();
    await tester.pump();

    expect(find.text('hello@example.com'), findsNothing);
    expect(controller.value<String>('email'), isNull);
  });
}
