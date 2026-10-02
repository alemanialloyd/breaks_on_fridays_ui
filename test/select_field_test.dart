import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';

const _options = [
  BoFOption(value: 'short', label: Text('Short')),
  BoFOption(value: 'long', label: Text('The longest available option')),
  BoFOption(value: 'disabled', label: Text('Unavailable'), enabled: false),
];

Widget _host(Widget child, {double width = 700, double textScale = 1}) =>
    ShadcnApp(
      home: Scaffold(
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: Center(
            child: SizedBox(
              width: width,
              child: Align(alignment: Alignment.topLeft, child: child),
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets(
    'constraint-dependent option labels are safe before and after selection',
    (tester) async {
      final controller = SelectController<String>();
      final options = [
        BoFOption(
          value: 'adaptive',
          label: LayoutBuilder(
            builder: (context, constraints) => const Text('Adaptive label'),
          ),
        ),
      ];
      await tester.pumpWidget(
        _host(
          BoF.selectField<String>(options: options, controller: controller),
          width: 180,
        ),
      );
      expect(find.text('Select an option'), findsOneWidget);
      expect(tester.takeException(), isNull);
      controller.value = 'adaptive';
      await tester.pumpAndSettle();
      expect(find.text('Adaptive label'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(Select<String>));
      await tester.pumpAndSettle();
      expect(find.text('Adaptive label'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );

  testWidgets('single select keeps its widest width and restores placeholder', (
    tester,
  ) async {
    const key = ValueKey('select');
    final controller = SelectController<String>();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        BoF.selectField<String>(
          key: key,
          options: _options,
          controller: controller,
          initialValue: 'short',
          placeholder: const Text('Choose a value'),
        ),
      ),
    );
    expect(find.text('Choose a value'), findsOneWidget);
    expect(find.text('The longest available option'), findsNothing);
    final emptyWidth = tester.getSize(find.byKey(key)).width;
    expect(emptyWidth, lessThan(700));

    controller.value = 'short';
    await tester.pumpAndSettle();
    expect(find.text('Short'), findsOneWidget);
    expect(tester.getSize(find.byKey(key)).width, emptyWidth);
    controller.value = 'long';
    await tester.pumpAndSettle();
    expect(find.text('The longest available option'), findsOneWidget);
    expect(tester.getSize(find.byKey(key)).width, emptyWidth);
    controller.value = null;
    await tester.pumpAndSettle();
    expect(find.text('Choose a value'), findsOneWidget);
    expect(tester.getSize(find.byKey(key)).width, emptyWidth);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('default placeholders render for missing and empty selections', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Column(
          children: [
            BoF.selectField<String>(options: _options),
            BoF.multiSelectField<String>(
              options: _options,
              initialValue: const [],
            ),
          ],
        ),
      ),
    );
    expect(find.text('Select an option'), findsOneWidget);
    expect(find.text('Select options'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'single select measures a longer placeholder as well as options',
    (tester) async {
      const key = ValueKey('select');
      final controller = SelectController<String>();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          BoF.selectField<String>(
            key: key,
            options: const [BoFOption(value: 'a', label: Text('A'))],
            controller: controller,
            placeholder: const Text('Select one of the available values'),
          ),
        ),
      );
      final width = tester.getSize(find.byKey(key)).width;
      controller.value = 'a';
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(key)).width, width);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'actual option taps update single selection without a controller',
    (tester) async {
      String? changed;
      await tester.pumpWidget(
        _host(
          BoF.selectField<String>(
            options: _options,
            onChanged: (value) => changed = value,
          ),
        ),
      );
      await tester.tap(find.byType(Select<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(SelectItemButton<String>, 'Short'));
      await tester.pumpAndSettle();
      expect(changed, 'short');
      expect(find.text('Short'), findsOneWidget);
      expect(find.text('Select an option'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'multi select taps and chip removal update values at stable width',
    (tester) async {
      const key = ValueKey('multi');
      final controller = MultiSelectController<String>();
      addTearDown(controller.dispose);
      Iterable<String>? changed;
      await tester.pumpWidget(
        _host(
          BoF.multiSelectField<String>(
            key: key,
            options: _options,
            controller: controller,
            placeholder: const Text('Choose several values'),
            onChanged: (value) => changed = value,
          ),
        ),
      );
      final initialSize = tester.getSize(find.byKey(key));
      await tester.tap(find.byType(Select<Iterable<String>>));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(SelectItemButton<String>, 'Short'));
      await tester.pumpAndSettle();
      expect(controller.value, ['short']);
      expect(changed, ['short']);
      await tester.tap(
        find.widgetWithText(
          SelectItemButton<String>,
          'The longest available option',
        ),
      );
      await tester.pumpAndSettle();
      expect(controller.value, ['short', 'long']);
      expect(tester.getSize(find.byKey(key)).width, initialSize.width);
      expect(
        tester.getSize(find.byKey(key)).height,
        greaterThan(initialSize.height),
      );

      // Close the popup before using the removable chips in the trigger.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(SelectPopup), findsNothing);
      await tester.tap(find.byType(ChipButton).first);
      await tester.pumpAndSettle();
      expect(controller.value, ['long']);
      await tester.tap(find.byType(ChipButton).first);
      await tester.pumpAndSettle();
      expect(controller.value, isEmpty);
      expect(find.text('Choose several values'), findsOneWidget);
      expect(tester.getSize(find.byKey(key)).width, initialSize.width);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('custom labels, larger text and narrow parents avoid overflow', (
    tester,
  ) async {
    const key = ValueKey('select');
    const complexOptions = [
      BoFOption(
        value: 'wide',
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 80, height: 20),
            Icon(LucideIcons.star),
            Expanded(child: Text('A wide custom label')),
          ],
        ),
      ),
      BoFOption(value: 'short', label: Text('Short')),
    ];
    final controller = SelectController<String>('wide');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        BoF.selectField<String>(
          key: key,
          options: const [
            BoFOption(value: 'wide', label: Text('A wide custom label')),
          ],
          controller: controller,
        ),
      ),
    );
    final textOnlyWidth = tester.getSize(find.byKey(key)).width;
    await tester.pumpWidget(
      _host(
        BoF.selectField<String>(
          key: key,
          options: complexOptions,
          controller: controller,
        ),
      ),
    );
    final normalWidth = tester.getSize(find.byKey(key)).width;
    expect(normalWidth, greaterThan(textOnlyWidth + 80));
    await tester.pumpWidget(
      _host(
        BoF.selectField<String>(
          key: key,
          options: complexOptions,
          controller: controller,
        ),
        textScale: 1.5,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(key)).width, greaterThan(normalWidth));
    await tester.pumpWidget(
      _host(
        BoF.selectField<String>(
          key: key,
          options: complexOptions,
          controller: controller,
        ),
        width: 180,
        textScale: 1.5,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(key)).width, 180);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('long selected chips fit a narrow parent without overflow', (
    tester,
  ) async {
    const key = ValueKey('multi');
    await tester.pumpWidget(
      _host(
        BoF.multiSelectField<String>(
          key: key,
          options: _options,
          initialValue: const ['short', 'long'],
        ),
        width: 160,
        textScale: 1.5,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(key)).width, 160);
    expect(find.byType(MultiSelectChip), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('multi select preserves edits across equal list rebuilds', (
    tester,
  ) async {
    var seed = <String>['short'];
    late StateSetter rebuild;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return BoF.multiSelectField<String>(
              options: _options,
              initialValue: List<String>.of(seed),
            );
          },
        ),
      ),
    );
    await tester.tap(find.byType(Select<Iterable<String>>));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(
        SelectItemButton<String>,
        'The longest available option',
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    rebuild(() {});
    await tester.pumpAndSettle();
    expect(find.byType(MultiSelectChip), findsNWidgets(2));
    rebuild(() => seed = ['long']);
    await tester.pumpAndSettle();
    expect(find.byType(MultiSelectChip), findsOneWidget);
    expect(find.text('The longest available option'), findsOneWidget);
    rebuild(() => seed = []);
    await tester.pumpAndSettle();
    expect(find.text('Select options'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('measurement labels do not appear in accessibility output', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        BoF.selectField<String>(
          options: _options,
          placeholder: const Text('Choose a value'),
        ),
      ),
    );
    final output = tester
        .getSemantics(find.byType(Select<String>))
        .toStringDeep();
    expect(output, contains('Choose a value'));
    expect(output, isNot(contains('The longest available option')));
    expect(output, isNot(contains('Short')));
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets(
    'updated initial values and replacement controllers refresh fields',
    (tester) async {
      const key = ValueKey('select');
      Widget field({String? value, SelectController<String>? controller}) =>
          _host(
            BoF.selectField<String>(
              key: key,
              options: _options,
              initialValue: value,
              controller: controller,
            ),
          );
      await tester.pumpWidget(field(value: 'short'));
      await tester.pumpWidget(field(value: 'long'));
      await tester.pumpAndSettle();
      expect(find.text('The longest available option'), findsOneWidget);
      final first = SelectController<String>('short');
      final empty = SelectController<String>();
      addTearDown(first.dispose);
      addTearDown(empty.dispose);
      await tester.pumpWidget(field(value: 'long', controller: first));
      await tester.pumpAndSettle();
      expect(find.text('Short'), findsOneWidget);
      await tester.pumpWidget(field(value: 'long', controller: empty));
      await tester.pumpAndSettle();
      expect(find.text('Select an option'), findsOneWidget);
      first.value = 'long';
      await tester.pumpAndSettle();
      expect(find.text('Select an option'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      empty.value = 'short';
      expect(tester.takeException(), isNull);
    },
  );
}
