import 'package:flutter/material.dart' as material show Icons;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:skeletonizer/skeletonizer.dart' as skeleton;

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

void main() {
  testWidgets(
    'standalone and form text fields share appearance and report edits',
    (tester) async {
      const fill = Color(0xFF112233);
      const radius = BorderRadius.all(Radius.circular(16));
      const padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
      const border = Border.fromBorderSide(
        BorderSide(color: Color(0xFF445566), width: 3),
      );
      final controller = BoFFormController();
      addTearDown(controller.dispose);
      String? changed;
      String? standaloneChanged;
      final formatters = [FilteringTextInputFormatter.digitsOnly];
      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: ComponentTheme<TextFieldTheme>(
              data: const TextFieldTheme(border: border),
              child: Column(
                children: [
                  BoF.textField(
                    backgroundColor: fill,
                    filled: true,
                    borderRadius: radius,
                    borderWidth: 2,
                    padding: padding,
                    style: const TextStyle(fontSize: 10, letterSpacing: 2),
                    foregroundColor: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.end,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.white,
                    selectionColor: Colors.teal,
                    cursorWidth: 3,
                    cursorHeight: 20,
                    cursorRadius: const Radius.circular(3),
                    showCursor: true,
                    inputFormatters: formatters,
                    onChanged: (value) => standaloneChanged = value,
                  ),
                  BoF.form([
                    BoFTextField(
                      name: 'amount',
                      label: BoF.text('Amount'),
                      backgroundColor: fill,
                      filled: true,
                      borderRadius: radius,
                      borderWidth: 2,
                      padding: padding,
                      style: const TextStyle(fontSize: 10, letterSpacing: 2),
                      foregroundColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.end,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: Colors.white,
                      selectionColor: Colors.teal,
                      cursorWidth: 3,
                      cursorHeight: 20,
                      cursorRadius: const Radius.circular(3),
                      showCursor: true,
                      inputFormatters: formatters,
                      onChanged: (value) {
                        expect(controller.value('amount'), value);
                        changed = value;
                      },
                    ),
                  ], controller: controller),
                ],
              ),
            ),
          ),
        ),
      );
      final fields = find.byType(TextField);
      for (final field in tester.widgetList<TextField>(fields)) {
        expect(field.padding, padding);
        expect(field.style?.fontSize, 18);
        expect(field.style?.letterSpacing, 2);
        expect(field.style?.fontWeight, FontWeight.w600);
        expect(field.textAlign, TextAlign.end);
        expect(field.textAlignVertical, TextAlignVertical.center);
        expect(field.cursorColor, Colors.white);
        expect(field.cursorWidth, 3);
        expect(field.cursorHeight, 20);
        expect(field.cursorRadius, const Radius.circular(3));
        expect(field.showCursor, true);
      }
      final surfaces = find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == fill,
      );
      expect(surfaces, findsNWidgets(2));
      for (final surface in tester.widgetList<DecoratedBox>(surfaces)) {
        final decoration = surface.decoration as BoxDecoration;
        expect(decoration.borderRadius, radius);
        expect((decoration.border as Border).top.color, border.top.color);
        expect((decoration.border as Border).top.width, 2);
      }
      await tester.enterText(fields.at(0), 'a12');
      await tester.pump();
      expect(
        tester
            .widget<EditableText>(
              find.descendant(
                of: fields.at(0),
                matching: find.byType(EditableText),
              ),
            )
            .selectionColor,
        Colors.teal,
      );
      expect(standaloneChanged, '12');
      await tester.enterText(fields.at(1), 'b34');
      await tester.pump();
      expect(
        tester
            .widget<EditableText>(
              find.descendant(
                of: fields.at(1),
                matching: find.byType(EditableText),
              ),
            )
            .selectionColor,
        Colors.teal,
      );
      expect(changed, '34');
      expect(controller.value('amount'), '34');
      controller.setValue('amount', '56');
      await tester.pump();
      expect(find.text('56'), findsOneWidget);
    },
  );

  testWidgets(
    'text field decoration and explicit unfilled state take precedence',
    (tester) async {
      const decoration = BoxDecoration(color: Color(0xFFabcdef));
      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: Column(
              children: [
                BoF.textField(backgroundColor: Colors.blue, filled: false),
                BoF.form([
                  BoFTextField(
                    name: 'custom',
                    label: BoF.text('Custom'),
                    backgroundColor: Colors.blue,
                    borderColor: Colors.red,
                    borderWidth: 4,
                    decoration: decoration,
                    enabled: false,
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
      final fields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      expect(fields.first.filled, false);
      expect(fields.last.decoration, decoration);
      expect(fields.last.enabled, false);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == Colors.blue,
        ),
        findsNothing,
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is DecoratedBox && widget.decoration == decoration,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'BoF.skeleton renders enabled and disabled loading placeholders',
    (tester) async {
      for (final enabled in [true, false]) {
        await tester.pumpWidget(
          ShadcnApp(
            home: Scaffold(
              child: BoF.skeleton(
                BoF.text('Loading content'),
                enabled: enabled,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        final placeholder = find.byWidgetPredicate(
          (widget) => widget is skeleton.Skeletonizer,
        );
        expect(placeholder, findsOneWidget);
        expect(
          tester.widget<skeleton.Skeletonizer>(placeholder).enabled,
          enabled,
        );
        expect(find.text('Loading content'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('BoF.text, BoF.button and BoF.container render', (tester) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Column(
            children: [
              BoF.text('Title'),
              BoF.button('Press Me', onPressed: () {}),
              BoF.container(BoF.text('Card'), type: BoFContainerType.outline),
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
      ShadcnApp(home: Scaffold(child: BoF.card(BoF.text('Card body')))),
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
                      child: const Icon(material.Icons.close),
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
              BoF.button(
                null,
                icon: const Icon(material.Icons.add),
                onPressed: () {},
              ),
              BoF.button('Save', onPressed: () {}),
              BoF.button(
                'Next',
                icon: const Icon(material.Icons.arrow_forward),
                iconPosition: BoFIconPosition.right,
                onPressed: () {},
              ),
              BoF.button(
                'Up',
                icon: const Icon(material.Icons.arrow_upward),
                iconPosition: BoFIconPosition.top,
                onPressed: () {},
              ),
              BoF.button(
                'Down',
                icon: const Icon(material.Icons.arrow_downward),
                iconPosition: BoFIconPosition.bottom,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(material.Icons.add), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.byIcon(material.Icons.arrow_forward), findsOneWidget);
    expect(find.text('Up'), findsOneWidget);
    expect(find.byIcon(material.Icons.arrow_upward), findsOneWidget);
    expect(find.text('Down'), findsOneWidget);
    expect(find.byIcon(material.Icons.arrow_downward), findsOneWidget);
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
                  trailing: const Icon(material.Icons.warning_amber_rounded),
                  padding: const EdgeInsets.all(32),
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

    expect(find.byIcon(material.Icons.warning_amber_rounded), findsOneWidget);
    expect(
      tester.widget<AlertDialog>(find.byType(AlertDialog)).padding,
      const EdgeInsets.all(32),
    );

    expect(find.text('Delete item'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(result, true);
    expect(find.text('Delete item'), findsNothing);
  });

  testWidgets('alert dialog custom radius matches its backdrop and surface', (
    tester,
  ) async {
    const radius = BorderRadiusDirectional.only(topStart: Radius.circular(24));
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Builder(
            builder: (context) => BoF.button(
              'Open styled dialog',
              onPressed: () => BoF.alertDialog(
                context,
                title: 'Styled dialog',
                positiveText: 'Done',
                borderRadius: radius,
                surfaceBlur: 8,
                surfaceOpacity: 0.9,
                barrierColor: const Color(0x66000000),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open styled dialog'));
    await tester.pumpAndSettle();
    final surface = tester.widget<ModalContainer>(find.byType(ModalContainer));
    final backdropPaint = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is SurfaceBarrierPainter,
      ),
    );
    final backdrop = backdropPaint.painter! as SurfaceBarrierPainter;
    expect(surface.borderRadius, radius);
    expect(backdrop.borderRadius, radius.resolve(TextDirection.ltr));
    expect(surface.surfaceBlur, 8);
    expect(surface.surfaceOpacity, 0.9);
    expect(backdrop.barrierColor, const Color(0x66000000));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Styled dialog'), findsNothing);
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
                  options: const [BoFOption(value: 'a', label: Text('A'))],
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

  testWidgets('BoF.form works with a GlobalKey alongside BoFFormController', (
    tester,
  ) async {
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
  });

  testWidgets('BoFFormController.reset() clears the rendered field state', (
    tester,
  ) async {
    final controller = BoFFormController();

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: BoF.form([
            BoFTextField(name: 'email', label: BoF.text('Email')),
          ], controller: controller),
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

  testWidgets('BoF.textField exposes a leading icon and password toggle', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: BoF.textField(
            leadingIcon: const Icon(material.Icons.person),
            showPasswordToggle: true,
          ),
        ),
      ),
    );

    expect(find.byIcon(material.Icons.person), findsOneWidget);
    // Starts obscured, so the "reveal" (eye) icon is shown.
    expect(find.byIcon(LucideIcons.eye), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.eye));
    await tester.pump();

    // After revealing, the toggle swaps to the "hide" (eyeOff) icon.
    expect(find.byIcon(LucideIcons.eyeOff), findsOneWidget);
  });

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

  testWidgets('BoF.textField backgroundColor preserves the themed decoration', (
    tester,
  ) async {
    const border = Border.fromBorderSide(
      BorderSide(color: Color(0xFF445566), width: 3),
    );
    const radius = BorderRadius.all(Radius.circular(18));

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: ComponentTheme<TextFieldTheme>(
            data: const TextFieldTheme(
              border: border,
              borderRadius: radius,
              padding: EdgeInsets.all(14),
            ),
            child: BoF.textField(
              backgroundColor: const Color(0xFF001122),
              fontSize: 20,
            ),
          ),
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration, isNull);
    expect(field.style?.fontSize, 20);

    final decoratedField = tester.widget<DecoratedBox>(
      find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color ==
                const Color(0xFF001122),
      ),
    );
    final decoration = decoratedField.decoration as BoxDecoration;
    expect(decoration.border, border);
    expect(decoration.borderRadius, radius);
  });

  testWidgets('BoF.button centers its content by default', (tester) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: BoF.button(
            'Next',
            icon: const Icon(material.Icons.arrow_forward),
            onPressed: () {},
          ),
        ),
      ),
    );

    final button = tester.widget<Button>(find.byType(Button));
    expect(button.alignment, Alignment.center);
  });

  testWidgets('BoF.button can center an icon and label as one group', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: SizedBox(
            width: 300,
            child: BoF.button(
              'Next',
              icon: const Icon(material.Icons.arrow_forward),
              centerContent: true,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final button = tester.widget<Button>(find.byType(Button));
    expect(button.leading, isNull);
    expect(button.trailing, isNull);
    final content = tester.widget<Row>(
      find
          .descendant(of: find.byType(Button), matching: find.byType(Row))
          .first,
    );
    expect(content.mainAxisSize, MainAxisSize.min);
    expect(content.crossAxisAlignment, CrossAxisAlignment.center);
  });

  testWidgets('BoF.accordion styles header and content containers', (
    tester,
  ) async {
    const headerColor = Color(0xFF112233);
    const contentColor = Color(0xFF445566);

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: BoF.accordion(
            dividerHeight: 0,
            items: [
              BoFAccordionItem(
                title: const Text('Styled header'),
                content: const Text('Styled content'),
                expanded: true,
                headerDecoration: const BoxDecoration(color: headerColor),
                contentDecoration: const BoxDecoration(color: contentColor),
                headerPadding: const EdgeInsets.all(4),
                contentPadding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final headerContainer = tester.widget<Container>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color == headerColor,
      ),
    );
    final contentContainer = tester.widget<Container>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color == contentColor,
      ),
    );
    expect((headerContainer.decoration as BoxDecoration).color, headerColor);
    expect((contentContainer.decoration as BoxDecoration).color, contentColor);
    expect(headerContainer.padding, const EdgeInsets.all(4));
    expect(contentContainer.padding, const EdgeInsets.all(8));
  });

  testWidgets(
    'BoFFormController.setValue() pushes the change into the rendered field',
    (tester) async {
      final controller = BoFFormController();

      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: BoF.form([
              BoFTextField(name: 'email', label: BoF.text('Email')),
            ], controller: controller),
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
            child: BoF.form([
              BoFTextField(name: 'name', label: BoF.text('Name')),
              BoFCheckboxField(name: 'agree', label: BoF.text('Agree')),
            ], controller: controller),
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

  testWidgets("BoF.datePickerField outlines today's cell and no other", (
    tester,
  ) async {
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
