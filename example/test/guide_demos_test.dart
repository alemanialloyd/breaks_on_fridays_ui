import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/docs/guide_demos.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1200);
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      ShadcnApp(
        home: Scaffold(child: SingleChildScrollView(child: child)),
      ),
    );
  }

  testWidgets('validators demo reports each rule', (tester) async {
    await pump(tester, const ValidatorsDemo());

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('This field cannot be empty'), findsNWidgets(2));
    expect(find.text('Must be at least 8 characters'), findsOneWidget);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(2), '123');
    await tester.enterText(fields.at(3), 'hello');
    await tester.enterText(fields.at(4), 'abcdefgh');
    await tester.pumpAndSettle();
    expect(find.text('Use a 5-digit ZIP code.'), findsOneWidget);
    expect(
      find.text('Enter a full URL, starting with https://'),
      findsOneWidget,
    );
    // Long enough now, so SafePasswordValidator's first rule shows.
    expect(find.text('Must be at least 8 characters'), findsNothing);
    expect(find.text('Must contain at least one digit'), findsOneWidget);

    await tester.enterText(fields.at(0), 'sam');
    await tester.enterText(fields.at(1), 'sam@example.com');
    await tester.enterText(fields.at(2), '12345');
    await tester.enterText(fields.at(3), 'https://example.com');
    await tester.enterText(fields.at(4), 'Abcdefg1!');
    await tester.tap(find.text('Submit'));
    await tester.pump();
    // The locked, empty field does not block submit.
    expect(find.text('All validators passed'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 10));
  });

  testWidgets('conditional demo restyles the title as switches change', (
    tester,
  ) async {
    await pump(tester, const ConditionalDemo());

    TextStyle titleStyle() =>
        DefaultTextStyle.of(tester.element(find.text('Team standup'))).style;

    final selectedWeight = titleStyle().fontWeight;
    expect(selectedWeight, FontWeight.w600);

    await tester.tap(find.byType(Switch).at(0)); // selected off → muted
    await tester.pumpAndSettle();
    expect(titleStyle().fontWeight, isNot(FontWeight.w600));
    final mutedColor = titleStyle().color;

    await tester.tap(find.byType(Switch).at(0)); // selected back on
    await tester.tap(find.byType(Switch).at(2)); // flagged on
    await tester.pumpAndSettle();
    expect(titleStyle().color, isNot(mutedColor));
    expect(titleStyle().fontWeight, FontWeight.w600);
  });
}
