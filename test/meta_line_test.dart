import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

Widget _app(Widget child, {double width = 800}) {
  return ShadcnApp(
    home: Scaffold(
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

List<BoFMetaItem> _items({VoidCallback? onEmail}) => [
  BoFMetaItem(
    'jc@gmail.com',
    prefix: 'by ',
    highlighted: true,
    onPressed: onEmail,
  ),
  BoFMetaItem('September 30, 2026'),
  BoFMetaItem('12:49 PM'),
];

void main() {
  group('BoF.metaLine', () {
    testWidgets('joins entries with the default separator', (tester) async {
      await tester.pumpWidget(_app(BoF.metaLine(_items())));

      expect(find.text('by '), findsOneWidget);
      expect(find.text('jc@gmail.com'), findsOneWidget);
      expect(find.text('September 30, 2026'), findsOneWidget);
      expect(find.text('12:49 PM'), findsOneWidget);
      // One separator between each pair of entries, none after the last.
      expect(find.text('·'), findsNWidgets(2));
    });

    testWidgets('highlighted entries use the primary color', (tester) async {
      await tester.pumpWidget(_app(BoF.metaLine(_items())));
      final context = tester.element(find.text('jc@gmail.com'));
      final colors = Theme.of(context).colorScheme;

      final email = tester.widget<Text>(find.text('jc@gmail.com'));
      final date = tester.widget<Text>(find.text('September 30, 2026'));
      expect(email.style!.color, colors.primary);
      expect(date.style!.color, colors.mutedForeground);
    });

    testWidgets('highlightColor overrides the primary color', (tester) async {
      const red = Color(0xFFFF0000);
      await tester.pumpWidget(
        _app(BoF.metaLine(_items(), highlightColor: red)),
      );
      expect(tester.widget<Text>(find.text('jc@gmail.com')).style!.color, red);
    });

    testWidgets('onPressed fires for the tapped entry only', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(BoF.metaLine(_items(onEmail: () => taps++))),
      );

      await tester.tap(find.text('jc@gmail.com'));
      expect(taps, 1);
      await tester.tap(find.text('by '), warnIfMissed: false);
      await tester.tap(find.text('12:49 PM'), warnIfMissed: false);
      expect(taps, 1);
    });

    testWidgets('accepts a String separator', (tester) async {
      await tester.pumpWidget(_app(BoF.metaLine(_items(), separator: '|')));
      expect(find.text('|'), findsNWidgets(2));
      expect(find.text('·'), findsNothing);
    });

    testWidgets('accepts a Widget separator', (tester) async {
      await tester.pumpWidget(
        _app(BoF.metaLine(_items(), separator: const Icon(LucideIcons.dot))),
      );
      expect(find.byIcon(LucideIcons.dot), findsNWidgets(2));
      expect(find.text('·'), findsNothing);
    });

    test('rejects a separator that is neither a String nor a Widget', () {
      expect(
        () => BoF.metaLine(_items(), separator: 42),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('stays on one line when wide and wraps whole entries when '
        'narrow', (tester) async {
      await tester.pumpWidget(_app(BoF.metaLine(_items())));
      final emailTop = tester.getTopLeft(find.text('jc@gmail.com')).dy;
      expect(tester.getTopLeft(find.text('September 30, 2026')).dy, emailTop);
      expect(tester.getTopLeft(find.text('12:49 PM')).dy, emailTop);

      await tester.pumpWidget(_app(BoF.metaLine(_items()), width: 220));
      await tester.pump();
      expect(tester.takeException(), isNull);
      final narrowEmailTop = tester.getTopLeft(find.text('jc@gmail.com')).dy;
      final dateTop = tester.getTopLeft(find.text('September 30, 2026')).dy;
      expect(dateTop, greaterThan(narrowEmailTop));
      // The separator stays on the first line, after the email.
      final separatorTop = tester.getTopLeft(find.text('·').first).dy;
      expect(separatorTop, lessThan(dateTop));
    });
  });
}
