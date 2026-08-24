import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../widgets/choice.dart';
import '../widgets/radio_group.dart';
import '../widgets/select.dart';
import 'bof_field.dart';
import 'bof_option.dart';

/// A single/radio choice field, rendered as a group of radio items (or radio
/// cards when [card] is true). Maps to shadcn_flutter's `ControlledRadioGroup`
/// combined with `RadioItem`/`RadioCard`.
class BoFRadioGroupField<T extends Object> extends BoFField<T> {
  @override
  final T? initialValue;

  final List<BoFOption<T>> options;
  final bool card;
  final Axis direction;

  const BoFRadioGroupField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.options,
    this.initialValue,
    this.card = false,
    this.direction = Axis.vertical,
  });

  @override
  Widget buildInput(
    BuildContext context,
    T? value,
    ValueChanged<T?> onChanged,
    bool enabled,
  ) {
    return bofRadioGroupField<T>(
      options: options,
      initialValue: value,
      card: card,
      direction: direction,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// A single-selection dropdown. Maps to shadcn_flutter's `ControlledSelect`.
class BoFSelectField<T extends Object> extends BoFField<T> {
  @override
  final T? initialValue;

  final List<BoFOption<T>> options;
  final Widget? placeholder;
  final bool filled;

  const BoFSelectField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.options,
    this.initialValue,
    this.placeholder,
    this.filled = false,
  });

  @override
  Widget buildInput(
    BuildContext context,
    T? value,
    ValueChanged<T?> onChanged,
    bool enabled,
  ) {
    return bofSelectField<T>(
      options: options,
      initialValue: value,
      placeholder: placeholder,
      filled: filled,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// A multi-selection dropdown. Maps to shadcn_flutter's `ControlledMultiSelect`.
class BoFMultiSelectField<T extends Object> extends BoFField<Iterable<T>> {
  @override
  final Iterable<T>? initialValue;

  final List<BoFOption<T>> options;
  final Widget? placeholder;

  const BoFMultiSelectField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.options,
    this.initialValue,
    this.placeholder,
  });

  @override
  Widget buildInput(
    BuildContext context,
    Iterable<T>? value,
    ValueChanged<Iterable<T>?> onChanged,
    bool enabled,
  ) {
    return bofMultiSelectField<T>(
      options: options,
      initialValue: value,
      placeholder: placeholder,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// An inline single choice, rendered as tappable chips. Maps to
/// shadcn_flutter's `ControlledMultipleChoice`.
class BoFMultipleChoiceField<T extends Object> extends BoFField<T> {
  @override
  final T? initialValue;

  final List<BoFOption<T>> options;
  final bool allowUnselect;

  const BoFMultipleChoiceField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.options,
    this.initialValue,
    this.allowUnselect = true,
  });

  @override
  Widget buildInput(
    BuildContext context,
    T? value,
    ValueChanged<T?> onChanged,
    bool enabled,
  ) {
    return bofMultipleChoiceField<T>(
      options: options,
      initialValue: value,
      allowUnselect: allowUnselect,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}

/// An inline multi-choice, rendered as tappable chips. Maps to
/// shadcn_flutter's `ControlledMultipleAnswer`.
class BoFMultipleAnswerField<T extends Object> extends BoFField<Iterable<T>> {
  @override
  final Iterable<T>? initialValue;

  final List<BoFOption<T>> options;

  const BoFMultipleAnswerField({
    required super.name,
    required super.label,
    super.hint,
    super.validator,
    required this.options,
    this.initialValue,
  });

  @override
  Widget buildInput(
    BuildContext context,
    Iterable<T>? value,
    ValueChanged<Iterable<T>?> onChanged,
    bool enabled,
  ) {
    return bofMultipleAnswerField<T>(
      options: options,
      initialValue: value,
      enabled: enabled,
      onChanged: onChanged,
    );
  }
}
