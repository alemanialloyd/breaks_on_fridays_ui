import 'package:flutter/services.dart' show TextCapitalization, TextInputAction;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../widgets/checkbox.dart';
import '../widgets/input.dart';

/// Base spec for a single field rendered by [bofForm].
///
/// A [BoFField] describes *what* a field is (its name, label, validator and
/// kind-specific configuration) without needing a [TextEditingController] or
/// any other controller object — [bofForm] owns all field state internally
/// and exposes it through a [BoFFormController].
///
/// Every concrete subclass (see `bof_field.dart`, `bof_choice_fields.dart`,
/// `bof_datetime_fields.dart` and `bof_misc_fields.dart`) implements
/// [buildInput] to render the matching shadcn_flutter widget.
abstract class BoFField<T> {
  /// The unique name used to key this field's value in [BoFFormController].
  final String name;

  /// The label displayed above the field.
  final Widget label;

  /// Optional helper text displayed below the field.
  final Widget? hint;

  /// Optional validator, evaluated on change and on submit.
  final Validator<T>? validator;

  const BoFField({
    required this.name,
    required this.label,
    this.hint,
    this.validator,
  });

  /// The value this field starts with, used to seed [BoFFormController].
  T? get initialValue;

  /// Builds the input widget for this field.
  ///
  /// [onChanged] must be called whenever the user changes the value; it
  /// reports the new value back to the enclosing [bofForm].
  Widget buildInput(
    BuildContext context,
    ValueChanged<T?> onChanged,
    bool enabled,
  );
}

/// A single-line text field. Maps to shadcn_flutter's `TextField`.
class BoFTextField extends BoFField<String> {
  @override
  final String? initialValue;

  final Widget? placeholder;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool? obscureText;
  final bool showPasswordToggle;
  final PasswordPeekMode passwordPeekMode;
  final List<InputFeature>? features;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  const BoFTextField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
    this.placeholder,
    this.leadingIcon,
    this.trailingIcon,
    this.obscureText,
    this.showPasswordToggle = false,
    this.passwordPeekMode = PasswordPeekMode.toggle,
    this.features,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<String?> onChanged,
    bool enabled,
  ) {
    return bofTextField(
      initialValue: initialValue,
      placeholder: placeholder,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      obscureText: obscureText,
      showPasswordToggle: showPasswordToggle,
      passwordPeekMode: passwordPeekMode,
      features: features,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

/// A multi-line text field. Maps to shadcn_flutter's `TextArea`.
class BoFTextAreaField extends BoFField<String> {
  @override
  final String? initialValue;

  final Widget? placeholder;
  final double minHeight;
  final double maxHeight;

  const BoFTextAreaField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
    this.placeholder,
    this.minHeight = 100,
    this.maxHeight = double.infinity,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<String?> onChanged,
    bool enabled,
  ) {
    return bofTextAreaField(
      initialValue: initialValue,
      placeholder: placeholder,
      minHeight: minHeight,
      maxHeight: maxHeight,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// A numeric text field.
///
/// shadcn_flutter has no dedicated number-input widget, so this wraps
/// `TextField` with a numeric keyboard and parses the text to [num].
class BoFNumberField extends BoFField<num> {
  @override
  final num? initialValue;

  final Widget? placeholder;
  final bool allowDecimal;

  const BoFNumberField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue,
    this.placeholder,
    this.allowDecimal = true,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<num?> onChanged,
    bool enabled,
  ) {
    return bofNumberField(
      initialValue: initialValue,
      placeholder: placeholder,
      allowDecimal: allowDecimal,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// A tri-state checkbox. Maps to shadcn_flutter's `ControlledCheckbox`.
class BoFCheckboxField extends BoFField<CheckboxState> {
  @override
  final CheckboxState initialValue;

  const BoFCheckboxField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue = CheckboxState.unchecked,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<CheckboxState?> onChanged,
    bool enabled,
  ) {
    return bofCheckboxField(
      initialValue: initialValue,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// A boolean switch. Maps to shadcn_flutter's `ControlledSwitch`.
class BoFSwitchField extends BoFField<bool> {
  @override
  final bool initialValue;

  const BoFSwitchField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    this.initialValue = false,
  });

  @override
  Widget buildInput(
    BuildContext context,
    ValueChanged<bool?> onChanged,
    bool enabled,
  ) {
    return bofSwitchField(
      initialValue: initialValue,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}
