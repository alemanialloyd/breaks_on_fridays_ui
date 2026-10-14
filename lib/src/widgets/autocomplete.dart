import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';
import 'input.dart' show bofWithSelectionColor;

/// A text input with a suggestion popover and shadcn field styling.
///
/// [controller] is passed through to the inner `TextField` and, when provided, takes
/// precedence over [initialValue].
///
/// Suggestions match the current text without regard to case. The suggestion
/// list opens while a nonempty field is focused; selecting an item replaces
/// the whole field text.
///
/// Appearance options match `BoF.textField` and style the inner field only;
/// the suggestion list keeps its themed look.
Widget bofAutoCompleteField({
  Key? key,
  required List<String> suggestions,
  String? initialValue,
  TextEditingController? controller,
  Widget? placeholder,
  bool enabled = true,
  ValueChanged<String>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  TextAlign textAlign = TextAlign.start,
  TextAlignVertical? textAlignVertical,
  TextDirection? textDirection,
  bool? filled,
  BorderRadiusGeometry? borderRadius,
  Border? border,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
  BoxDecoration? decoration,
  Color? selectionColor,
  Color? cursorColor,
  double cursorWidth = 2,
  double? cursorHeight,
  Radius cursorRadius = const Radius.circular(2),
  bool? showCursor,
}) {
  return _BofAutoCompleteField(
    key: key,
    suggestions: suggestions,
    initialValue: initialValue,
    controller: controller,
    placeholder: placeholder,
    enabled: enabled,
    onChanged: onChanged,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    style: style,
    textAlign: textAlign,
    textAlignVertical: textAlignVertical,
    textDirection: textDirection,
    filled: filled,
    borderRadius: borderRadius,
    border: border,
    borderColor: borderColor,
    borderWidth: borderWidth,
    padding: padding,
    decoration: decoration,
    selectionColor: selectionColor,
    cursorColor: cursorColor,
    cursorWidth: cursorWidth,
    cursorHeight: cursorHeight,
    cursorRadius: cursorRadius,
    showCursor: showCursor,
  );
}

class _BofAutoCompleteField extends StatefulWidget {
  const _BofAutoCompleteField({
    super.key,
    required this.suggestions,
    this.initialValue,
    this.controller,
    this.placeholder,
    required this.enabled,
    this.onChanged,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    required this.textAlign,
    this.textAlignVertical,
    this.textDirection,
    this.filled,
    this.borderRadius,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.decoration,
    this.selectionColor,
    this.cursorColor,
    required this.cursorWidth,
    this.cursorHeight,
    required this.cursorRadius,
    this.showCursor,
  });

  final List<String> suggestions;
  final String? initialValue;
  final TextEditingController? controller;
  final Widget? placeholder;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool? filled;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Color? selectionColor;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius cursorRadius;
  final bool? showCursor;

  @override
  State<_BofAutoCompleteField> createState() => _BofAutoCompleteFieldState();
}

class _BofAutoCompleteFieldState extends State<_BofAutoCompleteField> {
  late TextEditingController _controller;
  final _focusNode = FocusNode();
  late String _lastReportedText;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _lastReportedText = _controller.text;
  }

  @override
  void didUpdateWidget(covariant _BofAutoCompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final previousValue = _controller.value;
      if (oldWidget.controller == null) _controller.dispose();
      _controller =
          widget.controller ?? TextEditingController.fromValue(previousValue);
      _lastReportedText = _controller.text;
    }
  }

  void _handleChanged(String value) {
    // The underlying field also reports selection-only changes. Consumers of
    // autocomplete receive one notification per actual text change.
    if (value == _lastReportedText) return;
    _lastReportedText = value;
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // A nonmodal autocomplete overlay keeps the browser's native input and
    // its keyboard focus available while suggestions are visible.
    return RawAutocomplete<String>(
      key: ObjectKey(_controller),
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (value) {
        final query = value.text.trim().toLowerCase();
        if (!widget.enabled || query.isEmpty) return const <String>[];
        return widget.suggestions.where(
          (suggestion) => suggestion.toLowerCase().contains(query),
        );
      },
      onSelected: _handleChanged,
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) =>
          bofWithSelectionColor(
            widget.selectionColor,
            BofTextFieldSurface.builder(
              color: widget.backgroundColor,
              filled: widget.filled,
              border: widget.border,
              borderColor: widget.borderColor,
              borderWidth: widget.borderWidth,
              builder: (context, filled, border) => TextField(
                controller: controller,
                focusNode: focusNode,
                placeholder: widget.placeholder,
                enabled: widget.enabled,
                onChanged: _handleChanged,
                onSubmitted: (_) => onSubmitted(),
                style: bofFieldTextStyle(
                  widget.style,
                  foregroundColor: widget.foregroundColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                ),
                textAlign: widget.textAlign,
                textAlignVertical: widget.textAlignVertical,
                textDirection: widget.textDirection,
                filled: filled,
                border: border,
                borderRadius: widget.borderRadius,
                padding: widget.padding,
                decoration: widget.decoration,
                cursorColor: widget.cursorColor,
                cursorWidth: widget.cursorWidth,
                cursorHeight: widget.cursorHeight,
                cursorRadius: widget.cursorRadius,
                showCursor: widget.showCursor,
              ),
            ),
          ),
      optionsViewBuilder: (context, onSelected, values) {
        final options = values.toList();
        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: double.infinity,
            child: TextFieldTapRegion(
              child: SurfaceCard(
                padding: EdgeInsets.all(
                  theme.density.baseGap * theme.scaling * 0.5,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300 * theme.scaling),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) => Button(
                      style: AutocompleteHighlightedOption.of(context) == index
                          ? ButtonVariance.secondary
                          : ButtonVariance.ghost,
                      alignment: Alignment.centerLeft,
                      onPressed: () => onSelected(options[index]),
                      child: Text(options[index]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
