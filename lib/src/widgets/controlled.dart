import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Internal state adapter shared by BoF controls that need nullable values.
///
/// A controller owns the value even when its current value is null. Without
/// one, the initial value seeds state and a changed seed updates that state.
class BofControlledAdapter<T> extends StatefulWidget {
  const BofControlledAdapter({
    super.key,
    required this.initialValue,
    required this.builder,
    this.controller,
    this.onChanged,
    this.enabled = true,
  });

  final T initialValue;
  final ComponentController<T>? controller;
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final Widget Function(BuildContext, ControlledComponentData<T>) builder;

  @override
  State<BofControlledAdapter<T>> createState() =>
      _BofControlledAdapterState<T>();
}

class _BofControlledAdapterState<T> extends State<BofControlledAdapter<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.controller != null
        ? widget.controller!.value
        : widget.initialValue;
    widget.controller?.addListener(_controllerChanged);
  }

  @override
  void didUpdateWidget(BofControlledAdapter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_controllerChanged);
      widget.controller?.addListener(_controllerChanged);
      _value = widget.controller != null
          ? widget.controller!.value
          : widget.initialValue;
    } else if (widget.controller == null &&
        !_sameInitialValue(oldWidget.initialValue, widget.initialValue)) {
      _value = widget.initialValue;
    }
  }

  bool _sameInitialValue(T previous, T current) {
    if (previous == current) return true;
    if (previous is! Iterable || current is! Iterable) return false;
    final previousItems = previous.iterator;
    final currentItems = current.iterator;
    while (previousItems.moveNext()) {
      if (!currentItems.moveNext() ||
          previousItems.current != currentItems.current) {
        return false;
      }
    }
    return !currentItems.moveNext();
  }

  void _controllerChanged() {
    setState(() => _value = widget.controller!.value);
  }

  void _changed(T value) {
    if (!widget.enabled) return;
    final controller = widget.controller;
    if (controller == null) {
      setState(() => _value = value);
    } else {
      controller.value = value;
    }
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_controllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    ControlledComponentData<T>(
      value: _value,
      onChanged: _changed,
      enabled: widget.enabled,
    ),
  );
}
