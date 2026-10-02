import 'dart:async';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';
import 'package:flutter/material.dart' as material show Icons;
import 'package:flutter/services.dart';

class CodeBlock extends StatefulWidget {
  const CodeBlock({super.key, required this.code, this.language = 'Dart'});

  final String code;
  final String language;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.code));
      if (!mounted) return;
      setState(() => _copied = true);
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _copied = false);
      });
    } catch (_) {
      if (mounted) {
        BoF.toast(
          context,
          title: 'Copy unavailable',
          message: 'Select the code to copy it manually.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.border)),
            ),
            child: Row(
              children: [
                Icon(
                  material.Icons.code_rounded,
                  size: 16,
                  color: colors.mutedForeground,
                ),
                const SizedBox(width: 8),
                BoF.text(widget.language).small.muted,
                const Spacer(),
                BoF.button(
                  _copied ? 'Copied' : 'Copy code',
                  icon: Icon(
                    _copied
                        ? material.Icons.check_rounded
                        : material.Icons.content_copy_rounded,
                    size: 14,
                  ),
                  type: BoFButtonType.ghost,
                  size: ButtonSize.small,
                  onPressed: _copy,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(20),
            child: SelectableText.rich(
              TextSpan(children: _highlight(widget.code, colors)),
              style: Theme.of(context).typography.mono.copyWith(
                fontSize: 13,
                height: 1.8,
                color: colors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _highlight(String source, ColorScheme colors) {
    if (widget.language != 'Dart') return [TextSpan(text: source)];
    final pattern = RegExp(
      r"//[^\n]*|'[^'\n]*'|\b(?:import|void|return|const|final|class|extends|super|required|if|true|false|null|async|await|override)\b|\b\d+(?:\.\d+)?\b",
    );
    final spans = <TextSpan>[];
    var end = 0;
    final dark = colors.brightness == Brightness.dark;
    for (final match in pattern.allMatches(source)) {
      if (match.start > end) {
        spans.add(TextSpan(text: source.substring(end, match.start)));
      }
      final token = match.group(0)!;
      final color = token.startsWith('//')
          ? colors.mutedForeground
          : token.startsWith("'")
          ? (dark ? const Color(0xFFA6D2B7) : const Color(0xFF39764C))
          : (dark ? const Color(0xFFC2B5ED) : const Color(0xFF7253A2));
      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(color: color),
        ),
      );
      end = match.end;
    }
    if (end < source.length) spans.add(TextSpan(text: source.substring(end)));
    return spans;
  }
}
