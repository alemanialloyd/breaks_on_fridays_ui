import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter/material.dart'
    as material
    show Icons, Dialog, showDialog;
import 'package:flutter/services.dart';

import 'code_block.dart';
import 'docs_catalog.dart';
import 'guide_demos.dart';
import 'package_version.dart';

const _guides = <(String, String, String)>[
  ('/', 'Welcome', 'Get started'),
  (
    '/installation',
    'Installation',
    'Install the package and create your first app',
  ),
  (
    '/styling',
    'Styling',
    'Themes, colors, typography, and component overrides',
  ),
  (
    '/form-guide',
    'Building forms',
    'Validation, controllers, and submitting values',
  ),
  (
    '/validators',
    'Validators',
    'Built-in and custom validation rules for text fields',
  ),
  (
    '/conditional-styling',
    'Conditional styling',
    'Apply modifiers with when, unless, and whenNotNull',
  ),
];

class DocsShell extends StatefulWidget {
  const DocsShell({
    super.key,
    required this.path,
    required this.isDark,
    required this.onToggleTheme,
    required this.onNavigate,
  });
  final String path;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final ValueChanged<String> onNavigate;

  @override
  State<DocsShell> createState() => _DocsShellState();
}

class _DocsShellState extends State<DocsShell> {
  final _scroll = ScrollController();
  final _anchors = <String, GlobalKey>{};
  bool _menuOpen = false;
  String? _activeSection;

  DocPage? get _component {
    for (final page in componentPages) {
      if (widget.path == '/components/${page.id}') return page;
    }
    return null;
  }

