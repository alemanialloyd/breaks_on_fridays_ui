import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A single selectable option for choice-based [BoFField]s (radio group,
/// select, multi-select, multiple choice/answer).
class BoFOption<T> {
  /// The value this option represents.
  final T value;

  /// The widget displayed to represent this option.
  final Widget label;

  /// Whether this option can be selected.
  final bool enabled;

  const BoFOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });
}
