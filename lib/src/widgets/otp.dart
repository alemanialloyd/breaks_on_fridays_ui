import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';

/// The visual layout of a [bofOtpField].
enum BoFOtpFieldType {
  /// Connected cells with no gap (`spacing` defaults to `0`); [borderRadius]
  /// applies only to the outer corners of the first and last cells.
  compact,

  /// Separated cells with a gap (`spacing` defaults to `8 * theme.scaling`);
  /// [borderRadius] applies to all four corners of every cell.
  comfortable,
}

/// A one-time-password / PIN input built with shadcn_flutter's [Theme],
/// [FocusOutline], and [TextField].
///
/// Use [type] to switch between connected (`BoFOtpFieldType.compact`) and
/// separated (`BoFOtpFieldType.comfortable`) cells, or override the gap with
/// [spacing] (whenever effective spacing is greater than `0`, every cell rounds
/// all four corners). [height] sets each cell's width and height,
/// [backgroundColor] fills each cell, [foregroundColor]/[fontSize]/[fontWeight]
/// style the characters, [borderRadius] sets the corner radius, and
/// [borderColor] sets each cell's border color.
///
/// This widget has no `enabled` parameter and no controller of its own, so
/// programmatic value updates aren't supported; changing [initialValue] only
/// resets state via a new [key].
Widget bofOtpField({
  Key? key,
  required int length,
  List<int?>? initialValue,
  ValueChanged<List<int?>>? onChanged,
  BoFOtpFieldType type = BoFOtpFieldType.compact,
  double? spacing,
  double? height,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
}) {
  return _BoFOtpField(
    key: key,
    length: length,
    initialValue: initialValue,
    onChanged: onChanged,
    type: type,
    spacing: spacing,
    height: height,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    borderRadius: borderRadius,
    borderColor: borderColor,
  );
}

class _BoFOtpField extends StatefulWidget {
  final int length;
  final List<int?>? initialValue;
  final ValueChanged<List<int?>>? onChanged;
  final BoFOtpFieldType type;
  final double? spacing;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;

  const _BoFOtpField({
    super.key,
    required this.length,
    this.initialValue,
    this.onChanged,
    required this.type,
    this.spacing,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.borderColor,
  });

  @override
  State<_BoFOtpField> createState() => _BoFOtpFieldState();
}

