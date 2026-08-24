import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Holds the live values and validation errors of a [bofForm].
///
/// Unlike shadcn_flutter's own `FormController`, this never deals in
/// [TextEditingController]s — fields report their value directly by name.
/// Pass an instance to `bofForm(controller: ...)` to read values, listen for
/// changes, or trigger validation/submission programmatically.
class BoFFormController extends ChangeNotifier {
  final Map<String, Object?> _values = {};
  final Map<String, ValidationResult?> _errors = {};

  /// Callback wired up by the owning `bofForm` widget to run validation and
  /// invoke `onSubmit`. Set internally; do not assign this yourself.
  Future<void> Function()? submitHandler;

  /// Callback wired up by the owning `bofForm` widget to reset every field
  /// back to its initial value. Set internally; do not assign this yourself.
  VoidCallback? resetHandler;

  /// Callback wired up by the owning `bofForm` widget to push a
  /// programmatic [setValue] call into the rendered field. Set internally;
  /// do not assign this yourself.
  void Function(String name, Object? value)? applyHandler;

  /// The current value of the field named [name], or null if unset.
  T? value<T>(String name) => _values[name] as T?;

  /// A read-only snapshot of all current field values, keyed by field name.
  Map<String, Object?> get values => Map.unmodifiable(_values);

  /// The current validation error for the field named [name], if any.
  ValidationResult? errorOf(String name) => _errors[name];

  /// Whether every field currently has no validation error.
  bool get isValid => _errors.values.every((e) => e is! InvalidResult);

  /// Records a value the user just entered directly into the rendered
  /// field. Called internally by `bofForm` — use [setValue] instead if you
  /// want to change a field's value yourself, since this does not update
  /// the rendered widget (it's already showing this value).
  void reportChange(String name, Object? value) {
    _values[name] = value;
    notifyListeners();
  }

  /// Sets a field's value programmatically — e.g. prefilling the form after
  /// an async fetch resolves, or syncing one field from another. Unlike a
  /// value the user typed, this also updates the rendered widget to match.
  void setValue(String name, Object? value) {
    _values[name] = value;
    applyHandler?.call(name, value);
    notifyListeners();
  }

  void setError(String name, ValidationResult? error) {
    _errors[name] = error;
  }

  /// Validates every field and, if all pass, invokes the form's `onSubmit`.
  Future<void> submit() async {
    await submitHandler?.call();
  }

  /// Resets every field back to its initial value, including the rendered
  /// widgets (e.g. clears typed text, unchecks checkboxes).
  void reset() {
    resetHandler?.call();
  }
}
