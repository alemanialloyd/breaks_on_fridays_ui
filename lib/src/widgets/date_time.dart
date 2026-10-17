import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'field_style.dart';

/// A popover/dialog date picker. Wraps shadcn_flutter's `ControlledDatePicker`
/// machinery, but swaps in [_BofCalendarView] for the calendar itself so
/// today's date is outlined (see its doc comment for why).
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Defaults to [PromptMode.popover] rather than shadcn_flutter's own default
/// of [PromptMode.dialog]: the dialog mode wraps the calendar in an
/// `AlertDialog`, which adds its own large content padding on top of the
/// calendar's, and Cancel/Save actions that most date-field use cases don't
/// need. Pass `mode: PromptMode.dialog` to opt back into that behavior.
///
/// [trailingIcon] replaces the trigger's calendar icon. The appearance options
/// restyle the trigger button only; the picker it opens keeps its themed look.
/// [foregroundColor] also tints the trigger's icon, and [foregroundColor]/
/// [fontSize]/[fontWeight] override the matching properties of [style].
///
/// Fills the width its parent allows, like `BoF.textField`; wrap it in a
/// `SizedBox` for a fixed width.
Widget bofDatePickerField({
  Key? key,
  DateTime? initialValue,
  DatePickerController? controller,
  Widget? placeholder,
  bool enabled = true,
  PromptMode mode = PromptMode.popover,
  EdgeInsetsGeometry? popoverPadding,
  Widget? dialogTitle,
  Widget? trailingIcon,
  ValueChanged<DateTime?>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    key: key,
    width: double.infinity,
    child: ControlledComponentAdapter<DateTime?>(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      builder: (context, data) {
        final localizations = ShadcnLocalizations.of(context);
        return BofTriggerStyle(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          style: style,
          borderRadius: borderRadius,
          borderColor: borderColor,
          borderWidth: borderWidth,
          padding: padding,
          child: ObjectFormField<DateTime>(
            value: data.value,
            onChanged: data.onChanged,
            enabled: data.enabled,
            placeholder:
                placeholder ?? Text(localizations.placeholderDatePicker),
            trailing: trailingIcon ?? const Icon(LucideIcons.calendarDays),
            mode: mode,
            popoverPadding: popoverPadding,
            dialogTitle: dialogTitle,
            builder: (context, value) {
              return Text(localizations.formatDateTime(value, showTime: false));
            },
            editorBuilder: (context, handler) {
              return _BofCalendarView(
                initialValue: handler.value,
                onChanged: (value) => handler.value = value,
              );
            },
          ),
        );
      },
    ),
  );
}

/// Single-date replacement for shadcn_flutter's `DatePickerDialog`.
///
/// shadcn_flutter's `Calendar`/`MonthCalendar`/`YearCalendar` all support
/// outlining "today" via a `now` parameter, but `DatePickerDialog` — the
/// widget `ControlledDatePicker` actually uses — never passes it, so today's
/// cell is never distinguished from any other date through the public API.
/// This reimplements just the single-selection navigation (month/year
/// header + date/month/year grid) that `bofDatePickerField` needs, wiring
/// `now: DateTime.now()` through so today gets its outline.
class _BofCalendarView extends StatefulWidget {
  final DateTime? initialValue;
  final ValueChanged<DateTime?> onChanged;

  const _BofCalendarView({required this.initialValue, required this.onChanged});

  @override
  State<_BofCalendarView> createState() => _BofCalendarViewState();
}

class _BofCalendarViewState extends State<_BofCalendarView> {
  late CalendarValue? _value = widget.initialValue == null
      ? null
      : CalendarValue.single(widget.initialValue!);
  late CalendarView _view = widget.initialValue == null
      ? CalendarView.now()
      : CalendarView(widget.initialValue!.year, widget.initialValue!.month);
  CalendarViewType _viewType = CalendarViewType.date;
  late int _yearSelectStart = (_view.year ~/ 16) * 16;

