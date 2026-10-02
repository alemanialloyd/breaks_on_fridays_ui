import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart' as material show MaterialPage;
import 'package:flutter/semantics.dart' show SemanticsBinding, SemanticsHandle;

import 'docs/docs_shell.dart';

void main() => runApp(const GalleryApp());

/// The package example doubles as its browsable documentation.
class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  late final _DocsRouter _router = _DocsRouter(
    onToggleTheme: () => setState(() => _isDark = !_isDark),
    isDark: () => _isDark,
  );
  bool _isDark = false;
  late final SemanticsHandle _semantics;

  @override
  void initState() {
    super.initState();
    // Documentation should expose its text and controls to browser readers.
    _semantics = SemanticsBinding.instance.ensureSemantics();
  }

  @override
  void dispose() {
    _semantics.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShadcnApp.router(
    title: 'BoF Documentation',
    debugShowCheckedModeBanner: false,
    disableBrowserContextMenu: false,
    theme: ThemeData(colorScheme: ColorSchemes.lightZinc, radius: 0.6),
    darkTheme: ThemeData(colorScheme: ColorSchemes.darkZinc, radius: 0.6),
    themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
    routeInformationParser: const _DocsRouteParser(),
    routerDelegate: _router,
  );
}

class _DocsRouteParser extends RouteInformationParser<String> {
  const _DocsRouteParser();

  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(routeInformation.uri.path);

  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(uri: Uri.parse(configuration));
}

class _DocsRouter extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  _DocsRouter({required this.onToggleTheme, required this.isDark});

  final VoidCallback onToggleTheme;
  final bool Function() isDark;
  String _path = '/';

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String get currentConfiguration => _path;

  void _navigate(BuildContext context, String path) {
    if (path == _path) return;
    Router.navigate(context, () {
      _path = path;
      notifyListeners();
    });
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _path = configuration.isEmpty ? '/' : configuration;
  }

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: [
      material.MaterialPage<void>(
        key: const ValueKey('docs'),
        child: DocsShell(
          path: _path,
          isDark: isDark(),
          onToggleTheme: onToggleTheme,
          onNavigate: (path) => _navigate(context, path),
        ),
      ),
    ],
    onDidRemovePage: (_) {},
  );
}
