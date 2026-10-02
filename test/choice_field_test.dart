import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _options = <BoFOption<String>>[
  BoFOption(value: 'a', label: Text('A')),
  BoFOption(value: 'b', label: Text('B')),
  BoFOption(value: 'disabled', label: Text('Disabled'), enabled: false),
];

void main() {
  testWidgets('single choice switches directly and can clear the selection', (
    tester,
  ) async {
    final changes = <String?>[];
    await _pump(
      tester,
      BoF.multipleChoiceField<String>(
        options: _options,
        onChanged: changes.add,
      ),
    );
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    _expectSelected(tester, 'A', true);
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    _expectSelected(tester, 'A', false);
    _expectSelected(tester, 'B', true);
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    _expectSelected(tester, 'B', false);
    expect(changes, ['a', 'b', null]);
  });

  testWidgets('disallowing unselection still permits switching choices', (
    tester,
  ) async {
    final changes = <String?>[];
    await _pump(
      tester,
      BoF.multipleChoiceField<String>(
        options: _options,
        initialValue: 'a',
        allowUnselect: false,
        onChanged: changes.add,
      ),
    );
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    _expectSelected(tester, 'A', true);
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(changes, ['b']);
    _expectSelected(tester, 'A', false);
    _expectSelected(tester, 'B', true);
  });

  testWidgets('choice controllers update the rendered and interactive value', (
    tester,
  ) async {
    final controller = MultipleChoiceController<String>('a');
    final changes = <String?>[];
    await _pump(
      tester,
      BoF.multipleChoiceField<String>(
        options: _options,
        initialValue: 'b',
        controller: controller,
        onChanged: changes.add,
      ),
    );
    _expectSelected(tester, 'A', true);
    controller.value = 'b';
    await tester.pumpAndSettle();
    _expectSelected(tester, 'A', false);
    _expectSelected(tester, 'B', true);
    expect(changes, isEmpty);
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    expect(controller.value, 'a');
    expect(changes, ['a']);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });

  testWidgets(
    'multiple answers toggle independently including the last answer',
    (tester) async {
      final controller = MultipleAnswerController<String>();
      final changes = <List<String>>[];
      await _pump(
        tester,
        BoF.multipleAnswerField<String>(
          options: _options,
          controller: controller,
          onChanged: (values) => changes.add(values?.toList() ?? []),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      _expectSelected(tester, 'A', true);
      _expectSelected(tester, 'B', true);
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      _expectSelected(tester, 'A', false);
      _expectSelected(tester, 'B', true);
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(controller.value, isEmpty);
      _expectSelected(tester, 'B', false);
      expect(changes, [
        ['a'],
        ['a', 'b'],
        ['b'],
        <String>[],
      ]);
      controller.value = ['a'];
      await tester.pumpAndSettle();
      _expectSelected(tester, 'A', true);
      expect(changes.length, 4);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    },
  );

  testWidgets('disabled options and disabled groups reject interaction', (
    tester,
  ) async {
    final changes = <String?>[];
    await _pump(
      tester,
      BoF.multipleChoiceField<String>(
        options: _options,
        onChanged: changes.add,
      ),
    );
    await tester.tap(find.text('Disabled'));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    _expectSelected(tester, 'Disabled', false);
    await _pump(
      tester,
      BoF.multipleChoiceField<String>(
        options: _options,
        enabled: false,
        onChanged: changes.add,
      ),
    );
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
  });

  testWidgets(
    'choice form fields report edits and respond to reset and setValue',
    (tester) async {
      final controller = BoFFormController();
      await _pump(
        tester,
        BoF.form([
          const BoFMultipleChoiceField<String>(
            name: 'size',
            label: Text('Size'),
            options: _options,
            initialValue: 'a',
          ),
          const BoFMultipleAnswerField<String>(
            name: 'extras',
            label: Text('Extras'),
            options: _options,
          ),
        ], controller: controller),
      );
      await tester.tap(find.text('B').first);
      await tester.pumpAndSettle();
      expect(controller.value<String>('size'), 'b');
      await tester.tap(find.text('A').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('A').last);
      await tester.pumpAndSettle();
      expect(controller.value<Iterable<String>>('extras'), isEmpty);
      controller.setValue('size', 'a');
      controller.setValue('extras', <String>['b']);
      await tester.pumpAndSettle();
      _expectSelected(tester, 'A', true, index: 0);
      _expectSelected(tester, 'B', true, index: 1);
      controller.reset();
      await tester.pumpAndSettle();
      _expectSelected(tester, 'A', true, index: 0);
      _expectSelected(tester, 'B', false, index: 1);
      expect(controller.value<String>('size'), 'a');
      expect(controller.value<Iterable<String>>('extras'), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    },
  );
}

Future<void> _pump(WidgetTester tester, Widget child) => tester.pumpWidget(
  ShadcnApp(
    home: Scaffold(child: Center(child: child)),
  ),
);

void _expectSelected(
  WidgetTester tester,
  String text,
  bool selected, {
  int index = 0,
}) {
  final button = find
      .ancestor(of: find.text(text).at(index), matching: find.byType(Button))
      .first;
  expect(
    tester.widget<Button>(button).style,
    selected ? ButtonVariance.primary : ButtonVariance.outline,
  );
}