  bool get _isGuide => _guides.any((guide) => guide.$1 == widget.path);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_trackSection);
  }

  @override
  void didUpdateWidget(DocsShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _anchors.clear();
      _activeSection = null;
      _menuOpen = false;
      if (_scroll.hasClients) _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _trackSection() {
    String? active;
    for (final entry in _anchors.entries) {
      final render = entry.value.currentContext?.findRenderObject();
      if (render is RenderBox && render.localToGlobal(Offset.zero).dy < 180) {
        active = entry.key;
      }
    }
    active ??= _anchors.keys.firstOrNull;
    if (active != _activeSection && mounted) {
      setState(() => _activeSection = active);
    }
  }

  void _jumpTo(String title) {
    final target = _anchors[title]?.currentContext;
    if (target != null) {
      setState(() => _activeSection = title);
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        alignment: 0.03,
      );
    }
  }

  void _navigate(String path) {
    setState(() => _menuOpen = false);
    widget.onNavigate(path);
  }

  Future<void> _search() async {
    setState(() => _menuOpen = false);
    final path = await material.showDialog<String>(
      context: context,
      builder: (context) => const _SearchDialog(),
    );
    if (path != null && mounted) _navigate(path);
  }

  Future<void> _copyPage(
    String title,
    String description,
    List<_Section> sections,
  ) async {
    final page = _component;
    final text = page == null
        ? '# $title\n\n$description\n\n${sections.map((section) => '## ${section.title}\n\n${section.copyText}').join('\n\n')}'
        : '# ${page.title}\n\n${page.description}\n\n```dart\n${page.code}\n```\n\n${page.parameters.map((p) => '${p.name} (${p.type}): ${p.description}').join('\n')}\n\n${page.notes.join('\n')}';
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        BoF.toast(
          context,
          title: 'Page copied',
          message: 'Documentation copied as Markdown.',
        );
      }
    } catch (_) {
      if (mounted) {
        BoF.toast(
          context,
          title: 'Copy unavailable',
          message: 'Select the text to copy it manually.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _component;
    final title =
        page?.title ??
        switch (widget.path) {
          '/' => 'BoF documentation',
          '/installation' => 'Installation',
          '/styling' => 'Styling',
          '/form-guide' => 'Building forms',
          '/validators' => 'Validators',
          '/conditional-styling' => 'Conditional styling',
          _ => 'Page not found',
        };
    final description =
        page?.description ??
        switch (widget.path) {
          '/' =>
            'Build consistent Flutter interfaces with thoughtful defaults and a single BoF entry point.',
          '/installation' =>
            'From a fresh project to your first BoF component in just a few steps.',
          '/styling' =>
            'Start with a shared theme. Fine-tune individual components when you need to.',
          '/form-guide' =>
            'Compose fields, validate input, and work with typed values using one controller.',
          '/validators' =>
            'Check text field input with built-in rules, combine them, or write your own.',
          '/conditional-styling' =>
            'Apply a modifier or wrapper only when a condition holds, without leaving the chain.',
          _ =>
            'This documentation page does not exist. Browse the sidebar or search for a component.',
        };
    final sections = page != null ? _componentSections(page) : _guideSections();
    for (final section in sections) {
      _anchors.putIfAbsent(section.title, () => GlobalKey());
    }
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): _search,
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _search,
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            setState(() => _menuOpen = false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;
              final outline = constraints.maxWidth >= 1180;
              return Stack(
                children: [
                  Row(
                    children: [
                      if (desktop) SizedBox(width: 252, child: _sidebar()),
                      Expanded(
                        child: Column(
                          children: [
                            _topbar(desktop),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      key: const ValueKey(
                                        'documentation-scroll',
                                      ),
                                      controller: _scroll,
                                      padding: EdgeInsets.fromLTRB(
                                        desktop ? 48 : 24,
                                        desktop ? 48 : 32,
                                        desktop ? 48 : 24,
                                        32,
                                      ),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 740,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              _paragraph(
                                                page?.group ??
                                                    (_isGuide
                                                        ? 'Get started'
                                                        : 'Documentation'),
                                                size: 13,
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Semantics(
                                                      header: true,
                                                      child: Text(
                                                        title,
                                                        style: TextStyle(
                                                          fontSize: desktop
                                                              ? 36
                                                              : 30,
                                                          height: 1.2,
                                                          letterSpacing: -1.15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (desktop) ...[
                                                    const SizedBox(width: 20),
                                                    BoF.button(
                                                      'Copy page',
                                                      type:
                                                          BoFButtonType.outline,
                                                      size: ButtonSize.small,
                                                      icon: const Icon(
                                                        material
                                                            .Icons
                                                            .content_copy_outlined,
                                                        size: 14,
                                                      ),
                                                      onPressed: () =>
                                                          _copyPage(
                                                            title,
                                                            description,
                                                            sections,
                                                          ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              _paragraph(description, size: 16),
                                              if (!desktop) ...[
                                                const SizedBox(height: 16),
                                                Wrap(
                                                  spacing: 12,
                                                  children: [
                                                    BoF.button(
                                                      'Copy page',
                                                      type:
                                                          BoFButtonType.outline,
                                                      size: ButtonSize.small,
                                                      icon: const Icon(
                                                        material
                                                            .Icons
                                                            .content_copy_outlined,
                                                        size: 14,
                                                      ),
                                                      onPressed: () =>
                                                          _copyPage(
                                                            title,
                                                            description,
                                                            sections,
                                                          ),
                                                    ),
                                                    if (sections.isNotEmpty)
                                                      BoF.button(
                                                        'On this page',
                                                        type:
                                                            BoFButtonType.ghost,
                                                        size: ButtonSize.small,
                                                        icon: const Icon(
                                                          material
                                                              .Icons
                                                              .toc_rounded,
                                                          size: 16,
                                                        ),
                                                        onPressed: () =>
                                                            _showOutline(
                                                              sections,
                                                            ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                              const SizedBox(height: 36),
                                              for (final section in sections)
                                                Padding(
                                                  key: _anchors[section.title],
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 40,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Semantics(
                                                        header: true,
                                                        child: Text(
                                                          section.title,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 22,
                                                                height: 1.35,
                                                                letterSpacing:
                                                                    -0.4,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 18,
                                                      ),
                                                      section.child,
                                                    ],
                                                  ),
                                                ),
                                              _pagination(),
                                              const SizedBox(height: 28),
                                              _paragraph(
                                                'Built with breaks_on_fridays_ui and shadcn_flutter.',
                                                size: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (outline && sections.isNotEmpty)
                                    SizedBox(
                                      width: 190,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          50,
                                          24,
                                          24,
                                        ),
                                        child: _outline(sections),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_menuOpen && !desktop) ...[
                    Positioned.fill(
                      child: Semantics(
                        label: 'Close navigation',
                        button: true,
                        child: GestureDetector(
                          onTap: () => setState(() => _menuOpen = false),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: constraints.maxWidth < 350
                          ? constraints.maxWidth - 32
                          : 310,
                      child: _sidebar(mobile: true),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _paragraph(String text, {double size = 15}) => Text(
    text,
    style: TextStyle(
      fontSize: size,
      height: 1.75,
      color: Theme.of(context).colorScheme.mutedForeground,
    ),
  );

  Widget _demoFrame(Widget child) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).colorScheme.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );

  Widget _sidebar({bool mobile = false}) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 18, 24),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigate('/'),
                      child: Semantics(
                        button: true,
                        label: 'BoF home',
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: colors.foreground,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'b/f',
                                style: TextStyle(
                                  color: colors.background,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'BoF',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.6,
                                  ),
                                ),
                                _paragraph('Documentation', size: 11),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _iconButton(
                    widget.isDark
                        ? material.Icons.light_mode_outlined
                        : material.Icons.dark_mode_outlined,
                    'Toggle theme',
                    widget.onToggleTheme,
                  ),
                  if (mobile)
                    _iconButton(
                      material.Icons.close_rounded,
                      'Close menu',
                      () => setState(() => _menuOpen = false),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BoF.button(
                'Search docs...',
                type: BoFButtonType.outline,
                alignment: Alignment.centerLeft,
                fontSize: 13,
                foregroundColor: colors.mutedForeground,
                icon: const Icon(material.Icons.search_rounded, size: 17),
                onPressed: _search,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _navHeading('Get started'),
                    for (final guide in _guides) _navItem(guide.$2, guide.$1),
                    for (final group in [
                      'Core',
                      'Display & layout',
                      'Forms',
                    ]) ...[
                      const SizedBox(height: 24),
                      _navHeading(group),
                      for (final page in componentPages.where(
                        (page) => page.group == group,
                      ))
                        _navItem(page.title, '/components/${page.id}'),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.border)),
              ),
              child: Row(
                children: [
                  Expanded(child: _paragraph('breaks_on_fridays_ui', size: 11)),
                  BoF.badge(
                    BoF.text(packageVersion),
                    type: BoFBadgeType.outline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navHeading(String title) => Padding(
    padding: const EdgeInsets.only(left: 12, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    ),
  );

  Widget _navItem(String title, String path) {
    final colors = Theme.of(context).colorScheme;
    final selected = widget.path == path;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: selected
                  ? colors.foreground
                  : colors.border.withValues(alpha: 0.5),
              width: selected ? 2 : 1,
            ),
          ),
        ),
        child: Semantics(
          selected: selected,
          child: BoF.button(
            title,
            type: BoFButtonType.ghost,
            alignment: Alignment.centerLeft,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            foregroundColor: selected
                ? colors.foreground
                : colors.mutedForeground,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            borderRadius: BorderRadius.circular(5),
            onPressed: () => _navigate(path),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, String label, VoidCallback onPressed) =>
      Tooltip(
        tooltip: (_) => Text(label),
        child: Semantics(
          label: label,
          button: true,
          child: BoF.button(
            null,
            icon: Icon(icon, size: 18),
            type: BoFButtonType.ghost,
            onPressed: onPressed,
          ),
        ),
      );

  Widget _topbar(bool desktop) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: desktop ? 48 : 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          if (!desktop) ...[
            _iconButton(
              material.Icons.menu_rounded,
              'Open menu',
              () => setState(() => _menuOpen = true),
            ),
            const SizedBox(width: 12),
          ],
          _topTab('Guide', _isGuide, '/'),
          const SizedBox(width: 24),
          _topTab('Components', _component != null, '/components/button'),
          const Spacer(),
          if (desktop) _paragraph('Flutter, with less friction.', size: 12),
          if (!desktop) ...[
            _iconButton(
              material.Icons.search_rounded,
              'Search documentation',
              _search,
            ),
            _iconButton(
              widget.isDark
                  ? material.Icons.light_mode_outlined
                  : material.Icons.dark_mode_outlined,
              'Toggle theme',
              widget.onToggleTheme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _topTab(String title, bool active, String path) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: active ? colors.foreground : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      child: BoF.button(
        title,
        type: BoFButtonType.ghost,
        fontSize: 13,
        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        foregroundColor: active ? colors.foreground : colors.mutedForeground,
        padding: EdgeInsets.zero,
        onPressed: () => _navigate(path),
      ),
    );
  }

  Widget _outline(List<_Section> sections) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Row(
        children: [
          Icon(material.Icons.toc_rounded, size: 15),
          SizedBox(width: 8),
          Text(
            'On this page',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      const SizedBox(height: 16),
      for (final section in sections)
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: (_activeSection ?? sections.first.title) == section.title
                    ? Theme.of(context).colorScheme.foreground
                    : Theme.of(context).colorScheme.border,
              ),
            ),
          ),
          child: BoF.button(
            section.title,
            type: BoFButtonType.ghost,
            alignment: Alignment.centerLeft,
            fontSize: 12,
            foregroundColor:
                (_activeSection ?? sections.first.title) == section.title
                ? Theme.of(context).colorScheme.foreground
                : Theme.of(context).colorScheme.mutedForeground,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onPressed: () => _jumpTo(section.title),
          ),
        ),
    ],
  );

  Future<void> _showOutline(List<_Section> sections) async {
    final title = await material.showDialog<String>(
      context: context,
      builder: (context) => material.Dialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'On this page',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              for (final section in sections)
                BoF.button(
                  section.title,
                  type: BoFButtonType.ghost,
                  alignment: Alignment.centerLeft,
                  onPressed: () => Navigator.pop(context, section.title),
                ),
            ],
          ),
        ),
      ),
    );
    if (title != null && mounted) _jumpTo(title);
  }

  List<_Section> _componentSections(DocPage page) => [
    _Section(
      'Preview',
      _ComponentPreview(key: ValueKey(page.id), page: page),
      'Try the live ${page.title.toLowerCase()} preview.',
    ),
    _Section(
      'Usage',
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _paragraph(
            'Import the package once, then use this example inside a ShadcnApp. The preview above is interactive.',
          ),
          const SizedBox(height: 16),
          CodeBlock(code: page.code),
        ],
      ),
      'Import package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart inside an app wrapped in ShadcnApp.\n\n```dart\n${page.code}\n```',
    ),
    _Section(
      'Parameters',
      _parameters(page.parameters),
      page.parameters
          .map((p) => '${p.name} (${p.type}): ${p.description}')
          .join('\n'),
    ),
    _Section(
      'Notes',
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final note in page.notes)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: Icon(
                      material.Icons.circle,
                      size: 4,
                      color: Theme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _paragraph(note)),
                ],
              ),
            ),
          if (page.notes.isEmpty)
            _paragraph(
              'Uses your app theme by default. Explore the Styling guide to customize its appearance.',
            ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: BoF.button(
              'Styling guide',
              type: BoFButtonType.outline,
              icon: const Icon(material.Icons.arrow_forward_rounded, size: 15),
              iconPosition: BoFIconPosition.right,
              onPressed: () => _navigate('/styling'),
            ),
          ),
        ],
      ),
      page.notes.join('\n'),
    ),
  ];

  Widget _parameters(List<DocParameter> parameters) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < parameters.length; i++)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: i == 0
                    ? null
                    : Border(top: BorderSide(color: colors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        parameters[i].name,
                        style: Theme.of(context).typography.mono.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        parameters[i].type,
                        style: Theme.of(context).typography.mono.copyWith(
                          fontSize: 12,
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _paragraph(parameters[i].description, size: 13),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<_Section> _guideSections() => switch (widget.path) {
    '/' => [
      _Section(
        'Get started',
        _cards([
          (
            'Installation',
            'Add the package and build your first interface.',
            material.Icons.terminal_rounded,
            '/installation',
          ),
          (
            'Styling',
            'Make it yours with themes and local overrides.',
            material.Icons.tune_rounded,
            '/styling',
          ),
        ]),
        'Install with flutter pub add breaks_on_fridays_ui. Wrap your app in ShadcnApp. See /installation and /styling.',
      ),
      _Section(
        'Explore components',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Live previews, practical Dart examples, and the options you need. All in one place.',
            ),
            const SizedBox(height: 20),
            _cards([
              (
                'Core',
                'Text, buttons, containers, and dialogs.',
                material.Icons.widgets_outlined,
                '/components/button',
              ),
              (
                'Display & layout',
                'Cards, feedback, overlays, and more.',
                material.Icons.dashboard_outlined,
                '/components/card',
              ),
              (
                'Forms',
                'Typed fields, validation, and controllers.',
                material.Icons.edit_note_rounded,
                '/form-guide',
              ),
            ]),
          ],
        ),
        'Browse Core, Display & layout, and Forms for 43 documented component APIs.',
      ),
      _Section(
        'One entry point',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'BoF is a thin, opinionated layer on shadcn_flutter. It keeps familiar Flutter patterns and brings common UI tasks behind one concise API.',
            ),
            const SizedBox(height: 20),
            const CodeBlock(
              code:
                  "import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';\n\nBoF.text('Hello, Friday.').h2\nBoF.button('Get started', onPressed: () {})",
            ),
            const SizedBox(height: 20),
            _paragraph(
              'The package re-exports shadcn_flutter, so its themes, layout primitives, and typography helpers are available from the same import.',
            ),
          ],
        ),
        "import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';\n\nBoF.text('Hello, Friday.').h2\nBoF.button('Get started', onPressed: () {})\n\nshadcn_flutter is re-exported through the package.",
      ),
    ],
    '/installation' => [
      _Section(
        'Install the package',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Run this from your Flutter project directory. Pub will add the dependency to your pubspec.yaml.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(
              code: 'flutter pub add breaks_on_fridays_ui',
              language: 'Terminal',
            ),
            const SizedBox(height: 16),
            _paragraph(
              'The current package requires Dart 3.12.2 or newer. Use a Flutter SDK that includes a compatible Dart version.',
            ),
          ],
        ),
        'Requires Dart >=3.12.2.\n\n```sh\nflutter pub add breaks_on_fridays_ui\n```',
      ),
      _Section(
        'Create your app',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Import BoF and wrap your app in ShadcnApp. This provides the theme and overlay services used by the components.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _appExample),
          ],
        ),
        'Wrap the app in ShadcnApp.\n\n```dart\n$_appExample\n```',
      ),
      _Section(
        'Try a component',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Choose a component in the sidebar. Each page includes a live preview, copyable code, common parameters, and implementation notes.',
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: BoF.button(
                'Explore buttons',
                type: BoFButtonType.outline,
                icon: const Icon(
                  material.Icons.arrow_forward_rounded,
                  size: 16,
                ),
                iconPosition: BoFIconPosition.right,
                onPressed: () => _navigate('/components/button'),
              ),
            ),
          ],
        ),
        'Browse /components/button for a live preview and copyable Dart examples.',
      ),
    ],
    '/styling' => [
      _Section(
        'Set a shared theme',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Define colors and radius at the app level. All BoF components inherit these defaults, including the live previews in this documentation.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _themeExample),
          ],
        ),
        'Use ThemeData and ColorSchemes on ShadcnApp.\n\n```dart\n$_themeExample\n```',
      ),
      _Section(
        'Override a component',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Most components expose colors, font size, and corner radius directly. Overrides apply to that component while unspecified properties continue to use the theme.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _styleExample),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: BoF.button(
                  'Make it yours',
                  onPressed: () {},
                  backgroundColor: const Color(0xFF6E56CF),
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        'Local overrides retain theme defaults for unspecified properties.\n\n```dart\n$_styleExample\n```',
      ),
      _Section(
        'Style input fields',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'The standalone text field and BoFTextField form specification share the same appearance options. A backgroundColor enables a fill while preserving the inherited border and corner radius.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _inputStyleExample),
          ],
        ),
        'Text field styles also apply to BoFTextField in forms.\n\n```dart\n$_inputStyleExample\n```',
      ),
      _Section(
        'Styling limitations',
        _paragraph(
          'Some upstream inputs do not expose a styling surface: color, phone, segmented date/time/duration inputs, and OTP cell colors. Use the picker counterpart when custom appearance matters. A text field decoration replaces its whole surface, so prefer individual style options when you want to retain theme behavior.',
        ),
        'Color, phone, segmented date/time/duration inputs and OTP cell colors have limited upstream styling. Prefer picker counterparts when styling matters. TextField decoration replaces the whole surface.',
      ),
    ],
    '/form-guide' => [
      _Section(
        'Compose your fields',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Every form field has a unique name, a label, and an optional hint or validator. The name becomes its key in the submitted values map.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _formExample),
          ],
        ),
        'Each field requires name and label.\n\n```dart\n$_formExample\n```',
      ),
      _Section(
        'Validate and submit',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Call controller.submit() to validate the fields. onSubmit runs only when validation passes. Try submitting with an empty date in the live form below.',
            ),
            const SizedBox(height: 20),
            _ComponentPreview(
              page: componentPages.firstWhere((page) => page.id == 'form'),
            ),
          ],
        ),
        'await controller.submit() validates fields and invokes onSubmit only when valid. Check controller.isValid and controller.errorOf(name).',
      ),
      _Section(
        'Work with values',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Read a typed value, prefill a field, or reset the whole form. setValue updates the rendered field as well as the controller.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(
              code:
                  "final email = controller.value<String>('email');\nfinal allValues = controller.values;\n\ncontroller.setValue('email', 'hello@example.com');\ncontroller.reset();",
            ),
          ],
        ),
        "controller.value<String>('email'); controller.values; controller.setValue('email', 'hello@example.com'); controller.reset();",
      ),
      _Section(
        'Controller lifecycle',
        _paragraph(
          'Create your BoFFormController once in State, and dispose it when the screen is removed. Keep it outside build so rebuilding the UI does not replace field values or validation state.',
        ),
        'Create the BoFFormController once in State; call controller.dispose() in dispose().',
      ),
    ],
    '/validators' => [
      _Section(
        'Add a validator',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Every field spec takes a validator. Validators are shadcn_flutter\'s Validator<T>, re-exported by this package, so a BoFTextField takes a Validator<String>. A validator returns null when the value is fine, or an InvalidResult whose message is shown under the field.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _validatorExample),
          ],
        ),
        'Pass validator: to any field spec.\n\n```dart\n$_validatorExample\n```',
      ),
      _Section(
        'Built-in text validators',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'These work on BoFTextField, BoFTextAreaField and BoFAutoCompleteField. Every one accepts an optional message: to replace its default error text.',
            ),
            const SizedBox(height: 16),
            _parameters(_textValidators),
          ],
        ),
        _textValidators
            .map((v) => '${v.name} (${v.type}): ${v.description}')
            .join('\n'),
      ),
      _Section(
        'Combine validators',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Use & to require every rule, checked in order so the first failure is the message shown. Use ~ (or unary -) to invert a rule.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _combineExample),
            const SizedBox(height: 16),
            BoF.alert(
              leading: const Icon(material.Icons.warning_amber_rounded),
              title: const Text('Avoid | for now'),
              content: const Text(
                'In shadcn_flutter 0.0.53–0.0.55, an OR of validators passes even when every rule fails. Write the "either" rule as one ConditionalValidator instead.',
              ),
              destructive: true,
            ),
          ],
        ),
        'Combine with & (all must pass) and ~ (invert). Avoid | in shadcn_flutter 0.0.53–0.0.55: it passes even when every rule fails.\n\n```dart\n$_combineExample\n```',
      ),
      _Section(
        'Write your own',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'ConditionalValidator turns a true/false check into a validator. For more control, such as a message that depends on the value, extend Validator<String>.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _customValidatorExample),
          ],
        ),
        '```dart\n$_customValidatorExample\n```',
      ),
      _Section(
        'Try them',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Each field below uses the validator named in its hint. Type to see errors as you go, or press Submit on the empty form to see which rules reject a field left blank.',
            ),
            const SizedBox(height: 16),
            _demoFrame(const ValidatorsDemo()),
          ],
        ),
        'A live form with one field per validator.',
      ),
      _Section(
        'When validation runs',
        _paragraph(
          'A field is validated when its value changes and again on controller.submit(); onSubmit runs only if every field passes. An untouched field shows no error until submit. Fields with enabled: false skip validation, so a locked value never blocks submit. Each validator only sees its own field\'s value, so shadcn_flutter\'s CompareWith does not work inside BoF.form; compare two fields by reading the form controller instead.',
        ),
        'Validation runs on change and on submit. Disabled fields are skipped. CompareWith does not work inside BoF.form.',
      ),
    ],
    '/conditional-styling' => [
      _Section(
        'How it works',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'The package adds three methods to every value, so you can apply a change only when a condition holds without breaking out of a chain or wrapping the whole widget in an if/else.',
            ),
            const SizedBox(height: 16),
            _parameters(const [
              DocParameter(
                name: '.when(condition, transform)',
                type: 'T',
                description:
                    'Returns transform(this) when condition is true, otherwise this unchanged.',
              ),
              DocParameter(
                name: '.unless(condition, transform)',
                type: 'T',
                description:
                    'The inverse of when: applies transform when condition is false.',
              ),
              DocParameter(
                name: '.whenNotNull(value, transform)',
                type: 'T',
                description:
                    'Applies transform(this, value) only when value is not null, passing it in already non-null.',
              ),
            ]),
          ],
        ),
        '.when(condition, transform), .unless(condition, transform), .whenNotNull(value, (it, value) => ...). Each returns the same type it was called on.',
      ),
      _Section(
        'Chain text modifiers',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Each method returns the same type it was called on. Text modifiers such as .small and .muted return a TextModifier, not a Text, so start the chain from a value typed as Widget, or after a first modifier.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _conditionalTextExample),
          ],
        ),
        '```dart\n$_conditionalTextExample\n```',
      ),
      _Section(
        'Try it',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'The switches below feed the chain from the previous example.',
            ),
            const SizedBox(height: 16),
            _demoFrame(const ConditionalDemo()),
          ],
        ),
        'A live demo of when, unless, and whenNotNull on one text widget.',
      ),
      _Section(
        'Wrap any widget',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'The transform can return a different widget around the original, which is handy for tooltips, skeletons and other wrappers you only sometimes want.',
            ),
            const SizedBox(height: 16),
            const CodeBlock(code: _conditionalWrapExample),
            const SizedBox(height: 16),
            _paragraph(
              'For lists, such as the fields passed to BoF.form, prefer Dart\'s collection if: [if (showAddress) addressField]. For a field\'s own settings, pass the condition directly, for example enabled: !appointment.locked.',
            ),
          ],
        ),
        '```dart\n$_conditionalWrapExample\n```\n\nFor lists, prefer collection if. For field settings, pass the condition directly.',
      ),
    ],
    _ => [
      _Section(
        'Find your way',
        Align(
          alignment: Alignment.centerLeft,
          child: BoF.button(
            'Back to documentation',
            onPressed: () => _navigate('/'),
          ),
        ),
        'Go to / for the documentation home.',
      ),
    ],
  };

  Widget _cards(List<(String, String, IconData, String)> cards) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 600 && cards.length == 3
              ? 3
              : constraints.maxWidth >= 440
              ? 2
              : 1;
          final width = (constraints.maxWidth - 16 * (columns - 1)) / columns;
          final colors = Theme.of(context).colorScheme;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final card in cards)
                SizedBox(
                  width: width,
                  child: BoF.button(
                    null,
                    type: BoFButtonType.outline,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(22),
                    borderRadius: BorderRadius.circular(13),
                    icon: SizedBox(
                      width: width - 44,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(card.$3, size: 25),
                              const Spacer(),
                              Icon(
                                material.Icons.arrow_outward_rounded,
                                size: 16,
                                color: colors.mutedForeground,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            card.$1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            card.$2,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: colors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => _navigate(card.$4),
                  ),
                ),
            ],
          );
        },
      );

  Widget _pagination() {
    final pages = [
      ..._guides.map((guide) => (guide.$1, guide.$2)),
      ...componentPages.map((page) => ('/components/${page.id}', page.title)),
    ];
    final index = pages.indexWhere((page) => page.$1 == widget.path);
    if (index < 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.border),
        ),
      ),
      child: Row(
        children: [
          if (index > 0)
            Expanded(
              child: BoF.button(
                pages[index - 1].$2,
                type: BoFButtonType.ghost,
                alignment: Alignment.centerLeft,
                fontSize: 13,
                icon: const Icon(material.Icons.arrow_back_rounded, size: 16),
                onPressed: () => _navigate(pages[index - 1].$1),
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: 16),
          if (index + 1 < pages.length)
            Expanded(
              child: BoF.button(
                pages[index + 1].$2,
                type: BoFButtonType.ghost,
                alignment: Alignment.centerRight,
                fontSize: 13,
                icon: const Icon(
                  material.Icons.arrow_forward_rounded,
                  size: 16,
                ),
                iconPosition: BoFIconPosition.right,
                onPressed: () => _navigate(pages[index + 1].$1),
              ),
            )
          else
            const Spacer(),
        ],
      ),
    );
  }
}