  String _headerText(ShadcnLocalizations localizations) {
    switch (_viewType) {
      case CalendarViewType.date:
        return '${localizations.getMonth(_view.month)} ${_view.year}';
      case CalendarViewType.month:
        return '${_view.year}';
      case CalendarViewType.year:
        return localizations.datePickerSelectYear;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = ShadcnLocalizations.of(context);
    final theme = Theme.of(context);
    // `Calendar` matches `now` against each cell's date via `isAtSameMomentAs`,
    // which is exact down to the time component — pass midnight, or "today"
    // never matches any cell.
    final nowRaw = DateTime.now();
    final now = DateTime(nowRaw.year, nowRaw.month, nowRaw.day);
    // The only calendar cell type rendered as a plain `SecondaryButton` is
    // "today", so overriding `SecondaryButtonTheme.decoration` here adds an
    // outline to today's cell without touching any other cell type.
    return ComponentTheme<SecondaryButtonTheme>(
      data: SecondaryButtonTheme(
        decoration: (context, states, value) {
          return (value as BoxDecoration).copyWith(
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 1 * theme.scaling,
            ),
          );
        },
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                OutlineButton(
                  density: ButtonDensity.icon,
                  onPressed: () {
                    setState(() {
                      switch (_viewType) {
                        case CalendarViewType.date:
                          _view = _view.previous;
                          break;
                        case CalendarViewType.month:
                          _view = _view.previousYear;
                          break;
                        case CalendarViewType.year:
                          _yearSelectStart -= 16;
                          break;
                      }
                    });
                  },
                  child: const Icon(LucideIcons.arrowLeft).iconXSmall(),
                ),
                SizedBox(width: theme.scaling * 16),
                Expanded(
                  child: GhostButton(
                    enabled: _viewType != CalendarViewType.year,
                    onPressed: () {
                      setState(() {
                        switch (_viewType) {
                          case CalendarViewType.date:
                            _viewType = CalendarViewType.month;
                            break;
                          case CalendarViewType.month:
                            _viewType = CalendarViewType.year;
                            break;
                          case CalendarViewType.year:
                            break;
                        }
                      });
                    },
                    child: Text(
                      _headerText(localizations),
                    ).foreground().small().medium().center(),
                  ).sized(height: theme.scaling * 32),
                ),
                SizedBox(width: theme.scaling * 16),
                OutlineButton(
                  density: ButtonDensity.icon,
                  onPressed: () {
                    setState(() {
                      switch (_viewType) {
                        case CalendarViewType.date:
                          _view = _view.next;
                          break;
                        case CalendarViewType.month:
                          _view = _view.nextYear;
                          break;
                        case CalendarViewType.year:
                          _yearSelectStart += 16;
                          break;
                      }
                    });
                  },
                  child: const Icon(LucideIcons.arrowRight).iconXSmall(),
                ),
              ],
            ),
            Gap(theme.density.baseGap * theme.scaling * 2),
            switch (_viewType) {
              CalendarViewType.year => YearCalendar(
                value: _view.year,
                yearSelectStart: _yearSelectStart,
                calendarValue: _value,
                now: now,
                onChanged: (year) {
                  setState(() {
                    _view = _view.copyWith(year: () => year);
                    _viewType = CalendarViewType.month;
                  });
                },
              ),
              CalendarViewType.month => MonthCalendar(
                value: _view,
                calendarValue: _value,
                now: now,
                onChanged: (view) {
                  setState(() {
                    _view = view;
                    _viewType = CalendarViewType.date;
                  });
                },
              ),
              CalendarViewType.date => Calendar(
                value: _value,
                view: _view,
                now: now,
                selectionMode: CalendarSelectionMode.single,
                onChanged: (value) {
                  setState(() => _value = value);
                  widget.onChanged(
                    value == null ? null : (value as SingleCalendarValue).date,
                  );
                },
              ),
            },
          ],
        ),
      ),
    );
  }
}

