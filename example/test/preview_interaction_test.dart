import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter/material.dart' as material show Icons;
import 'package:flutter_test/flutter_test.dart';

import 'package:example/docs/docs_shell.dart';

void main() {
  for (final id in [
    'checkbox-field',
    'switch-field',
    'radio-group-field',
    'slider-field',
    'star-rating-field',
    'text-field',
  ]) {
    testWidgets(
      '$id preview retains edits across scroll, theme, and code tabs',
      (tester) async {
        _setScreen(tester);
        final key = GlobalKey<_PreviewHarnessState>();
        await tester.pumpWidget(_PreviewHarness(key: key, id: id));
        await tester.pumpAndSettle();
        final preview = find.byKey(ValueKey(id));
        await _edit(tester, preview, id);
        final editedValue = _read(tester, preview, id);
        expect(editedValue, isNot(_initialValue(id)));

        await tester.drag(
          find.byKey(const ValueKey('documentation-scroll')),
          const Offset(0, -250),
        );
        await tester.pumpAndSettle();
        expect(_read(tester, preview, id), editedValue);
        await tester.drag(
          find.byKey(const ValueKey('documentation-scroll')),
          const Offset(0, 500),
        );
        await tester.pumpAndSettle();

        key.currentState!.toggleTheme();
        await tester.pumpAndSettle();
        expect(_read(tester, preview, id), editedValue);

        await tester.tap(
          find.descendant(of: preview, matching: find.text('Code')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: preview, matching: find.text('Preview')),
        );
        await tester.pumpAndSettle();
        expect(_read(tester, preview, id), editedValue);

        final reset = find.descendant(
          of: preview,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Icon && widget.icon == material.Icons.refresh_rounded,
          ),
        );
        await tester.tap(reset);
        await tester.pumpAndSettle();
        expect(_read(tester, preview, id), _initialValue(id));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'radio and choice previews switch and multiple answers deselect',
    (tester) async {
      _setScreen(tester);
      await tester.pumpWidget(const _PreviewHarness(id: 'radio-group-field'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Free'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<RadioGroup<String>>(find.byType(RadioGroup<String>))
            .value,
        'free',
      );
      await tester.tap(find.text('Pro'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<RadioGroup<String>>(find.byType(RadioGroup<String>))
            .value,
        'pro',
      );

      await tester.pumpWidget(
        const _PreviewHarness(id: 'multiple-choice-field'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('S'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();
      _expectChip(tester, 'S', false);
      _expectChip(tester, 'M', true);

      await tester.pumpWidget(
        const _PreviewHarness(id: 'multiple-answer-field'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('S'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('S'));
      await tester.pumpAndSettle();
      _expectChip(tester, 'S', false);
      _expectChip(tester, 'M', true);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'autocomplete preview accepts a suggestion and preserves the text',
    (tester) async {
      _setScreen(tester);
      await tester.pumpWidget(const _PreviewHarness(id: 'auto-complete-field'));
      await tester.pumpAndSettle();
      final input = find.descendant(
        of: find.byKey(const ValueKey('auto-complete-field')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(input, 'Al');
      // Open autocomplete popovers continuously track their anchor with a ticker.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('Alice').hitTestable());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.widget<EditableText>(input).controller.text, 'Alice');
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _edit(WidgetTester tester, Finder preview, String id) async {
  Finder component(Type type) =>
      find.descendant(of: preview, matching: find.byType(type));
  switch (id) {
    case 'checkbox-field':
      await tester.tap(component(Checkbox));
    case 'switch-field':
      await tester.tap(component(Switch));
    case 'radio-group-field':
      await tester.tap(
        find.descendant(of: preview, matching: find.text('Pro')),
      );
    case 'slider-field':
      final rect = tester.getRect(component(Slider));
      await tester.tapAt(Offset(rect.left + rect.width * 0.7, rect.center.dy));
    case 'star-rating-field':
      final rect = tester.getRect(component(StarRating));
      await tester.tapAt(Offset(rect.left + rect.width * 0.7, rect.center.dy));
    case 'text-field':
      await tester.enterText(component(EditableText).first, 'Friday');
  }
  await tester.pumpAndSettle();
}

Object? _read(WidgetTester tester, Finder preview, String id) {
  Finder component(Type type) =>
      find.descendant(of: preview, matching: find.byType(type));
  return switch (id) {
    'checkbox-field' => tester.widget<Checkbox>(component(Checkbox)).state,
    'switch-field' => tester.widget<Switch>(component(Switch)).value,
    'radio-group-field' =>
      tester.widget<RadioGroup<String>>(component(RadioGroup<String>)).value,
    'slider-field' => tester.widget<Slider>(component(Slider)).value.value,
    'star-rating-field' =>
      tester.widget<StarRating>(component(StarRating)).value,
    'text-field' =>
      tester
          .widget<EditableText>(component(EditableText).first)
          .controller
          .text,
    _ => throw ArgumentError(id),
  };
}

Object? _initialValue(String id) => switch (id) {
  'checkbox-field' => CheckboxState.unchecked,
  'switch-field' => false,
  'radio-group-field' => null,
  'slider-field' || 'star-rating-field' => 0.0,
  'text-field' => '',
  _ => throw ArgumentError(id),
};

void _expectChip(WidgetTester tester, String label, bool selected) {
  final button = find
      .ancestor(of: find.text(label), matching: find.byType(Button))
      .first;
  expect(
    tester.widget<Button>(button).style,
    selected ? ButtonVariance.primary : ButtonVariance.outline,
  );
}

void _setScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 1000);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

class _PreviewHarness extends StatefulWidget {
  const _PreviewHarness({super.key, required this.id});
  final String id;
  @override
  State<_PreviewHarness> createState() => _PreviewHarnessState();
}

class _PreviewHarnessState extends State<_PreviewHarness> {
  bool _dark = false;
  void toggleTheme() => setState(() => _dark = !_dark);
  @override
  Widget build(BuildContext context) => ShadcnApp(
    themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
    home: DocsShell(
      path: '/components/${widget.id}',
      isDark: _dark,
      onToggleTheme: toggleTheme,
      onNavigate: (_) {},
    ),
  );
}
