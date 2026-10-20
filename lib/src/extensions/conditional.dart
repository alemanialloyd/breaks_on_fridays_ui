import 'package:flutter/widgets.dart';

/// Adds conditional chaining to any value, so a modifier or wrapper can be
/// applied only when a condition holds without breaking out of a chain.
///
/// Widgets get [ConditionalWidget] instead, whose transforms may return any
/// [Widget]. This extension covers every other value, and each method returns
/// the same type it was called on:
///
/// ```dart
/// final style = baseStyle.when(isError, (s) => s.copyWith(color: red));
/// ```
extension ConditionalValue<T> on T {
  /// Returns `transform(this)` if [condition] is true, otherwise returns
  /// this value unchanged.
  T when(bool condition, T Function(T value) transform) {
    return condition ? transform(this) : this;
  }

  /// Returns `transform(this)` if [condition] is false, otherwise returns
  /// this value unchanged. The inverse of [when].
  T unless(bool condition, T Function(T value) transform) {
    return when(!condition, transform);
  }

  /// Returns `transform(this, value)` if [value] is non-null, otherwise
  /// returns this value unchanged.
  T whenNotNull<V>(V? value, T Function(T value, V notNull) transform) {
    return value == null ? this : transform(this, value);
  }
}

/// Conditional chaining for any widget, so shadcn_flutter modifiers such as
/// `.small` and `.muted` on [Text] or `.iconSmall` on [Icon] can be applied
/// conditionally without breaking out of the chain.
///
/// The transform receives the widget with its own type (an [Icon] stays an
/// [Icon], so its fields can be read) and may return any [Widget], which is
/// what shadcn_flutter's modifiers and wrappers such as `BoF.tooltip` return.
/// The result is typed as [Widget]:
///
/// ```dart
/// BoF.text(label)
///     .when(isMobile, (text) => text.small)
///     .when(isSelected, (text) => text.semiBold)
///     .unless(isSelected, (text) => text.muted);
///
/// const Icon(LucideIcons.star)
///     .when(compact, (icon) => icon.iconSmall)
///     .unless(enabled, (icon) => icon.iconMutedForeground);
/// ```
///
/// Dart picks this extension over [ConditionalValue] for every widget,
/// because its `on` type is more specific.
extension ConditionalWidget<W extends Widget> on W {
  /// Returns `transform(this)` if [condition] is true, otherwise returns
  /// this widget unchanged.
  Widget when(bool condition, Widget Function(W widget) transform) {
    return condition ? transform(this) : this;
  }

  /// Returns `transform(this)` if [condition] is false, otherwise returns
  /// this widget unchanged. The inverse of [when].
  Widget unless(bool condition, Widget Function(W widget) transform) {
    return when(!condition, transform);
  }

  /// Returns `transform(this, value)` if [value] is non-null, otherwise
  /// returns this widget unchanged. Useful for optionally applying a modifier
  /// backed by a nullable value, e.g.
  /// `button.whenNotNull(reason, (b, r) => BoF.tooltip(b, message: r))`.
  Widget whenNotNull<V>(
    V? value,
    Widget Function(W widget, V notNull) transform,
  ) {
    return value == null ? this : transform(this, value);
  }
}