/// A segmented, typed date entry. Wraps shadcn_flutter's `DateInput`
/// machinery, but fixes a padding bug (see [_BofDateInput]'s doc comment).
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
///
/// [trailingIcon] replaces the calendar button's icon.
///
/// The segmented surface is drawn by shadcn_flutter from theme colors, so the
/// appearance options are applied by scoping the theme around the field (see
/// [_styleSegmentedInput]); the calendar popup keeps the surrounding theme.
///
/// Fills the width its parent allows, like `BoF.textField`; wrap it in a
/// `SizedBox` for a fixed width.
Widget bofDateInputField({
  Key? key,
  DateTime? initialValue,
  DatePickerController? controller,
  bool enabled = true,
  Widget? trailingIcon,
  ValueChanged<DateTime?>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    key: key,
    width: double.infinity,
    child: _styleSegmentedInput(
      _BofDateInput(
        initialValue: initialValue,
        controller: controller,
        enabled: enabled,
        trailingIcon: trailingIcon,
        onChanged: onChanged,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
    ),
  );
}

/// Applies the shared field appearance options to shadcn_flutter's segmented
/// `FormattedObjectInput` surface, which has no styling parameters of its own.
///
/// [borderRadius] is matched through the theme radius, using its top-left
/// corner; [padding] goes through `FormattedInputTheme`.
Widget _styleSegmentedInput(
  Widget child, {
  required Color? backgroundColor,
  required Color? foregroundColor,
  required double? fontSize,
  required FontWeight? fontWeight,
  required TextStyle? style,
  required BorderRadiusGeometry? borderRadius,
  required Color? borderColor,
  required double? borderWidth,
  required EdgeInsetsGeometry? padding,
}) {
  final surface = BofScopedSurface(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    fontSize: fontSize,
    fontWeight: fontWeight,
    style: style,
    borderRadius: borderRadius,
    borderColor: borderColor,
    borderWidth: borderWidth,
    child: child,
  );
  if (padding == null) return surface;
  return Builder(
    builder: (context) {
      final inputTheme = ComponentTheme.maybeOf<FormattedInputTheme>(context);
      return ComponentTheme<FormattedInputTheme>(
        data: (inputTheme ?? const FormattedInputTheme()).copyWith(
          padding: () => padding,
        ),
        child: surface,
      );
    },
  );
}

/// Replacement for shadcn_flutter's `DateInput`.
///
/// `DateInput` converts the selected date to its segmented text parts with
/// plain `int.toString()` (see its private `_convertFromDateTime`), which
/// doesn't zero-pad single-digit months/days. Since each segment is a
/// fixed-width 2-character slot, a value like day 7 renders as "7" plus a
/// blank/placeholder second character rather than "07" — visible as
/// `9_/7_/2026` for September 7th. This reimplements the same widget using
/// the same public `FormattedObjectInput` machinery `DateInput` itself uses,
/// with the conversion fixed to zero-pad, and reuses [_BofCalendarView] for
/// the embedded picker so it also gets today's outline.
class _BofDateInput extends StatefulWidget with ControlledComponent<DateTime?> {
  @override
  final DateTime? initialValue;
  @override
  final ValueChanged<DateTime?>? onChanged;
  @override
  final bool enabled;
  @override
  final DatePickerController? controller;
  final Widget? trailingIcon;

  const _BofDateInput({
    this.controller,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.trailingIcon,
  });

  @override
  State<_BofDateInput> createState() => _BofDateInputState();
}

class _BofDateInputState extends State<_BofDateInput> {
  late ComponentController<NullableDate> _controller;

  NullableDate _convertToDateTime(List<String?> values) {
    final datePartsOrder = ShadcnLocalizations.of(context).datePartsOrder;
    final parts = <DatePart, String?>{};
    for (var i = 0; i < values.length; i++) {
      parts[datePartsOrder[i]] = values[i];
    }
    int? parse(String? s) => s == null || s.isEmpty ? null : int.tryParse(s);
    return NullableDate(
      year: parse(parts[DatePart.year]),
      month: parse(parts[DatePart.month]),
      day: parse(parts[DatePart.day]),
    );
  }

  List<String?> _convertFromDateTime(NullableDate? value) {
    final datePartsOrder = ShadcnLocalizations.of(context).datePartsOrder;
    if (value == null) {
      return datePartsOrder.map((part) => null).toList();
    }
    final validDateTime = value.getDateTime(
      defaultYear: datePartsOrder.contains(DatePart.year) ? null : 0,
      defaultMonth: datePartsOrder.contains(DatePart.month) ? null : 1,
      defaultDay: datePartsOrder.contains(DatePart.day) ? null : 1,
    );
    if (validDateTime == null) {
      return datePartsOrder.map((part) => null).toList();
    }
    return datePartsOrder.map((part) {
      switch (part) {
        case DatePart.year:
          return validDateTime.year.toString().padLeft(4, '0');
        case DatePart.month:
          return validDateTime.month.toString().padLeft(2, '0');
        case DatePart.day:
          return validDateTime.day.toString().padLeft(2, '0');
      }
    }).toList();
  }

  double _getWidth(DatePart part) {
    switch (part) {
      case DatePart.year:
        return 60;
      case DatePart.month:
      case DatePart.day:
        return 40;
    }
  }

  int _getLength(DatePart part) {
    switch (part) {
      case DatePart.year:
        return 4;
      case DatePart.month:
      case DatePart.day:
        return 2;
    }
  }

  Widget _getPlaceholder(DatePart part) {
    return Text(ShadcnLocalizations.of(context).getDatePartAbbreviation(part));
  }

  NullableDate _convertToNullableDate(DateTime? value) {
    if (value == null) return NullableDate();
    return NullableDate(year: value.year, month: value.month, day: value.day);
  }

  DateTime? _convertFromNullableDate(NullableDate value) => value.getDateTime();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller == null
        ? ComponentValueController<NullableDate>(
            _convertToNullableDate(widget.initialValue),
          )
        : ConvertedController<DateTime?, NullableDate>(
            widget.controller!,
            BiDirectionalConvert(
              _convertToNullableDate,
              _convertFromNullableDate,
            ),
          );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datePartsOrder = ShadcnLocalizations.of(context).datePartsOrder;
    return FormattedObjectInput<NullableDate>(
      popupBuilder: (context, controller) {
        return BofScopedSurface.restore(
          context,
          SurfaceCard(
            child: _BofCalendarView(
              initialValue: controller.value?.nullableDate,
              onChanged: (date) {
                controller.value = NullableDate(
                  year: date?.year,
                  month: date?.month,
                  day: date?.day,
                );
              },
            ),
          ),
        );
      },
      popoverIcon: widget.trailingIcon ?? const Icon(LucideIcons.calendarDays),
      converter: BiDirectionalConvert(_convertFromDateTime, _convertToDateTime),
      controller: _controller,
      initialValue: _convertToNullableDate(widget.initialValue),
      enabled: widget.enabled,
      onChanged: (value) {
        widget.onChanged?.call(
          value == null ? null : _convertFromNullableDate(value),
        );
      },
      parts: datePartsOrder
          .map(
            (part) => InputPart.editable(
              length: _getLength(part),
              width: _getWidth(part),
              placeholder: _getPlaceholder(part),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          )
          .joinSeparator(const InputPart.static('/'))
          .toList(),
    );
  }
}

/// A popover/dialog time picker, matching shadcn_flutter's
/// `ControlledTimePicker`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Defaults to [PromptMode.popover] for the same reason as
/// [bofDatePickerField]. Pass `mode: PromptMode.dialog` to opt back into the
/// `AlertDialog` presentation.
///
/// [trailingIcon] replaces the trigger's clock icon. The appearance options
/// restyle the trigger button only; the picker it opens keeps its themed look.
/// [foregroundColor] also tints the trigger's icon, and [foregroundColor]/
/// [fontSize]/[fontWeight] override the matching properties of [style].
///
/// Fills the width its parent allows, like `BoF.textField`; wrap it in a
/// `SizedBox` for a fixed width.
Widget bofTimePickerField({
  Key? key,
  TimeOfDay? initialValue,
  TimePickerController? controller,
  bool showSeconds = false,
  bool enabled = true,
  PromptMode mode = PromptMode.popover,
  EdgeInsetsGeometry? popoverPadding,
  Widget? dialogTitle,
  Widget? trailingIcon,
  ValueChanged<TimeOfDay?>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  // Mirrors shadcn_flutter's `ControlledTimePicker`/`TimePicker`, which
  // hardcode the trigger's trailing icon.
  return SizedBox(
    key: key,
    width: double.infinity,
    child: ControlledComponentAdapter<TimeOfDay?>(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      builder: (context, data) {
        final localizations = ShadcnLocalizations.of(context);
        final use24HourFormat =
            ComponentTheme.maybeOf<TimePickerTheme>(context)?.use24HourFormat ??
            MediaQuery.of(context).alwaysUse24HourFormat;
        return BofTriggerStyle(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          style: style,
          borderRadius: borderRadius,
          borderColor: borderColor,
          borderWidth: borderWidth,
          padding: padding,
          child: ObjectFormField<TimeOfDay>(
            value: data.value,
            onChanged: data.onChanged,
            enabled: data.enabled,
            placeholder: Text(localizations.placeholderTimePicker),
            trailing: trailingIcon ?? const Icon(LucideIcons.clock),
            mode: mode,
            popoverPadding: popoverPadding,
            dialogTitle: dialogTitle,
            builder: (context, value) => Text(
              localizations.formatTimeOfDay(
                value,
                use24HourFormat: use24HourFormat,
                showSeconds: showSeconds,
              ),
            ),
            editorBuilder: (context, handler) => TimePickerDialog(
              initialValue: handler.value,
              onChanged: (value) => handler.value = value,
              use24HourFormat: use24HourFormat,
              showSeconds: showSeconds,
            ),
          ),
        );
      },
    ),
  );
}

/// A segmented, typed time entry. Wraps shadcn_flutter's `TimeInput`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Appearance options are applied the same way as [bofDateInputField]'s.
///
/// Fills the width its parent allows, like `BoF.textField`; wrap it in a
/// `SizedBox` for a fixed width.
Widget bofTimeInputField({
  Key? key,
  TimeOfDay? initialValue,
  ComponentController<TimeOfDay?>? controller,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<TimeOfDay?>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    key: key,
    width: double.infinity,
    child: _styleSegmentedInput(
      TimeInput(
        initialValue: initialValue,
        controller: controller,
        enabled: enabled,
        showSeconds: showSeconds,
        onChanged: onChanged,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
    ),
  );
}

/// A popover/dialog duration picker, matching shadcn_flutter's
/// `DurationPicker`.
///
/// `DurationPicker` has no `initialValue`/controller support of its own (it's
/// a plain `value`-driven widget), so this uses a small internal adapter that
/// owns the current value. Pass [controller] to update the value
/// programmatically; when provided it takes precedence over [initialValue].
///
/// [trailingIcon] replaces the trigger's clock icon. The appearance options
/// restyle the trigger button only; the picker it opens keeps its themed look.
/// [foregroundColor] also tints the trigger's icon, and [foregroundColor]/
/// [fontSize]/[fontWeight] override the matching properties of [style].
///
/// Fills the width its parent allows, like `BoF.textField`; wrap it in a
/// `SizedBox` for a fixed width.
Widget bofDurationPickerField({
  Key? key,
  Duration initialValue = Duration.zero,
  DurationPickerController? controller,
  bool enabled = true,
  Widget? trailingIcon,
  ValueChanged<Duration?>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    key: key,
    width: double.infinity,
    child: BofTriggerStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
      child: _DurationPickerAdapter(
        initialValue: initialValue,
        controller: controller,
        enabled: enabled,
        trailingIcon: trailingIcon,
        onChanged: onChanged,
      ),
    ),
  );
}

class _DurationPickerAdapter extends StatefulWidget {
  final Duration initialValue;
  final DurationPickerController? controller;
  final bool enabled;
  final Widget? trailingIcon;
  final ValueChanged<Duration?>? onChanged;

  const _DurationPickerAdapter({
    required this.initialValue,
    this.controller,
    required this.enabled,
    this.trailingIcon,
    this.onChanged,
  });

  @override
  State<_DurationPickerAdapter> createState() => _DurationPickerAdapterState();
}

class _DurationPickerAdapterState extends State<_DurationPickerAdapter> {
  late Duration _value = widget.controller?.value ?? widget.initialValue;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _DurationPickerAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() => _value = widget.controller!.value ?? Duration.zero);
  }

  void _handleChanged(Duration? duration) {
    widget.onChanged?.call(duration);
    final controller = widget.controller;
    if (controller != null) {
      controller.value = duration;
    } else {
      setState(() => _value = duration ?? Duration.zero);
    }
  }

  // Mirrors shadcn_flutter's `DurationPicker`, which hardcodes the trigger's
  // trailing icon.
  @override
  Widget build(BuildContext context) {
    final localizations = ShadcnLocalizations.of(context);
    return ObjectFormField<Duration>(
      value: _value,
      onChanged: _handleChanged,
      enabled: widget.enabled,
      placeholder: Text(localizations.placeholderDurationPicker),
      trailing: widget.trailingIcon ?? const Icon(LucideIcons.clock),
      builder: (context, value) => Text(localizations.formatDuration(value)),
      editorBuilder: (context, handler) => DurationPickerDialog(
        initialValue: handler.value,
        onChanged: (value) => handler.value = value,
      ),
    );
  }
}

/// A segmented, typed duration entry. Wraps shadcn_flutter's `DurationInput`.
///
/// Pass [controller] to update the value programmatically; when provided it
/// takes precedence over [initialValue].
///
/// Appearance options are applied the same way as [bofDateInputField]'s.
///
/// Fills the width its parent allows, like `BoF.textField`; wrap it in a
/// `SizedBox` for a fixed width.
Widget bofDurationInputField({
  Key? key,
  Duration? initialValue,
  ComponentController<Duration?>? controller,
  bool showSeconds = false,
  bool enabled = true,
  ValueChanged<Duration?>? onChanged,
  Color? backgroundColor,
  Color? foregroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  TextStyle? style,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  EdgeInsetsGeometry? padding,
}) {
  return SizedBox(
    key: key,
    width: double.infinity,
    child: _styleSegmentedInput(
      DurationInput(
        initialValue: initialValue,
        controller: controller,
        enabled: enabled,
        showSeconds: showSeconds,
        onChanged: onChanged,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      style: style,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
    ),
  );
}
