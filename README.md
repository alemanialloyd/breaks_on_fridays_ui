# breaks_on_fridays_ui

A thin, opinionated layer of styled widgets on top of [shadcn_flutter],
accessed through a single `BoF` entry point.

## Glossary

**Core**

- [BoF.text](#boftext)
- [BoF.button](#bofbutton)
- [BoF.container](#bofcontainer)
- [BoF.alertDialog](#bofalertdialog)

**Display & layout**

- [BoF.avatar](#bofavatar)
- [BoF.badge](#bofbadge)
- [BoF.chip](#bofchip)
- [BoF.divider](#bofdivider)
- [BoF.verticalDivider](#bofverticaldivider)
- [BoF.tooltip](#boftooltip)
- [BoF.popover](#bofpopover)
- [BoF.progress](#bofprogress)
- [BoF.circularProgress](#bofcircularprogress)
- [BoF.skeleton](#bofskeleton)
- [BoF.alert](#bofalert)
- [BoF.accordion](#bofaccordion)
- [BoF.card](#bofcard)
- [BoF.toast](#boftoast)
- [BoF.dropdownMenu](#bofdropdownmenu)

**Forms**

- [BoF.form](#bofform)
- [BoF.textField](#boftextfield) (`BoFTextField`)
- [BoF.textAreaField](#boftextareafield) (`BoFTextAreaField`)
- [BoF.numberField](#bofnumberfield) (`BoFNumberField`)
- [BoF.checkboxField](#bofcheckboxfield) (`BoFCheckboxField`)
- [BoF.switchField](#bofswitchfield) (`BoFSwitchField`)
- [BoF.radioGroupField](#bofradiogroupfield) (`BoFRadioGroupField`)
- [BoF.selectField](#bofselectfield) (`BoFSelectField`)
- [BoF.multiSelectField](#bofmultiselectfield) (`BoFMultiSelectField`)
- [BoF.multipleChoiceField](#bofmultiplechoicefield) (`BoFMultipleChoiceField`)
- [BoF.multipleAnswerField](#bofmultipleanswerfield) (`BoFMultipleAnswerField`)
- [BoF.datePickerField](#bofdatepickerfield) (`BoFDatePickerField`)
- [BoF.dateInputField](#bofdateinputfield) (`BoFDateInputField`)
- [BoF.timePickerField](#boftimepickerfield) (`BoFTimePickerField`)
- [BoF.timeInputField](#boftimeinputfield) (`BoFTimeInputField`)
- [BoF.durationPickerField](#bofdurationpickerfield) (`BoFDurationPickerField`)
- [BoF.durationInputField](#bofdurationinputfield) (`BoFDurationInputField`)
- [BoF.colorField](#bofcolorfield) (`BoFColorField`)
- [BoF.phoneField](#bofphonefield) (`BoFPhoneField`)
- [BoF.sliderField](#bofsliderfield) (`BoFSliderField`)
- [BoF.starRatingField](#bofstarratingfield) (`BoFStarRatingField`)
- [BoF.otpField](#bofotpfield) (`BoFOtpField`)
- [BoF.autoCompleteField](#bofautocompletefield) (`BoFAutoCompleteField`)
- [BoF.chipInputField](#bofchipinputfield) (`BoFChipInputField`)

## Getting started

Add the package, then wrap your app in shadcn_flutter's `ShadcnApp` as usual
(re-exported by this package, so `import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';`
is all you need):

```dart
import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

void main() => runApp(
      ShadcnApp(
        home: Scaffold(child: BoF.text('Hello')),
      ),
    );
```

## Core

### BoF.text

Returns a plain `Text` widget, so every shadcn_flutter typography modifier
chains directly onto it:

```dart
BoF.text('Title').h1
BoF.text('Section').h3
BoF.text('Body copy').muted
BoF.text('Emphasis').bold.large
```

### BoF.button

`BoF.button(label, {type, icon, iconPosition, onPressed, ...})` mirrors
shadcn_flutter's `Button` variants through `BoFButtonType`:

```dart
BoF.button('Save', onPressed: submit); // BoFButtonType.primary (default)
BoF.button('Cancel', type: BoFButtonType.outline, onPressed: cancel);
BoF.button('Delete', type: BoFButtonType.destructive, onPressed: delete);
```

`BoFButtonType` values: `primary`, `secondary`, `outline`, `ghost`, `link`,
`text`, `destructive`. All of `Button`'s other parameters (`size`, `density`,
`shape`, focus/hover/tap/long-press callbacks, etc.) are exposed too.

`label` and `icon` are both optional — pass just one for a text-only or
icon-only button, or both and position the icon with `iconPosition`:

```dart
BoF.button(null, icon: const Icon(Icons.add), onPressed: create); // icon-only
BoF.button('Save', onPressed: submit); // label-only
BoF.button(
  'Next',
  icon: const Icon(Icons.arrow_forward),
  iconPosition: BoFIconPosition.right, // left (default), right, top, bottom
  onPressed: next,
);
```

`left`/`right` use the button's native leading/trailing slots; `top`/`bottom`
stack the icon and label in a column. Icon-only buttons default to
`ButtonDensity.icon` padding unless `density` is set explicitly.

### BoF.container

`BoF.container(child, {type, ...})` wraps shadcn_flutter's `OutlinedContainer`
and colors it from the theme based on `BoFContainerType`:

```dart
BoF.container(BoF.text('Card body'), type: BoFContainerType.outline); // default
BoF.container(BoF.text('Highlighted'), type: BoFContainerType.filled);
BoF.container(BoF.text('Danger'), type: BoFContainerType.destructive);
```

`BoFContainerType` values: `filled`, `secondary`, `outline`, `ghost`,
`destructive`. Explicit `backgroundColor`/`borderColor`/`borderWidth` always
override the type-based default.

See also [BoF.card](#bofcard) for a container tuned specifically for content
cards (its own fill/shadow/padding defaults).

### BoF.alertDialog

`BoF.alertDialog(context, {...})` shows shadcn_flutter's `AlertDialog` and
returns a `Future` that resolves when it closes. The common case is plain
strings:

```dart
final confirmed = await BoF.alertDialog(
  context,
  title: 'Delete item',
  content: 'This action cannot be undone.',
  positiveText: 'Delete',
  negativeText: 'Cancel',
  positiveType: BoFButtonType.destructive,
);
if (confirmed == true) { ... }
```

By default, the positive button pops `true` and the negative button pops
`false`; pass `onPositive`/`onNegative` to run your own logic instead (you're
then responsible for popping, e.g. via `Navigator.pop(context, ...)`).

For anything the string params can't express, pass a widget instead:
`titleWidget`/`contentWidget` override `title`/`content`, and `actions`
overrides `positiveText`/`negativeText` entirely with your own button list.
Button styling for the default positive/negative buttons reuses
`BoFButtonType` — the same enum `BoF.button` uses — via
`positiveType`/`negativeType` (defaulting to `primary`/`outline`), rather
than introducing a separate enum just for the dialog:

```dart
BoF.alertDialog(
  context,
  titleWidget: Row(children: [Icon(Icons.warning), BoF.text('Careful')]),
  contentWidget: BoF.text('Custom content widget').muted,
  actions: [
    BoF.button('Got it', onPressed: () => Navigator.pop(context)),
  ],
);
```

## Display & layout

Thin wrappers over more of shadcn_flutter's components, each exposing its
key params plus a way to override styling.

### BoF.avatar

```dart
BoF.avatar(initials: 'JD'); // initials only
BoF.avatar(initials: 'JD', photoUrl: user.photoUrl); // falls back to initials on load failure
```

`badge` takes an `AvatarWidget` (typically `AvatarBadge(...)`, from
shadcn_flutter directly) for a status dot/counter overlay, positioned via
`badgeAlignment`/`badgeGap`.

### BoF.badge

```dart
BoF.badge(BoF.text('New'), type: BoFBadgeType.destructive);
```

`BoFBadgeType` values: `primary`, `secondary`, `outline`, `destructive`.
Accepts an `AbstractButtonStyle? style` to fully override its appearance —
the same escape-hatch shape as `BoF.button`.

### BoF.chip

```dart
BoF.chip(
  BoF.text('Filter'),
  trailing: BoF.chipButton(child: const Icon(Icons.close), onPressed: remove),
);
```

`BoF.chipButton` is a small button meant for a chip's `leading`/`trailing`
slot. `BoF.chip` also accepts `AbstractButtonStyle? style`.

### BoF.divider

```dart
BoF.divider(); // plain horizontal rule
BoF.divider(child: BoF.text('OR')); // with a centered label
```

### BoF.verticalDivider

```dart
BoF.verticalDivider();
```

Same shape as `BoF.divider`, rotated — `width` instead of `height`.

### BoF.tooltip

```dart
BoF.tooltip(BoF.button('Hover me', onPressed: () {}), message: 'Tooltip text');
```

Pass `builder` instead of `message` for a fully custom tooltip widget
(rebuilt on each show).

### BoF.popover

```dart
BoF.popover(icon, content: BoF.text('Popover content')); // shows on hover/long-press
```

Wraps shadcn_flutter's `HoverCard`. Pass `builder` instead of `content` for a
fully custom, rebuilt-per-show popover.

### BoF.progress

```dart
BoF.progress(progress: 0.65); // determinate
BoF.progress(); // progress: null -> indeterminate
```

Animates towards its value by default; pass `disableAnimation: true` to snap
instantly.

### BoF.circularProgress

```dart
BoF.circularProgress(value: 0.65); // determinate
BoF.circularProgress(); // value: null -> spinner
```

Same animate/`animated: false` behavior as `BoF.progress`.

### BoF.skeleton

```dart
BoF.skeleton(BoF.text('Loading...'), enabled: isLoading);
```

Wraps any widget with shadcn_flutter's `Skeletonizer`; toggle `enabled`
based on your loading state.

### BoF.alert

```dart
BoF.alert(title: BoF.text('Heads up'), content: BoF.text('Something happened.'));
BoF.alert(title: BoF.text('Error'), destructive: true);
```

### BoF.accordion

```dart
BoF.accordion(items: [
  BoFAccordionItem(title: BoF.text('Section 1'), content: BoF.text('Body 1')),
  BoFAccordionItem(title: BoF.text('Section 2'), content: BoF.text('Body 2')),
]);
```

Takes `List<BoFAccordionItem>` (`title`, `content`, `expanded`); only one
item should set `expanded: true`.

### BoF.card

```dart
BoF.card(BoF.text('Card body'), filled: true);
```

Distinct from [BoF.container](#bofcontainer): `Card` has its own
fill/shadow/padding defaults tuned for content cards (`filled`, `fillColor`,
`boxShadow`, etc.), whereas `BoF.container` is a bare outlined/filled
surface styled via `BoFContainerType`.

### BoF.toast

```dart
BoF.toast(context, title: 'Saved', message: 'Your changes were saved.');
```

Shows a notification and returns a `ToastOverlay` (`.isShowing`, `.close()`).
Its content defaults to [BoF.alert](#bofalert) styling
(`title`/`message`/`destructive`) with a close button when `dismissible`
(the default); pass `content` or `builder` for a fully custom toast body.
`location` defaults to `ToastLocation.bottomRight`. Requires a `ToastLayer`
ancestor — shadcn_flutter's `ShadcnApp` already provides one.

### BoF.dropdownMenu

```dart
BoF.dropdownMenu(context, items: [
  BoFMenuItem(child: BoF.text('Edit'), onPressed: edit),
  BoFMenuItem(child: BoF.text('Delete'), onPressed: delete),
]);
```

Shows a menu anchored near `context` — typically opened from a
[BoF.button](#bofbutton)'s `onPressed`. Each `BoFMenuItem` takes
`child`/`leading`/`trailing`/`onPressed`/`enabled`, and an optional
`subMenu: List<BoFMenuItem>` for nested menus.

## Forms

`BoF.form` takes a list of **field specs** — plain data describing what each
field is — and renders the matching shadcn_flutter widget itself. There is no
`TextEditingController` (or any other controller) to create, wire up, or
dispose: every field owns its value internally, and the form's `onSubmit`
callback receives the finished values as a `Map<String, Object?>`.

Every field kind is *also* available as a plain standalone `BoF.xxxField`
widget — the same rendering logic `BoF.form` uses, without the
form/controller/validation machinery. Each is named to match its
`BoFXxxField` form-spec counterpart one-to-one, since they render the exact
same widget. Reach for the standalone version when you just need one value
(a search box, a filter toggle) and don't want the overhead of a form for
it; it takes `initialValue`/`onChanged`/`enabled` directly, with no
`label`/`hint`/`validator` (add those yourself if needed, or use `BoF.form`
with a single field).

### BoF.form

```dart
BoF.form(
  [
    BoFTextField(
      name: 'email',
      label: BoF.text('Email'),
      validator: const EmailValidator(),
    ),
    BoFTextField(
      name: 'password',
      label: BoF.text('Password'),
      obscureText: true,
      validator: const NotEmptyValidator() & const LengthValidator(min: 8),
    ),
    BoFCheckboxField(
      name: 'agree',
      label: BoF.text('I agree to the terms'),
      validator: const NonNullValidator<CheckboxState>(),
    ),
  ],
  onSubmit: (values) {
    print(values['email']);
    print(values['password']);
  },
)
```

#### Reading/driving the form like a ref

Pass a `BoFFormController` to read live values, listen for changes, or
trigger validation/submission programmatically — this is the "ref" for the
whole form:

```dart
final controller = BoFFormController();

BoF.form(fields, controller: controller, onSubmit: save);

// elsewhere:
controller.value<String>('email');   // current value, or null
controller.values;                   // Map<String, Object?> snapshot
controller.errorOf('email');         // current ValidationResult?, or null
controller.isValid;                  // true if no field currently has an error
await controller.submit();           // validates every field, then calls onSubmit if valid
controller.reset();                  // clears every field back to its initial value
controller.addListener(() { ... });  // rebuild on any value/error change
```

`BoFFormController` is the "ref" for the form's *data* (values, errors,
submit). If you also need the form's *widget location* — e.g. to scroll to
it when validation fails — pass a `GlobalKey` too and read
`key.currentContext` once the form has mounted:

```dart
final formKey = GlobalKey();
final controller = BoFFormController();

BoF.form(
  fields,
  key: formKey,
  controller: controller,
  onSubmit: save,
);

// e.g. from a submit button outside the form:
BoF.button('Submit', onPressed: () async {
  await controller.submit();
  if (!controller.isValid) {
    Scrollable.ensureVisible(formKey.currentContext!);
  }
});
```

#### Validation

Validators are shadcn_flutter's `Validator<T>` — composable Zod-style with
`&` (AND), `|` (OR) and `~`/unary `-` (NOT):

```dart
validator: const NotEmptyValidator() & const LengthValidator(min: 8, max: 64)
validator: const EmailValidator() | const URLValidator()
```

Built-in validators include `NonNullValidator<T>`, `NotEmptyValidator`,
`LengthValidator`, `SafePasswordValidator`, `MinValidator<T>`,
`MaxValidator<T>`, `RangeValidator<T>`, `RegexValidator`, `EmailValidator`,
`URLValidator`, or write your own by extending `Validator<T>`.

Validation runs on every change and again on submit; `BoF.form` won't call
`onSubmit` unless every field currently passes.

#### A larger example

This one also wires up a `GlobalKey` alongside the `BoFFormController`, with
a submit button living *outside* the form that drives both: the controller
runs validation/submission, and the key locates the form's `BuildContext` so
it can be scrolled into view if validation fails.

```dart
final formKey = GlobalKey();
final controller = BoFFormController();

Column(
  children: [
    BoF.form(
      [
        BoFTextField(name: 'name', label: BoF.text('Full name')),
        BoFRadioGroupField<String>(
          name: 'plan',
          label: BoF.text('Plan'),
          options: const [
            BoFOption(value: 'free', label: Text('Free')),
            BoFOption(value: 'pro', label: Text('Pro')),
          ],
          initialValue: 'free',
        ),
        BoFSelectField<String>(
          name: 'country',
          label: BoF.text('Country'),
          options: const [
            BoFOption(value: 'us', label: Text('United States')),
            BoFOption(value: 'ph', label: Text('Philippines')),
          ],
        ),
        BoFDatePickerField(name: 'startDate', label: BoF.text('Start date')),
        BoFSliderField(name: 'budget', label: BoF.text('Monthly budget'), min: 0, max: 1000),
      ],
      key: formKey,
      controller: controller,
      onSubmit: (values) => print(values),
    ),
    BoF.button('Submit', onPressed: () async {
      await controller.submit();
      if (!controller.isValid) {
        Scrollable.ensureVisible(formKey.currentContext!);
      }
    }),
  ],
)
```

Every field spec needs `name` (used as the key in the submitted values map),
`label`, and optionally `hint` and `validator`. Options-based fields
(`BoFRadioGroupField`, `BoFSelectField`, `BoFMultiSelectField`,
`BoFMultipleChoiceField`, `BoFMultipleAnswerField`) take a
`List<BoFOption<T>>`, where `BoFOption(value: ..., label: Text('...'))`.

### BoF.textField

`BoFTextField` — value type `String` — wraps `TextField`.

```dart
BoF.textField(placeholder: Text('Search'), onChanged: (v) => print(v));
```

Params: `obscureText`, `keyboardType`, `maxLines`.

### BoF.textAreaField

`BoFTextAreaField` — value type `String` — wraps `TextArea`.

```dart
BoF.textAreaField(onChanged: (v) => print(v));
```

Params: `minHeight`, `maxHeight`.

### BoF.numberField

`BoFNumberField` — value type `num` — wraps `TextField` with a numeric
keyboard.

```dart
BoF.numberField(onChanged: (v) => print(v));
```

shadcn_flutter has no dedicated number-input widget upstream; this parses
the typed text to `num`.

### BoF.checkboxField

`BoFCheckboxField` — value type `CheckboxState` — wraps `ControlledCheckbox`.

```dart
BoF.checkboxField(onChanged: (v) => print(v));
```

Tri-state: `checked` / `unchecked` / `indeterminate`.

### BoF.switchField

`BoFSwitchField` — value type `bool` — wraps `ControlledSwitch`.

```dart
BoF.switchField(onChanged: (v) => print(v));
```

### BoF.radioGroupField

`BoFRadioGroupField<T>` — value type `T` — wraps `ControlledRadioGroup` +
`RadioItem`/`RadioCard`.

```dart
BoF.radioGroupField<String>(
  options: const [
    BoFOption(value: 'free', label: Text('Free')),
    BoFOption(value: 'pro', label: Text('Pro')),
  ],
  onChanged: (v) => print(v),
);
```

Set `card: true` for card-style items instead of plain radio items.

### BoF.selectField

`BoFSelectField<T>` — value type `T` — wraps `ControlledSelect`. Dropdown,
single selection.

```dart
BoF.selectField<String>(
  options: const [BoFOption(value: 'us', label: Text('United States'))],
  onChanged: (v) => print(v),
);
```

### BoF.multiSelectField

`BoFMultiSelectField<T>` — value type `Iterable<T>` — wraps
`ControlledMultiSelect`. Dropdown, multiple selection.

```dart
BoF.multiSelectField<String>(
  options: const [BoFOption(value: 'us', label: Text('United States'))],
  onChanged: (v) => print(v),
);
```

### BoF.multipleChoiceField

`BoFMultipleChoiceField<T>` — value type `T` — wraps
`ControlledMultipleChoice`. Inline tappable chips, single selection.

```dart
BoF.multipleChoiceField<String>(
  options: const [BoFOption(value: 's', label: Text('S'))],
  onChanged: (v) => print(v),
);
```

### BoF.multipleAnswerField

`BoFMultipleAnswerField<T>` — value type `Iterable<T>` — wraps
`ControlledMultipleAnswer`. Inline tappable chips, multiple selection.

```dart
BoF.multipleAnswerField<String>(
  options: const [BoFOption(value: 's', label: Text('S'))],
  onChanged: (v) => print(v),
);
```

### BoF.datePickerField

`BoFDatePickerField` — value type `DateTime` — wraps `ControlledDatePicker`.
Popover/dialog calendar.

```dart
BoF.datePickerField(onChanged: (v) => print(v));
```

### BoF.dateInputField

`BoFDateInputField` — value type `DateTime` — wraps `DateInput`. Segmented
typed entry (`mm/dd/yyyy`-style).

```dart
BoF.dateInputField(onChanged: (v) => print(v));
```

### BoF.timePickerField

`BoFTimePickerField` — value type `TimeOfDay` — wraps `ControlledTimePicker`.
Popover/dialog.

```dart
BoF.timePickerField(onChanged: (v) => print(v));
```

### BoF.timeInputField

`BoFTimeInputField` — value type `TimeOfDay` — wraps `TimeInput`. Segmented
typed entry.

```dart
BoF.timeInputField(onChanged: (v) => print(v));
```

### BoF.durationPickerField

`BoFDurationPickerField` — value type `Duration` — wraps `DurationPicker`.
Popover/dialog.

```dart
BoF.durationPickerField(onChanged: (v) => print(v));
```

### BoF.durationInputField

`BoFDurationInputField` — value type `Duration` — wraps `DurationInput`.
Segmented typed entry.

```dart
BoF.durationInputField(onChanged: (v) => print(v));
```

### BoF.colorField

`BoFColorField` — value type `Color` — wraps `ControlledColorInput`.

```dart
BoF.colorField(onChanged: (v) => print(v));
```

Converts to/from shadcn's `ColorDerivative` internally, so callers only ever
deal with plain `Color`.

### BoF.phoneField

`BoFPhoneField` — value type `PhoneNumber` — wraps `PhoneInput`.

```dart
BoF.phoneField(onChanged: (v) => print(v));
```

The upstream widget has no `enabled` param, so this can't be disabled.

### BoF.sliderField

`BoFSliderField` — value type `SliderValue` — wraps `ControlledSlider`.

```dart
BoF.sliderField(min: 0, max: 1000, onChanged: (v) => print(v));
```

Params: `min`, `max`, `divisions`.

### BoF.starRatingField

`BoFStarRatingField` — value type `double` — wraps `ControlledStarRating`.

```dart
BoF.starRatingField(onChanged: (v) => print(v));
```

Params: `max`, `step`.

### BoF.otpField

`BoFOtpField` — value type `List<int?>` — wraps `InputOTP`.

```dart
BoF.otpField(length: 6, onChanged: (v) => print(v));
```

Requires `length`. The upstream widget has no `enabled` param, so this can't
be disabled.

### BoF.autoCompleteField

`BoFAutoCompleteField` — value type `String` — wraps `AutoComplete` +
`TextField`.

```dart
BoF.autoCompleteField(
  suggestions: const ['Alice', 'Bob', 'Charlie'],
  onChanged: (v) => print(v),
);
```

Requires `suggestions`.

### BoF.chipInputField

`BoFChipInputField<T>` — value type `List<T>` — wraps `ChipInput`.

```dart
BoF.chipInputField<String>(
  chipBuilder: (context, value) => BoF.chip(BoF.text(value)),
  onChipSubmitted: (text) => text,
  onChanged: (v) => print(v),
);
```

Requires `chipBuilder` and `onChipSubmitted` (parses typed text into a chip).
