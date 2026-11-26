import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, Widget child) {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(ShadcnApp(home: Scaffold(child: Center(child: child))));
  }

  Finder cellOutlines() =>
      find.byWidgetPredicate((w) => w is FocusOutline && w.child is Container);

  List<BoxDecoration> getCellDecorations(WidgetTester tester) {
    return tester
        .widgetList<FocusOutline>(cellOutlines())
        .map((outline) => (outline.child as Container).decoration! as BoxDecoration)
        .toList();
  }

  testWidgets('compact mode has 0 gap and outer-only border radius', (
    tester,
  ) async {
    await pumpApp(tester, BoF.otpField(length: 4));

    final decorations = getCellDecorations(tester);
    expect(decorations, hasLength(4));

    final rects = List.generate(
      4,
      (i) => tester.getRect(cellOutlines().at(i)),
    );
    for (var i = 0; i < 3; i++) {
      expect(rects[i + 1].left, rects[i].right);
    }

    final context = tester.element(cellOutlines().first);
    final defaultRadius = Theme.of(context).radiusMd;
    final leftRadius = BorderRadius.only(
      topLeft: Radius.circular(defaultRadius),
      bottomLeft: Radius.circular(defaultRadius),
    );
    final rightRadius = BorderRadius.only(
      topRight: Radius.circular(defaultRadius),
      bottomRight: Radius.circular(defaultRadius),
    );

    expect(decorations[0].borderRadius, leftRadius);
    expect(decorations[1].borderRadius, BorderRadius.zero);
    expect(decorations[2].borderRadius, BorderRadius.zero);
    expect(decorations[3].borderRadius, rightRadius);
  });

  testWidgets('comfortable mode has default gap and full radius on every cell', (
    tester,
  ) async {
    await pumpApp(
      tester,
      BoF.otpField(length: 4, type: BoFOtpFieldType.comfortable),
    );

    final decorations = getCellDecorations(tester);
    expect(decorations, hasLength(4));

    final context = tester.element(cellOutlines().first);
    final theme = Theme.of(context);
    final expectedGap = 8 * theme.scaling;
    final expectedRadius = BorderRadius.circular(theme.radiusMd);

    final rects = List.generate(
      4,
      (i) => tester.getRect(cellOutlines().at(i)),
    );
    for (var i = 0; i < 3; i++) {
      expect(rects[i + 1].left - rects[i].right, moreOrLessEquals(expectedGap));
    }

    for (var i = 0; i < 4; i++) {
      expect(decorations[i].borderRadius, expectedRadius);
    }
  });

  testWidgets('explicit spacing overrides compact mode and rounds all cells', (
    tester,
  ) async {
    await pumpApp(
      tester,
      BoF.otpField(length: 4, type: BoFOtpFieldType.compact, spacing: 12),
    );

    final decorations = getCellDecorations(tester);
    final context = tester.element(cellOutlines().first);
    final expectedRadius = BorderRadius.circular(Theme.of(context).radiusMd);

    final rects = List.generate(
      4,
      (i) => tester.getRect(cellOutlines().at(i)),
    );
    for (var i = 0; i < 3; i++) {
      expect(rects[i + 1].left - rects[i].right, 12);
    }

    for (var i = 0; i < 4; i++) {
      expect(decorations[i].borderRadius, expectedRadius);
    }
  });

  testWidgets('custom borderRadius, borderColor, and height apply to every cell', (
    tester,
  ) async {
    const customRadius = BorderRadius.all(Radius.circular(10));
    const customColor = Color(0xFFFF0000);
    const customHeight = 48.0;

    await pumpApp(
      tester,
      BoF.otpField(
        length: 3,
        type: BoFOtpFieldType.comfortable,
        borderRadius: customRadius,
        borderColor: customColor,
        height: customHeight,
      ),
    );

    final decorations = getCellDecorations(tester);

    for (var i = 0; i < 3; i++) {
      expect(tester.getSize(cellOutlines().at(i)), const Size(48, 48));
      expect(decorations[i].borderRadius, customRadius);
      final border = decorations[i].border! as Border;
      expect(border.top.color, customColor);
      expect(border.right.color, customColor);
      expect(border.bottom.color, customColor);
      expect(border.left.color, customColor);
    }
  });

  testWidgets('typing advances focus, pasting fills cells, backspace clears and moves back', (
    tester,
  ) async {
    final changes = <List<int?>>[];

    await pumpApp(
      tester,
      BoF.otpField(length: 4, onChanged: (value) => changes.add(value)),
    );

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(4));

    await tester.tap(fields.at(0));
    await tester.pump();

    await tester.enterText(fields.at(0), '1');
    await tester.pump();

    expect(changes.last, ['1'.codeUnitAt(0), null, null, null]);
    expect(tester.widget<TextField>(fields.at(1)).focusNode!.hasFocus, isTrue);

    // Paste across multiple cells starting from cell 1.
    await tester.enterText(fields.at(1), '234');
    await tester.pump();

    expect(changes.last, [
      '1'.codeUnitAt(0),
      '2'.codeUnitAt(0),
      '3'.codeUnitAt(0),
      '4'.codeUnitAt(0),
    ]);

    // Focus cell 2 (non-empty): first backspace clears cell 2.
    await tester.tap(fields.at(2));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    expect(changes.last, [
      '1'.codeUnitAt(0),
      '2'.codeUnitAt(0),
      null,
      '4'.codeUnitAt(0),
    ]);
    expect(tester.widget<TextField>(fields.at(2)).focusNode!.hasFocus, isTrue);

    // Cell 2 is now empty: second backspace moves focus back to cell 1.
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    expect(tester.widget<TextField>(fields.at(1)).focusNode!.hasFocus, isTrue);

    // Arrow navigation moves right and left.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(tester.widget<TextField>(fields.at(2)).focusNode!.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(tester.widget<TextField>(fields.at(1)).focusNode!.hasFocus, isTrue);
  });

  testWidgets('BoFOtpField forwards type, spacing, height, borderRadius, borderColor', (
    tester,
  ) async {
    const customRadius = BorderRadius.all(Radius.circular(14));
    const customColor = Color(0xFF00AAFF);

    await pumpApp(
      tester,
      BoF.form([
        BoFOtpField(
          name: 'otp',
          label: BoF.text('Code'),
          length: 4,
          type: BoFOtpFieldType.comfortable,
          spacing: 16,
          height: 44,
          borderRadius: customRadius,
          borderColor: customColor,
        ),
      ]),
    );

    final decorations = getCellDecorations(tester);
    expect(decorations, hasLength(4));

    final rects = List.generate(
      4,
      (i) => tester.getRect(cellOutlines().at(i)),
    );
    for (var i = 0; i < 3; i++) {
      expect(rects[i + 1].left - rects[i].right, 16);
    }

    for (var i = 0; i < 4; i++) {
      expect(tester.getSize(cellOutlines().at(i)), const Size(44, 44));
      expect(decorations[i].borderRadius, customRadius);
      final border = decorations[i].border! as Border;
      expect(border.top.color, customColor);
    }
  });
}
