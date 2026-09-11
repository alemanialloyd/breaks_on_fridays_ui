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

  testWidgets(
    'BoF.textField exposes a leading icon and password toggle',
    (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: BoF.textField(
              leadingIcon: const Icon(Icons.person),
              showPasswordToggle: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      // Starts obscured, so the "reveal" (eye) icon is shown.
      expect(find.byIcon(LucideIcons.eye), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.eye));
      await tester.pump();

      // After revealing, the toggle swaps to the "hide" (eyeOff) icon.
      expect(find.byIcon(LucideIcons.eyeOff), findsOneWidget);
    },
  );

  testWidgets(
    'BoF.button resolves backgroundColor/foregroundColor/fontSize/borderRadius',
    (tester) async {
      const bg = Color(0xFF123456);
      const fg = Color(0xFFABCDEF);
      const radius = BorderRadius.all(Radius.circular(2));

      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: BoF.button(
              'Styled',
              onPressed: () {},
              backgroundColor: bg,
              foregroundColor: fg,
              fontSize: 22,
              borderRadius: radius,
            ),
          ),
        ),
      );

      final button = tester.widget<Button>(find.byType(Button));
      const states = <WidgetState>{};
      final context = tester.element(find.byType(Button));
      final decoration = button.style.decoration(context, states);
      final textStyle = button.style.textStyle(context, states);

      expect(decoration, isA<BoxDecoration>());
      expect((decoration as BoxDecoration).color, bg);
      expect(decoration.borderRadius, radius);
      expect(textStyle.color, fg);
      expect(textStyle.fontSize, 22);
    },
  );

  testWidgets(
    'BoF.textField resolves backgroundColor/fontSize',
    (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: BoF.textField(
              backgroundColor: const Color(0xFF001122),
              fontSize: 20,
            ),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.color, const Color(0xFF001122));
      expect(field.style?.fontSize, 20);
    },
  );

  testWidgets('BoF.button centers its content by default', (tester) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: BoF.button(
            'Next',
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        ),
      ),
    );

    final button = tester.widget<Button>(find.byType(Button));
    expect(button.alignment, Alignment.center);
  });

  testWidgets(
    'BoFFormController.setValue() pushes the change into the rendered field',
    (tester) async {
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

      expect(find.text('prefilled@example.com'), findsNothing);

      controller.setValue('email', 'prefilled@example.com');
      await tester.pump();

      expect(find.text('prefilled@example.com'), findsOneWidget);
      expect(controller.value<String>('email'), 'prefilled@example.com');
    },
  );

  testWidgets(
    'setValue on one field does not disturb another field being typed into',
    (tester) async {
      final controller = BoFFormController();

      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: BoF.form(
              [
                BoFTextField(name: 'name', label: BoF.text('Name')),
                BoFCheckboxField(name: 'agree', label: BoF.text('Agree')),
              ],
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'still typing');
      await tester.pump();
      expect(find.text('still typing'), findsOneWidget);

      // Programmatically changing the *other* field shouldn't remount (and
      // thus shouldn't clear) the text the user is mid-typing.
      controller.setValue('agree', CheckboxState.checked);
      await tester.pump();

      expect(find.text('still typing'), findsOneWidget);
    },
  );

  testWidgets("BoF.datePickerField outlines today's cell and no other",
      (tester) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Center(child: BoF.datePickerField(onChanged: (_) {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(OutlineButton));
    await tester.pumpAndSettle();

    bool cellHasBorder(Finder dayTextFinder) {
      final cellFinder = find.ancestor(
        of: dayTextFinder,
        matching: find.byType(CalendarItem),
      );
      final decoratedBoxes = find.descendant(
        of: cellFinder,
        matching: find.byWidgetPredicate((w) => w is OverflowDecoratedBox),
      );
      for (final element in decoratedBoxes.evaluate()) {
        final decoration = (element.widget as OverflowDecoratedBox).decoration;
        if (decoration is BoxDecoration && decoration.border != null) {
          return true;
        }
      }
      return false;
    }

    final today = DateTime.now();
    expect(cellHasBorder(find.text('${today.day}').first), isTrue);

    final otherDay = today.day == 1 ? 2 : 1;
    expect(cellHasBorder(find.text('$otherDay').first), isFalse);
  });

  testWidgets(
    'BoF.dateInputField zero-pads single-digit month/day, including after '
    'picking a date from the embedded calendar',
    (tester) async {
      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: Center(
              child: BoF.dateInputField(
                initialValue: DateTime(2026, 9, 7),
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      List<String> segmentTexts() => find
          .byType(EditableText)
          .evaluate()
          .map((e) => (e.widget as EditableText).controller.text)
          .toList();

      expect(segmentTexts(), ['09', '07', '2026']);

      await tester.tap(find.byIcon(LucideIcons.calendarDays));
      await tester.pumpAndSettle();
      await tester.tap(find.text('7').first);
      await tester.pumpAndSettle();

      expect(segmentTexts(), ['09', '07', '2026']);
    },
  );
}
