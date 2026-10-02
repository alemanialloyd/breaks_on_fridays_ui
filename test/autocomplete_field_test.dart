import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _suggestions = ['Alice Cooper', 'Bob', 'Charlie'];

void main() {
  testWidgets(
    'autocomplete filters, accepts, closes, and reopens suggestions',
    (tester) async {
      final changes = <String>[];
      await _pump(
        tester,
        BoF.autoCompleteField(
          suggestions: _suggestions,
          placeholder: const Text('Name'),
          onChanged: changes.add,
        ),
      );
      final input = find.byType(EditableText);
      await tester.tap(input);
      await _pumpOverlay(tester);
      expect(find.text('Alice Cooper'), findsNothing);
      await tester.enterText(input, 'AL');
      await _pumpOverlay(tester);
      expect(find.text('Alice Cooper'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
      expect(tester.widget<EditableText>(input).focusNode.hasFocus, isTrue);
      await tester.tap(find.text('Alice Cooper'));
      await _pumpOverlay(tester);
      expect(
        tester.widget<EditableText>(input).controller.text,
        'Alice Cooper',
      );
      expect(changes, ['AL', 'Alice Cooper']);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Alice Cooper',
        ),
        findsNothing,
      );
      await tester.enterText(input, 'bo');
      await _pumpOverlay(tester);
      expect(find.text('Bob'), findsOneWidget);
      await tester.enterText(input, 'unmatched');
      await _pumpOverlay(tester);
      expect(find.text('Bob'), findsNothing);
      await tester.enterText(input, '');
      await _pumpOverlay(tester);
      expect(find.text('Bob'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'autocomplete uses initial text and replaces complete multiword text',
    (tester) async {
      await _pump(
        tester,
        BoF.autoCompleteField(
          suggestions: _suggestions,
          initialValue: 'Alice ',
        ),
      );
      final input = find.byType(EditableText);
      expect(tester.widget<EditableText>(input).controller.text, 'Alice ');
      await tester.tap(input);
      await _pumpOverlay(tester);
      expect(find.text('Alice Cooper'), findsOneWidget);
      await tester.tap(find.text('Alice Cooper'));
      await _pumpOverlay(tester);
      expect(
        tester.widget<EditableText>(input).controller.text,
        'Alice Cooper',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'external controllers update suggestions and detach on replacement',
    (tester) async {
      final first = TextEditingController(text: 'Bo');
      final second = TextEditingController(text: 'char');
      final changes = <String>[];
      Widget field(TextEditingController? controller) => BoF.autoCompleteField(
        suggestions: _suggestions,
        initialValue: 'AL',
        controller: controller,
        onChanged: changes.add,
      );
      await _pump(tester, field(first));
      final input = find.byType(EditableText);
      expect(tester.widget<EditableText>(input).controller, same(first));
      await tester.tap(input);
      await _pumpOverlay(tester);
      expect(find.text('Bob'), findsOneWidget);
      first.text = 'AL';
      await _pumpOverlay(tester);
      expect(find.text('Alice Cooper'), findsOneWidget);
      await _pump(tester, field(second));
      await _pumpOverlay(tester);
      expect(tester.widget<EditableText>(input).controller, same(second));
      expect(tester.widget<EditableText>(input).controller.text, 'char');
      second.text = 'charl';
      await _pumpOverlay(tester);
      expect(find.text('Charlie'), findsOneWidget);
      first.text = 'detached';
      await _pumpOverlay(tester);
      expect(tester.widget<EditableText>(input).controller.text, 'charl');
      await _pump(tester, field(null));
      await _pumpOverlay(tester);
      expect(tester.widget<EditableText>(input).controller.text, 'charl');
      second.text = 'detached';
      await _pumpOverlay(tester);
      expect(tester.widget<EditableText>(input).controller.text, 'charl');
      await tester.pumpWidget(const SizedBox.shrink());
      first.text = 'external controller remains usable';
      second.text = 'external controller remains usable';
      first.dispose();
      second.dispose();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('disabled autocomplete suppresses suggestions and editing', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'AL');
    await _pump(
      tester,
      BoF.autoCompleteField(
        suggestions: _suggestions,
        controller: controller,
        enabled: false,
      ),
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).readOnly,
      isTrue,
    );
    expect(find.text('Alice Cooper'), findsNothing);
    controller.text = 'Bo';
    await _pumpOverlay(tester);
    expect(find.text('Bob'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets('autocomplete form reports accepted text and resets', (
    tester,
  ) async {
    final controller = BoFFormController();
    await _pump(
      tester,
      BoF.form([
        const BoFAutoCompleteField(
          name: 'name',
          label: Text('Name'),
          suggestions: _suggestions,
        ),
      ], controller: controller),
    );
    await tester.enterText(find.byType(EditableText), 'AL');
    await _pumpOverlay(tester);
    await tester.tap(find.text('Alice Cooper'));
    await _pumpOverlay(tester);
    expect(controller.value<String>('name'), 'Alice Cooper');
    controller.reset();
    await _pumpOverlay(tester);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      '',
    );
    expect(controller.value<String>('name'), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(WidgetTester tester, Widget field) => tester.pumpWidget(
  ShadcnApp(
    home: Scaffold(child: Center(child: field)),
  ),
);

Future<void> _pumpOverlay(WidgetTester tester) async {
  // Open autocomplete popovers continuously track their anchor with a ticker.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
}
