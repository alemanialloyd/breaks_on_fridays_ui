import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const accordionKey = ValueKey('accordion');
  const items = [
    BoFAccordionItem(title: Text('First'), content: Text('First body')),
    BoFAccordionItem(title: Text('Last'), content: Text('Last body')),
  ];

  Future<double> accordionHeight(
    WidgetTester tester,
    double? dividerHeight,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Center(
            child: BoF.accordion(
              key: accordionKey,
              items: items,
              dividerHeight: dividerHeight,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.getSize(find.byKey(accordionKey)).height;
  }

  testWidgets('zero accordion divider removes separators and bottom line', (
    tester,
  ) async {
    final defaultHeight = await accordionHeight(tester, null);
    final scaling = Theme.of(tester.element(find.byKey(accordionKey))).scaling;
    final borderlessHeight = await accordionHeight(tester, 0);

    expect(defaultHeight - borderlessHeight, closeTo(scaling + 1, 0.01));
    expect(
      find.descendant(
        of: find.byKey(accordionKey),
        matching: find.byType(Divider),
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('explicit accordion divider height sizes the bottom line too', (
    tester,
  ) async {
    final borderlessHeight = await accordionHeight(tester, 0);
    final heightWithDividers = await accordionHeight(tester, 3);

    expect(heightWithDividers - borderlessHeight, closeTo(6, 0.01));
    expect(tester.getSize(find.byType(Divider)).height, 3);
    final painters = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
    final divider = painters.singleWhere(
      (paint) => paint.painter is DividerPainter,
    );
    expect((divider.painter! as DividerPainter).thickness, 3);
  });

  testWidgets('borderless accordion preserves custom borders and dividers', (
    tester,
  ) async {
    const nestedDividerKey = ValueKey('nested-divider');
    const customBorder = Border(
      bottom: BorderSide(color: Color(0xFF123456), width: 4),
    );
    const decoration = BoxDecoration(border: customBorder);

    await tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(
          child: Center(
            child: BoF.accordion(
              dividerHeight: 0,
              items: [
                BoFAccordionItem(
                  title: const Text('Custom header'),
                  expanded: true,
                  headerDecoration: decoration,
                  contentDecoration: decoration,
                  content: const Divider(key: nestedDividerKey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration == decoration,
      ),
      findsNWidgets(2),
    );
    expect(tester.getSize(find.byKey(nestedDividerKey)).height, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('borderless accordion still expands only one item at a time', (
    tester,
  ) async {
    await accordionHeight(tester, 0);
    await tester.tap(find.text('First'));
    await tester.pumpAndSettle();
    var transitions = tester.widgetList<SizeTransition>(
      find.byType(SizeTransition),
    );
    expect(transitions.map((item) => item.sizeFactor.value), [1, 0]);

    await tester.tap(find.text('Last'));
    await tester.pumpAndSettle();
    transitions = tester.widgetList<SizeTransition>(
      find.byType(SizeTransition),
    );
    expect(transitions.map((item) => item.sizeFactor.value), [0, 1]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'BoF h2 preserves typography, spacing and chaining without border',
    (tester) async {
      const headingKey = ValueKey('bof-heading');
      const nativeHeadingKey = ValueKey('native-heading');
      const headingStyle = TextStyle(fontSize: 32, fontWeight: FontWeight.w600);
      final Text plainText = BoF.text(
        'Body',
        textAlign: TextAlign.center,
        maxLines: 2,
        semanticsLabel: 'Body label',
      );
      expect(plainText.textAlign, TextAlign.center);
      expect(plainText.maxLines, 2);
      expect(plainText.semanticsLabel, 'Body label');

      await tester.pumpWidget(
        ShadcnApp(
          theme: const ThemeData(
            colorScheme: ColorSchemes.lightZinc,
            typography: Typography.geist(h2: headingStyle),
          ),
          home: Scaffold(
            child: Column(
              children: [
                SizedBox(
                  key: headingKey,
                  child: BoF.text('BoF heading').h2.bold.italic,
                ),
                SizedBox(
                  key: nativeHeadingKey,
                  child: const Text('Native heading').h2,
                ),
              ],
            ),
          ),
        ),
      );

      final heading = find.byKey(headingKey);
      final richText = tester.widget<RichText>(
        find.descendant(of: heading, matching: find.byType(RichText)),
      );
      final theme = Theme.of(tester.element(heading));
      expect(richText.text.style!.fontSize, theme.typography.h2.fontSize);
      expect(richText.text.style!.fontWeight, headingStyle.fontWeight);
      expect(richText.text.style!.fontStyle, FontStyle.italic);
      final headingPadding = tester.widget<Padding>(
        find.descendant(of: heading, matching: find.byType(Padding)),
      );
      expect(headingPadding.padding, const EdgeInsets.only(top: 40, bottom: 8));
      final borderedContainer = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).border != null,
      );
      expect(
        find.descendant(of: heading, matching: borderedContainer),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byKey(nativeHeadingKey),
          matching: borderedContainer,
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
