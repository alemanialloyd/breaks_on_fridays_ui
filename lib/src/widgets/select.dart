import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../forms/bof_option.dart';

Widget _buildSelectItem<T>(
  List<BoFOption<T>> options,
  BuildContext context,
  T value,
) {
  final match = options.where((o) => o.value == value);
  return match.isEmpty ? Text('$value') : match.first.label;
}

SelectPopupBuilder _buildSelectPopup<T>(List<BoFOption<T>> options) {
  return (context) => SelectPopup(
        items: SelectItemList(
          children: [
            for (final option in options)
              SelectItemButton<T>(
                value: option.value,
                enabled: option.enabled,
                child: option.label,
              ),
          ],
        ),
      );
}

/// A single-selection dropdown. Wraps shadcn_flutter's `ControlledSelect`.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue].
Widget bofSelectField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  T? initialValue,
  SelectController<T>? controller,
  Widget? placeholder,
  bool filled = false,
  bool enabled = true,
  ValueChanged<T?>? onChanged,
}) {
  return ControlledSelect<T>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    filled: filled,
    placeholder: placeholder,
    onChanged: onChanged,
    itemBuilder: (context, value) => _buildSelectItem(options, context, value),
    popup: _buildSelectPopup(options),
  );
}

/// A multi-selection dropdown. Wraps shadcn_flutter's `ControlledMultiSelect`.
///
/// Pass [controller] to update the selection programmatically; when provided
/// it takes precedence over [initialValue].
Widget bofMultiSelectField<T extends Object>({
  Key? key,
  required List<BoFOption<T>> options,
  Iterable<T>? initialValue,
  MultiSelectController<T>? controller,
  Widget? placeholder,
  bool enabled = true,
  ValueChanged<Iterable<T>?>? onChanged,
}) {
  return ControlledMultiSelect<T>(
    key: key,
    initialValue: initialValue,
    controller: controller,
    enabled: enabled,
    placeholder: placeholder,
    onChanged: onChanged,
    itemBuilder: (context, value) => _buildSelectItem(options, context, value),
    popup: _buildSelectPopup(options),
  );
}