class _Section {
  const _Section(this.title, this.child, this.copyText);
  final String title;
  final Widget child;
  final String copyText;
}

class _ComponentPreview extends StatefulWidget {
  const _ComponentPreview({super.key, required this.page});
  final DocPage page;
  @override
  State<_ComponentPreview> createState() => _ComponentPreviewState();
}

class _ComponentPreviewState extends State<_ComponentPreview> {
  bool _showCode = false;
  int _revision = 0;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            BoF.button(
              'Preview',
              type: _showCode ? BoFButtonType.ghost : BoFButtonType.secondary,
              size: ButtonSize.small,
              onPressed: () => setState(() => _showCode = false),
            ),
            const SizedBox(width: 4),
            BoF.button(
              'Code',
              type: _showCode ? BoFButtonType.secondary : BoFButtonType.ghost,
              size: ButtonSize.small,
              icon: const Icon(material.Icons.code_rounded, size: 15),
              onPressed: () => setState(() => _showCode = true),
            ),
            const Spacer(),
            if (!_showCode)
              Tooltip(
                tooltip: (_) => const Text('Reset preview'),
                child: Semantics(
                  label: 'Reset preview',
                  button: true,
                  child: BoF.button(
                    null,
                    type: BoFButtonType.ghost,
                    icon: const Icon(material.Icons.refresh_rounded, size: 16),
                    onPressed: () => setState(() => _revision++),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Offstage(
          offstage: _showCode,
          child: TickerMode(
            enabled: !_showCode,
            child: Container(
              key: ValueKey('${widget.page.id}-$_revision'),
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(minHeight: 180),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: buildComponentPreview(context, widget.page.id),
              ),
            ),
          ),
        ),
        if (_showCode) CodeBlock(code: widget.page.code),
      ],
    );
  }
}

