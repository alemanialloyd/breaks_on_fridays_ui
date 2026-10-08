/// Adds conditional chaining to any value, so widget modifier chains (e.g.
/// shadcn_flutter's `.small`, `.semiBold`, `.muted` on [Text]) can be applied
/// conditionally without breaking out of the chain.
///
/// Each method returns the same type it was called on. shadcn_flutter's
/// text modifiers return a `TextModifier`, not a [Text], so start the chain
/// from a value typed as `Widget`, or after a first modifier:
///
/// ```dart
/// final Widget title = BoF.text(label);
/// title
///     .when(isMobile, (text) => text.small)
///     .when(isSelected, (text) => text.semiBold)
///     .unless(isSelected, (text) => text.muted);
///
/// BoF.text(label).small.when(isSelected, (text) => text.semiBold);
/// ```
extension ConditionalWidget<T> on T {
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

  /// Returns `transform(this)` if it is non-null, otherwise returns this
  /// value unchanged. Useful for optionally applying a modifier backed by a
  /// nullable value, e.g. `text.whenNotNull(color, (t, c) => t.withColor(c))`.
  T whenNotNull<V>(V? value, T Function(T value, V notNull) transform) {
    return value == null ? this : transform(this, value);
  }
}