class _BoFOtpFieldState extends State<_BoFOtpField> {
  late List<int?> _values;
  final List<FocusNode> _focusNodes = [];
  final List<FocusScopeNode> _focusScopeNodes = [];
  final List<TextEditingController> _controllers = [];
  final List<VoidCallback> _controllerListeners = [];
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _values = List<int?>.generate(widget.length, _initialValueAt);
    for (var i = 0; i < widget.length; i++) {
      _addCellNodes(i);
    }
  }

  int? _initialValueAt(int index) {
    final initial = widget.initialValue;
    if (initial == null || index >= initial.length) return null;
    return initial[index];
  }

  void _addCellNodes(int index) {
    final controller = TextEditingController();
    void listener() => _onControllerChanged(index);
    controller.addListener(listener);
    _controllers.add(controller);
    _controllerListeners.add(listener);
    _focusNodes.add(FocusNode());
    _focusScopeNodes.add(FocusScopeNode());
  }

  void _disposeCellNodesAt(int index) {
    _controllers[index].removeListener(_controllerListeners[index]);
    _controllers[index].dispose();
    _focusNodes[index].dispose();
    _focusScopeNodes[index].dispose();
  }

  @override
  void didUpdateWidget(covariant _BoFOtpField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.length < oldWidget.length) {
      for (var i = widget.length; i < _controllers.length; i++) {
        _disposeCellNodesAt(i);
      }
      _controllers.removeRange(widget.length, _controllers.length);
      _controllerListeners.removeRange(
        widget.length,
        _controllerListeners.length,
      );
      _focusNodes.removeRange(widget.length, _focusNodes.length);
      _focusScopeNodes.removeRange(widget.length, _focusScopeNodes.length);
      _values.removeRange(widget.length, _values.length);
    } else if (widget.length > oldWidget.length) {
      for (var i = oldWidget.length; i < widget.length; i++) {
        _addCellNodes(i);
        _values.add(_initialValueAt(i));
      }
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < _controllers.length; i++) {
      _disposeCellNodesAt(i);
    }
    super.dispose();
  }

  void _onControllerChanged(int index) {
    if (_updating) return;
    final controller = _controllers[index];
    final text = controller.text;
    if (text.isEmpty) return;

    _updating = true;
    try {
      controller.clear();
      var target = index;
      var lastFilled = index;
      for (final codepoint in text.runes) {
        if (target >= widget.length) break;
        _values[target] = codepoint;
        lastFilled = target;
        target++;
      }
      setState(() {});
      widget.onChanged?.call(List<int?>.of(_values));
      if (lastFilled + 1 < widget.length) {
        _focusNodes[lastFilled + 1].requestFocus();
      }
    } finally {
      _updating = false;
    }
  }

  KeyEventResult _handleKeyEvent(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (index + 1 < widget.length) {
        _focusNodes[index + 1].requestFocus();
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_values[index] != null) {
        setState(() {
          _values[index] = null;
        });
        widget.onChanged?.call(List<int?>.of(_values));
      } else if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  BorderRadius _cellRadius(
    int index,
    double effectiveSpacing,
    BorderRadius resolvedRadius,
  ) {
    if (effectiveSpacing > 0 || widget.length <= 1) {
      return resolvedRadius;
    }
    if (index == 0) {
      return BorderRadius.only(
        topLeft: resolvedRadius.topLeft,
        bottomLeft: resolvedRadius.bottomLeft,
      );
    }
    if (index == widget.length - 1) {
      return BorderRadius.only(
        topRight: resolvedRadius.topRight,
        bottomRight: resolvedRadius.bottomRight,
      );
    }
    return BorderRadius.zero;
  }

  Widget _buildCell(
    BuildContext context,
    int index,
    ThemeData theme,
    double cellSize,
    BorderRadius cellRadius,
    Color backgroundColor,
    Color borderColor,
  ) {
    final value = _values[index];
    final focusNode = _focusNodes[index];

    return FocusScope(
      node: _focusScopeNodes[index],
      onKeyEvent: (node, event) => _handleKeyEvent(index, event),
      child: SizedBox(
        width: cellSize,
        height: cellSize,
        child: Stack(
          children: [
            Positioned.fill(
              child: ListenableBuilder(
                listenable: focusNode,
                builder: (context, child) {
                  return FocusOutline(
                    focused: focusNode.hasFocus,
                    borderRadius: cellRadius,
                    child: child!,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                      color: borderColor,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                    borderRadius: cellRadius,
                  ),
                ),
              ),
            ),
            if (value != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      String.fromCharCode(value),
                      style: bofFieldTextStyle(
                        null,
                        foregroundColor: widget.foregroundColor,
                        fontSize: widget.fontSize,
                        fontWeight: widget.fontWeight,
                      ),
                    ).small().foreground(),
                  ),
                ),
              ),
            Positioned.fill(
              child: Opacity(
                opacity: value == null ? 1 : 0,
                child: ComponentTheme(
                  data: const FocusOutlineTheme(
                    border: Border.fromBorderSide(BorderSide.none),
                  ),
                  child: TextField(
                    border: const Border.fromBorderSide(BorderSide.none),
                    decoration: const BoxDecoration(),
                    expands: false,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    focusNode: focusNode,
                    controller: _controllers[index],
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final direction = Directionality.of(context);
    final effectiveSpacing =
        widget.spacing ??
        (widget.type == BoFOtpFieldType.comfortable ? 8 * theme.scaling : 0.0);
    final cellSize = widget.height ?? 36 * theme.scaling;
    final resolvedRadius =
        (widget.borderRadius ?? BorderRadius.circular(theme.radiusMd))
            .resolve(direction);
    final effectiveBackgroundColor =
        widget.backgroundColor ?? theme.colorScheme.input.scaleAlpha(0.3);
    final effectiveBorderColor = widget.borderColor ?? theme.colorScheme.border;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0 && effectiveSpacing > 0) SizedBox(width: effectiveSpacing),
          _buildCell(
            context,
            i,
            theme,
            cellSize,
            _cellRadius(i, effectiveSpacing, resolvedRadius),
            effectiveBackgroundColor,
            effectiveBorderColor,
          ),
        ],
      ],
    );
  }
}