class _SearchDialog extends StatefulWidget {
  const _SearchDialog();
  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final query = _query.trim().toLowerCase();
    final entries = <(String, String, String, String)>[
      for (final guide in _guides)
        (guide.$1, guide.$2, 'Get started', guide.$3),
      for (final page in componentPages)
        (
          '/components/${page.id}',
          page.title,
          page.group,
          '${page.description} ${page.code} ${page.parameters.map((p) => p.name).join(' ')}',
        ),
    ];
    final results =
        entries
            .where(
              (entry) =>
                  query.isEmpty ||
                  '${entry.$2} ${entry.$3} ${entry.$4}'.toLowerCase().contains(
                    query,
                  ),
            )
            .toList()
          ..sort((a, b) {
            final aTitle = a.$2.toLowerCase().contains(query) ? 0 : 1;
            final bTitle = b.$2.toLowerCase().contains(query) ? 0 : 1;
            return aTitle.compareTo(bTitle);
          });
    return material.Dialog(
      backgroundColor: colors.background,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: colors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 540),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Search documentation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  BoF.button(
                    null,
                    type: BoFButtonType.ghost,
                    icon: const Icon(material.Icons.close_rounded, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              BoF.textField(
                autofocus: true,
                placeholder: const Text(
                  'Search components, guides, or parameters...',
                ),
                leadingIcon: const Icon(
                  material.Icons.search_rounded,
                  size: 18,
                ),
                onChanged: (value) => setState(() => _query = value),
                onSubmitted: (_) {
                  if (results.isNotEmpty) {
                    Navigator.pop(context, results.first.$1);
                  }
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              material.Icons.search_off_rounded,
                              color: colors.mutedForeground,
                              size: 28,
                            ),
                            const SizedBox(height: 12),
                            const Text('No results found'),
                            const SizedBox(height: 6),
                            Text(
                              'Try a component name like button or select.',
                              style: TextStyle(
                                color: colors.mutedForeground,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return BoF.button(
                            '${result.$2}  ·  ${result.$3}',
                            type: BoFButtonType.ghost,
                            alignment: Alignment.centerLeft,
                            fontSize: 13,
                            icon: const Icon(
                              material.Icons.article_outlined,
                              size: 17,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            onPressed: () => Navigator.pop(context, result.$1),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter to open the first result · Esc to close',
                style: TextStyle(fontSize: 11, color: colors.mutedForeground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _appExample =
    '''import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

void main() => runApp(
  ShadcnApp(
    theme: ThemeData(colorScheme: ColorSchemes.lightZinc),
    home: Scaffold(
      child: Center(
        child: BoF.button('Hello, Friday.', onPressed: () {}),
      ),
    ),
  ),
);''';

const _themeExample = '''ShadcnApp(
  theme: ThemeData(
    colorScheme: ColorSchemes.lightZinc,
    radius: 0.6,
  ),
  darkTheme: ThemeData(
    colorScheme: ColorSchemes.darkZinc,
    radius: 0.6,
  ),
  themeMode: ThemeMode.system,
  home: Scaffold(child: BoF.text('Your app')),
);''';

const _styleExample = '''BoF.button(
  'Make it yours',
  onPressed: () {},
  backgroundColor: const Color(0xFF6E56CF),
  foregroundColor: Colors.white,
  fontSize: 16,
  borderRadius: BorderRadius.circular(20),
);''';

const _inputStyleExample = '''BoF.textField(
  placeholder: const Text('Email'),
  backgroundColor: Colors.blue.withValues(alpha: 0.08),
  foregroundColor: Colors.blue[900],
  borderColor: Colors.blue,
  borderWidth: 1,
  borderRadius: BorderRadius.circular(12),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  onChanged: (value) {},
);''';

const _formExample = '''class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final controller = BoFFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      BoF.form(
        [
          BoFTextField(name: 'email', label: BoF.text('Email')),
          BoFDateInputField(
            name: 'birthday',
            label: BoF.text('Birthday'),
            validator: const NonNullValidator<DateTime>(),
          ),
        ],
        controller: controller,
        onSubmit: (values) {
          BoF.toast(context, title: 'Profile saved');
        },
      ),
      const SizedBox(height: 16),
      BoF.button('Save profile', onPressed: () => controller.submit()),
    ],
  );
}''';

const _validatorExample = '''BoFTextField(
  name: 'email',
  label: BoF.text('Email'),
  validator: const NotEmptyValidator() & const EmailValidator(),
);''';

const _textValidators = [
  DocParameter(
    name: 'NotEmptyValidator()',
    type: 'Validator<String>',
    description: 'Fails when the field is null or an empty string.',
  ),
  DocParameter(
    name: 'NonNullValidator<String>()',
    type: 'Validator<String>',
    description:
        'Fails only when the value is null. A field the user typed in and then cleared holds an empty string, which passes, so prefer NotEmptyValidator for text.',
  ),
  DocParameter(
    name: 'LengthValidator(min:, max:)',
    type: 'Validator<String>',
    description:
        'Checks the number of characters. Either bound may be left out. An untouched field fails only when min is set.',
  ),
  DocParameter(
    name: 'EmailValidator()',
    type: 'Validator<String>',
    description:
        'Checks the email format. It passes an untouched field but fails an emptied one, so pair it with NotEmptyValidator for a required email.',
  ),
  DocParameter(
    name: 'RegexValidator(RegExp)',
    type: 'Validator<String>',
    description:
        'Fails when the pattern does not match. Anchor the pattern with ^ and \$ to match the whole value, and pass a message, since the default one is generic.',
  ),
  DocParameter(
    name: 'SafePasswordValidator()',
    type: 'Validator<String>',
    description:
        'Requires a digit, a lowercase letter, an uppercase letter, and a special character. Turn each off with requireDigit, requireLowercase, requireUppercase, or requireSpecialChar. It does not check length, so combine it with LengthValidator.',
  ),
  DocParameter(
    name: 'URLValidator()',
    type: 'Validator<String>',
    description:
        'Only rejects text Dart cannot parse as a URI, so almost anything passes, including "hello world". Use a RegexValidator or ConditionalValidator when the value must be a web address.',
  ),
  DocParameter(
    name: 'ConditionalValidator<String>(test, message:)',
    type: 'Validator<String>',
    description:
        'Your own rule: fails with message when test(value) returns false. test may be async.',
  ),
];

const _combineExample = r"""// Both rules must pass; the first failure is shown.
validator: const NotEmptyValidator() & const LengthValidator(min: 3, max: 20),

// Invert a rule: reject values that are only digits.
validator: ~RegexValidator(RegExp(r'^\d+$'), message: 'Add a letter.'),""";

const _customValidatorExample =
    r"""// A yes/no check with a fixed message. Empty is allowed, so the
// field stays optional.
final website = ConditionalValidator<String>(
  (value) =>
      value == null ||
      value.isEmpty ||
      RegExp(r'^https?://\S+\.\S+$').hasMatch(value),
  message: 'Enter a full URL, starting with https://',
);

// A reusable rule with a message that depends on the value.
class NoSpacesValidator extends Validator<String> {
  const NoSpacesValidator();

  @override
  ValidationResult? validate(
    BuildContext context,
    String? value,
    FormValidationMode state,
  ) {
    final spaces = ' '.allMatches(value ?? '').length;
    if (spaces == 0) return null;
    return InvalidResult('Remove $spaces space(s).', state: state);
  }
}""";

const _conditionalTextExample =
    '''// Typed as Widget so modifiers like .small fit the chain.
final Widget title = BoF.text('Team standup');

title
    .when(compact, (t) => t.small)
    .when(selected, (t) => t.semiBold)
    .unless(selected, (t) => t.muted)
    .whenNotNull(
      flagColor, // Color?
      (t, color) => DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: t,
      ),
    );

// Or start after a first modifier:
BoF.text('Team standup').small.when(selected, (t) => t.semiBold);''';

const _conditionalWrapExample =
    '''// Explain why a button is disabled, only when there is a reason.
BoF.button('Save', onPressed: canSave ? save : null)
    .whenNotNull(
      disabledReason, // String?
      (button, reason) => BoF.tooltip(button, message: reason),
    );

// Show a loading placeholder while data is on its way.
BoF.card(content).when(isLoading, (card) => BoF.skeleton(card));''';
