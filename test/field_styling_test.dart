import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

const _fill = Color(0xFF102030);
const _fg = Color(0xFFF0E0D0);
const _borderColor = Color(0xFF00AA55);
const _radius = BorderRadius.all(Radius.circular(14));

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ShadcnApp(
      home: Scaffold(
        child: Center(child: SizedBox(width: 400, child: child)),
      ),
    ),
  );
  await tester.pump();
}

Widget _form(BoFField field) => BoF.form([field]);

Finder _filled(Color color) => find.byWidgetPredicate(
  (widget) =>
      widget is DecoratedBox &&
      widget.decoration is BoxDecoration &&
      (widget.decoration as BoxDecoration).color == color,
);

Finder _bordered(Color color) => find.byWidgetPredicate((widget) {
  final decoration = widget is DecoratedBox ? widget.decoration : null;
  if (decoration is! BoxDecoration) return false;
  final border = decoration.border;
  return border is Border && border.top.color == color;
});

List<BoxDecoration> _buttonDecorations(WidgetTester tester) => [
  for (final element in find.byType(Button).evaluate())
    if ((element.widget as Button).style.decoration(element, const {})
        case final BoxDecoration decoration)
      decoration,
];

void main() {
  group('text-based fields share BoF.textField styling', () {
    final cases = <String, List<Widget>>{
      'text area': [
        BoF.textAreaField(
          backgroundColor: _fill,
          borderColor: _borderColor,
          borderWidth: 3,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          foregroundColor: _fg,
          cursorColor: _fg,
        ),
        _form(
          BoFTextAreaField(
            name: 'a',
            label: const Text('A'),
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            foregroundColor: _fg,
            cursorColor: _fg,
          ),
        ),
      ],
      'number': [
        BoF.numberField(
          backgroundColor: _fill,
          borderColor: _borderColor,
          borderWidth: 3,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          foregroundColor: _fg,
          cursorColor: _fg,
        ),
        _form(
          BoFNumberField(
            name: 'n',
            label: const Text('N'),
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            foregroundColor: _fg,
            cursorColor: _fg,
          ),
        ),
      ],
      'autocomplete': [
        BoF.autoCompleteField(
          suggestions: const ['a'],
          backgroundColor: _fill,
          borderColor: _borderColor,
          borderWidth: 3,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          foregroundColor: _fg,
          cursorColor: _fg,
        ),
        _form(
          BoFAutoCompleteField(
            name: 'ac',
            label: const Text('AC'),
            suggestions: const ['a'],
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            foregroundColor: _fg,
            cursorColor: _fg,
          ),
        ),
      ],
      'chip input': [
        BoF.chipInputField<String>(
          chipBuilder: (context, value) => Text(value),
          onChipSubmitted: (text) => text,
          backgroundColor: _fill,
          borderColor: _borderColor,
          borderWidth: 3,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          foregroundColor: _fg,
          cursorColor: _fg,
        ),
        _form(
          BoFChipInputField<String>(
            name: 'c',
            label: const Text('C'),
            chipBuilder: (context, value) => Text(value),
            onChipSubmitted: (text) => text,
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            foregroundColor: _fg,
            cursorColor: _fg,
          ),
        ),
      ],
    };
    cases.forEach((name, widgets) {
      for (final (index, widget) in widgets.indexed) {
        testWidgets('$name (${index == 0 ? 'standalone' : 'form'})', (
          tester,
        ) async {
          await _pump(tester, widget);
          final surface = tester.widget<DecoratedBox>(_filled(_fill).first);
          final border =
              (surface.decoration as BoxDecoration).border! as Border;
          expect(border.top.color, _borderColor);
          expect(border.top.width, 3);
          final editable = tester.widget<EditableText>(
            find.byType(EditableText),
          );
          expect(editable.style.fontSize, 19);
          expect(editable.style.fontWeight, FontWeight.w700);
          expect(editable.style.color, _fg);
          expect(editable.cursorColor, _fg);
        });
      }
    });
  });

  group('trigger fields restyle their button and accept a trailing icon', () {
    const icon = Icon(LucideIcons.star);
    const options = [BoFOption(value: 'a', label: Text('Alpha'))];
    final cases = <String, (List<Widget>, IconData?)>{
      'select': (
        [
          BoF.selectField<String>(
            options: options,
            trailingIcon: icon,
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            borderRadius: _radius,
          ),
          _form(
            BoFSelectField<String>(
              name: 's',
              label: const Text('S'),
              options: options,
              trailingIcon: icon,
              backgroundColor: _fill,
              borderColor: _borderColor,
              borderWidth: 3,
              borderRadius: _radius,
            ),
          ),
        ],
        null,
      ),
      'multi select': (
        [
          BoF.multiSelectField<String>(
            options: options,
            trailingIcon: icon,
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            borderRadius: _radius,
          ),
          _form(
            BoFMultiSelectField<String>(
              name: 'm',
              label: const Text('M'),
              options: options,
              trailingIcon: icon,
              backgroundColor: _fill,
              borderColor: _borderColor,
              borderWidth: 3,
              borderRadius: _radius,
            ),
          ),
        ],
        null,
      ),
      'date picker': (
        [
          BoF.datePickerField(
            trailingIcon: icon,
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            borderRadius: _radius,
          ),
          _form(
            BoFDatePickerField(
              name: 'd',
              label: const Text('D'),
              trailingIcon: icon,
              backgroundColor: _fill,
              borderColor: _borderColor,
              borderWidth: 3,
              borderRadius: _radius,
            ),
          ),
        ],
        LucideIcons.calendarDays,
      ),
      'time picker': (
        [
          BoF.timePickerField(
            trailingIcon: icon,
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            borderRadius: _radius,
          ),
          _form(
            BoFTimePickerField(
              name: 't',
              label: const Text('T'),
              trailingIcon: icon,
              backgroundColor: _fill,
              borderColor: _borderColor,
              borderWidth: 3,
              borderRadius: _radius,
            ),
          ),
        ],
        LucideIcons.clock,
      ),
      'duration picker': (
        [
          BoF.durationPickerField(
            trailingIcon: icon,
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            borderRadius: _radius,
          ),
          _form(
            BoFDurationPickerField(
              name: 'du',
              label: const Text('Du'),
              trailingIcon: icon,
              backgroundColor: _fill,
              borderColor: _borderColor,
              borderWidth: 3,
              borderRadius: _radius,
            ),
          ),
        ],
        LucideIcons.clock,
      ),
      'color': (
        [
          BoF.colorField(
            backgroundColor: _fill,
            borderColor: _borderColor,
            borderWidth: 3,
            borderRadius: _radius,
          ),
          _form(
            BoFColorField(
              name: 'co',
              label: const Text('Co'),
              backgroundColor: _fill,
              borderColor: _borderColor,
              borderWidth: 3,
              borderRadius: _radius,
            ),
          ),
        ],
        null,
      ),
    };
    cases.forEach((name, entry) {
      final (widgets, defaultIcon) = entry;
      for (final (index, widget) in widgets.indexed) {
        testWidgets('$name (${index == 0 ? 'standalone' : 'form'})', (
          tester,
        ) async {
          await _pump(tester, widget);
          final decoration = _buttonDecorations(
            tester,
          ).singleWhere((decoration) => decoration.color == _fill);
          expect(decoration.borderRadius, _radius);
          final border = decoration.border! as Border;
          expect(border.top.color, _borderColor);
          expect(border.top.width, 3);
          if (name != 'color') {
            expect(find.byIcon(LucideIcons.star), findsOneWidget);
          }
          if (defaultIcon != null) {
            expect(find.byIcon(defaultIcon), findsNothing);
          }
        });
      }
    });

    testWidgets('select chevron is unchanged without trailingIcon', (
      tester,
    ) async {
      await _pump(tester, BoF.selectField<String>(options: options));
      expect(find.byType(SelectExpandIcon), findsOneWidget);
    });

    testWidgets('picker trigger styling does not leak into its popover', (
      tester,
    ) async {
      await _pump(
        tester,
        BoF.datePickerField(
          backgroundColor: _fill,
          foregroundColor: _fg,
          borderColor: _borderColor,
        ),
      );
      bool filled(BoxDecoration decoration) => decoration.color == _fill;
      expect(_buttonDecorations(tester).where(filled), hasLength(1));
      await tester.tap(find.byType(OutlineButton).first);
      await tester.pumpAndSettle();
      // The calendar's own outline navigation buttons are open now.
      expect(find.byType(OutlineButton), findsAtLeastNWidgets(3));
      expect(_buttonDecorations(tester).where(filled), hasLength(1));
    });

    testWidgets('time picker still opens and reports a time', (tester) async {
      TimeOfDay? picked;
      await _pump(
        tester,
        BoF.timePickerField(
          initialValue: const TimeOfDay(hour: 9, minute: 30),
          onChanged: (value) => picked = value,
        ),
      );
      expect(find.byIcon(LucideIcons.clock), findsOneWidget);
      await tester.tap(find.byType(OutlineButton));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget);
      expect(picked, isNull);
    });
  });

  group('segmented inputs accept the shared surface options', () {
    final cases = <String, List<Widget>>{
      'date input': [
        BoF.dateInputField(
          trailingIcon: const Icon(LucideIcons.star),
          backgroundColor: _fill,
          foregroundColor: _fg,
          fontSize: 17,
          borderColor: _borderColor,
          borderRadius: _radius,
        ),
        _form(
          BoFDateInputField(
            name: 'd',
            label: const Text('D'),
            trailingIcon: const Icon(LucideIcons.star),
            backgroundColor: _fill,
            foregroundColor: _fg,
            fontSize: 17,
            borderColor: _borderColor,
            borderRadius: _radius,
          ),
        ),
      ],
      'time input': [
        BoF.timeInputField(
          backgroundColor: _fill,
          foregroundColor: _fg,
          fontSize: 17,
          borderColor: _borderColor,
          borderRadius: _radius,
        ),
        _form(
          BoFTimeInputField(
            name: 't',
            label: const Text('T'),
            backgroundColor: _fill,
            foregroundColor: _fg,
            fontSize: 17,
            borderColor: _borderColor,
            borderRadius: _radius,
          ),
        ),
      ],
      'duration input': [
        BoF.durationInputField(
          backgroundColor: _fill,
          foregroundColor: _fg,
          fontSize: 17,
          borderColor: _borderColor,
          borderRadius: _radius,
        ),
        _form(
          BoFDurationInputField(
            name: 'du',
            label: const Text('Du'),
            backgroundColor: _fill,
            foregroundColor: _fg,
            fontSize: 17,
            borderColor: _borderColor,
            borderRadius: _radius,
          ),
        ),
      ],
    };
    cases.forEach((name, widgets) {
      for (final (index, widget) in widgets.indexed) {
        testWidgets('$name (${index == 0 ? 'standalone' : 'form'})', (
          tester,
        ) async {
          await _pump(tester, widget);
          final fill = tester.widget<DecoratedBox>(_filled(_fill));
          expect((fill.decoration as BoxDecoration).borderRadius, _radius);
          expect(_bordered(_borderColor), findsWidgets);
          final editable = tester.widget<EditableText>(
            find.byType(EditableText).first,
          );
          expect(editable.style.color, _fg);
          expect(editable.style.fontSize, 17);
          if (name == 'date input') {
            expect(find.byIcon(LucideIcons.star), findsOneWidget);
            expect(find.byIcon(LucideIcons.calendarDays), findsNothing);
          }
        });
      }
    });
  });

  testWidgets('OTP cells take the shared surface options', (tester) async {
    await _pump(
      tester,
      _form(
        BoFOtpField(
          name: 'otp',
          label: const Text('Code'),
          length: 4,
          initialValue: const [49, null, null, null],
          backgroundColor: _fill,
          foregroundColor: _fg,
          fontSize: 21,
          borderColor: _borderColor,
        ),
      ),
    );
    expect(_filled(_fill), findsOneWidget);
    expect(_bordered(_borderColor), findsNWidgets(4));
    final digit = tester.widget<RichText>(
      find
          .descendant(
            of: find.byType(InputOTP),
            matching: find.byType(RichText),
          )
          .first,
    );
    final style = digit.text.style!;
    expect(style.color, _fg);
    expect(style.fontSize, 21);
  });

  testWidgets('phone field takes the shared surface options', (tester) async {
    await _pump(
      tester,
      _form(
        BoFPhoneField(
          name: 'phone',
          label: const Text('Phone'),
          backgroundColor: _fill,
          borderColor: _borderColor,
          borderWidth: 3,
        ),
      ),
    );
    final country = _buttonDecorations(
      tester,
    ).singleWhere((decoration) => decoration.color == _fill);
    expect((country.border! as Border).top.color, _borderColor);
    final number = tester.widget<DecoratedBox>(_filled(_fill));
    final border = (number.decoration as BoxDecoration).border! as Border;
    expect(border.top.color, _borderColor);
    expect(border.top.width, 3);
  });

  testWidgets('choice chips take border, weight and padding overrides', (
    tester,
  ) async {
    const options = [
      BoFOption(value: 'a', label: Text('A')),
      BoFOption(value: 'b', label: Text('B')),
    ];
    await _pump(
      tester,
      _form(
        BoFMultipleChoiceField<String>(
          name: 'c',
          label: const Text('C'),
          options: options,
          initialValue: 'a',
          selectedBackgroundColor: _fill,
          selectedBorderColor: _borderColor,
          selectedBorderWidth: 3,
          selectedFontWeight: FontWeight.w800,
          unselectedBorderColor: _fg,
          unselectedPadding: const EdgeInsets.all(20),
        ),
      ),
    );
    final decorations = _buttonDecorations(tester);
    final border = decorations.first.border! as Border;
    expect(decorations.first.color, _fill);
    expect(border.top.color, _borderColor);
    expect(border.top.width, 3);
    expect((decorations.last.border! as Border).top.color, _fg);
    final buttons = tester.widgetList<Button>(find.byType(Button)).toList();
    final context = tester.element(find.byType(Button).last);
    expect(
      buttons.first.style.textStyle(context, const {}).fontWeight,
      FontWeight.w800,
    );
    expect(
      buttons.last.style.padding(context, const {}),
      const EdgeInsets.all(20),
    );
  });

  testWidgets('star rating form spec forwards its appearance options', (
    tester,
  ) async {
    await _pump(
      tester,
      _form(
        BoFStarRatingField(
          name: 'r',
          label: const Text('R'),
          activeColor: _fill,
          backgroundColor: _fg,
          starSize: 30,
          starSpacing: 6,
        ),
      ),
    );
    final rating = tester.widget<ControlledStarRating>(
      find.byType(ControlledStarRating),
    );
    expect(rating.activeColor, _fill);
    expect(rating.backgroundColor, _fg);
    expect(rating.starSize, 30);
    expect(rating.starSpacing, 6);
  });
}
