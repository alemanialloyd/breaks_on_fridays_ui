import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/docs/code_block.dart';
import 'package:example/docs/docs_catalog.dart';
import 'package:example/docs/docs_shell.dart';
import 'package:example/gallery_section.dart';
import 'package:example/main.dart';
import 'package:example/sections/core_section.dart';
import 'package:example/sections/display_section.dart';
import 'package:example/sections/form_fields_section.dart';

void main() {
  testWidgets('catalog documents every existing gallery component', (
    tester,
  ) async {
    late Set<String> galleryIds;
    await tester.pumpWidget(
      ShadcnApp(
        home: Builder(
          builder: (context) {
            final sections = <GallerySection>[
              const CoreSection().build(context) as GallerySection,
              const DisplaySection().build(context) as GallerySection,
              const FormFieldsSection().build(context) as GallerySection,
            ];
            galleryIds = {
              for (final section in sections)
                for (final entry in section.children.whereType<GalleryEntry>())
                  if (entry.title.startsWith('BoF.'))
                    _componentId(entry.title.substring(4)),
            };
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final ids = componentPages.map((page) => page.id).toList();
    expect(ids.toSet().length, ids.length, reason: 'Page ids must be unique.');
    expect(ids.toSet(), containsAll(galleryIds));
    for (final page in componentPages) {
      expect(page.title, isNotEmpty, reason: page.id);
      expect(page.description, isNotEmpty, reason: page.id);
      expect(page.code, contains('BoF.'), reason: page.id);
      expect(page.notes, isNotEmpty, reason: page.id);
      expect(page.parameters, isNotEmpty, reason: page.id);
      for (final parameter in page.parameters) {
        expect(parameter.name, isNotEmpty, reason: page.id);
        expect(parameter.type, isNotEmpty, reason: page.id);
        expect(parameter.description, isNotEmpty, reason: page.id);
      }
    }
  });

  testWidgets('every component resolves to a live preview', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final page in componentPages) {
      Widget? preview;
      await tester.pumpWidget(
        ShadcnApp(
          home: Scaffold(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Builder(
                builder: (context) {
                  preview = buildComponentPreview(context, page.id);
                  return preview!;
                },
              ),
            ),
          ),
        ),
      );
      // Some previews animate indefinitely, so use a finite frame advance.
      await tester.pump(const Duration(milliseconds: 100));
      final empty =
          preview is SizedBox &&
          (preview as SizedBox).width == 0 &&
          (preview as SizedBox).height == 0 &&
          (preview as SizedBox).child == null;
      expect(empty, isFalse, reason: page.id);
      expect(tester.takeException(), isNull, reason: page.id);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('every documentation page fits a mobile screen', (tester) async {
    _setScreen(tester, const Size(390, 844));
    final paths = [
      '/',
      '/installation',
      '/styling',
      '/form-guide',
      '/validators',
      '/conditional-styling',
      for (final page in componentPages) '/components/${page.id}',
    ];
    for (final path in paths) {
      await tester.pumpWidget(
        ShadcnApp(
          home: DocsShell(
            path: path,
            isDark: false,
            onToggleTheme: () {},
            onNavigate: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: path);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('compact phones fit the header and six-digit OTP preview', (
    tester,
  ) async {
    _setScreen(tester, const Size(320, 740));
    for (final path in ['/', '/installation', '/components/otp-field']) {
      await tester.pumpWidget(
        ShadcnApp(
          home: DocsShell(
            path: path,
            isDark: false,
            onToggleTheme: () {},
            onNavigate: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: path);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets('desktop navigation opens a component and toggles its theme', (
    tester,
  ) async {
    _setScreen(tester, const Size(1440, 1000));
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('BoF documentation'), findsOneWidget);

    await tester.tap(find.text('Components'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<DocsShell>(find.byType(DocsShell)).path,
      '/components/button',
    );
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Parameters'), findsNWidgets(2));

    await tester.tap(_semanticControl('Toggle theme'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ShadcnApp>(find.byType(ShadcnApp)).themeMode,
      ThemeMode.dark,
    );
    expect(
      tester.widget<DocsShell>(find.byType(DocsShell)).path,
      '/components/button',
    );
  });

  testWidgets('mobile navigation selects a page and closes the drawer', (
    tester,
  ) async {
    _setScreen(tester, const Size(390, 844));
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('Search docs...'), findsNothing);

    await tester.tap(_semanticControl('Open menu'));
    await tester.pumpAndSettle();
    expect(find.text('Search docs...'), findsOneWidget);
    await tester.tap(find.text('Installation').hitTestable());
    await tester.pumpAndSettle();
    expect(
      tester.widget<DocsShell>(find.byType(DocsShell)).path,
      '/installation',
    );
    expect(find.text('Search docs...'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a component URL opens its documentation directly', (
    tester,
  ) async {
    _setScreen(tester, const Size(390, 844));
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        '/components/text-field';
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    expect(
      tester.widget<DocsShell>(find.byType(DocsShell)).path,
      '/components/text-field',
    );
    expect(find.text('Text field'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search finds documented parameters and opens code examples', (
    tester,
  ) async {
    _setScreen(tester, const Size(1440, 1000));
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search docs...'));
    await tester.pumpAndSettle();

    final search = find.byType(TextField);
    await tester.enterText(search, 'no-such-component-xyz');
    await tester.pump();
    expect(find.text('No results found'), findsOneWidget);

    await tester.enterText(search, 'centerContent');
    await tester.pump();
    await tester.tap(find.text('Button  ·  Core'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<DocsShell>(find.byType(DocsShell)).path,
      '/components/button',
    );
    expect(find.text('Search documentation'), findsNothing);

    final preview = find.byKey(const ValueKey('button'));
    await tester.tap(find.descendant(of: preview, matching: find.text('Code')));
    await tester.pumpAndSettle();
    final example = find.descendant(
      of: preview,
      matching: find.byType(CodeBlock),
    );
    expect(example, findsOneWidget);
    expect(
      tester.widget<CodeBlock>(example).code,
      componentPages.firstWhere((page) => page.id == 'button').code,
    );
    expect(
      find.descendant(of: preview, matching: find.text('Save')),
      findsNothing,
    );

    await tester.tap(
      find.descendant(of: preview, matching: find.text('Preview')),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: preview, matching: find.text('Save')),
      findsOneWidget,
    );
  });

  testWidgets('copying an example preserves its full Dart source', (
    tester,
  ) async {
    const code = "BoF.button('Save', onPressed: () {});\n// Save changes.";
    String? copied;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copied = (call.arguments as Map)['text'] as String;
      }
      return null;
    });
    addTearDown(() {
      messenger.setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(
      const ShadcnApp(
        home: Scaffold(child: CodeBlock(code: code)),
      ),
    );
    await tester.tap(find.text('Copy code'));
    await tester.pump();
    expect(copied, code);
    expect(find.text('Copied'), findsOneWidget);

    // Disposing the code block must also cancel its feedback timer.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

String _componentId(String method) => method.replaceAllMapped(
  RegExp('[A-Z]'),
  (match) => '-${match.group(0)!.toLowerCase()}',
);

void _setScreen(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Finder _semanticControl(String label) => find.byWidgetPredicate(
  (widget) => widget is Semantics && widget.properties.label == label,
);
