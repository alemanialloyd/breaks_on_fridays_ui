# breaks_on_fridays_ui

A thin, opinionated layer of styled widgets on top of [shadcn_flutter],
accessed through a single `BoF` entry point.

## Glossary

- [Custom styling](#custom-styling)
- [Conditional styling](#conditional-styling)

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
  - [Laying out fields](#laying-out-fields) (`BoFRow`, `BoFColumn`, `BoFCustom`)
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

## Custom styling

Most `BoF.*` widgets accept direct `backgroundColor`/`foregroundColor`/
`fontSize`/`borderRadius` params (plus a few extras per widget — border
color/width, font weight, padding, track colors, etc.) to override individual
pieces of their default styling, without having to build a whole
shadcn_flutter theme object yourself:

```dart
BoF.button(
  'Custom',
  onPressed: () {},
  backgroundColor: Colors.purple,
  foregroundColor: Colors.white,
  fontSize: 16,
  borderRadius: BorderRadius.circular(20),
);

BoF.textField(
  placeholder: const Text('Search'),
  backgroundColor: Colors.blue.withValues(alpha: 0.08),
  foregroundColor: Colors.blue[900],
  borderRadius: BorderRadius.circular(16),
  onChanged: (v) {},
);
```

Two widget families exist internally in shadcn_flutter, and this package's
override params bridge both the same way:

- **Button-family widgets** (`BoF.button`, `BoF.badge`, `BoF.chip`, the chips
  rendered by `BoF.multipleChoiceField`/`BoF.multipleAnswerField`) resolve
  their look through a single `AbstractButtonStyle`. `bofButtonStyle(base,
  {backgroundColor, foregroundColor, fontSize, fontWeight, borderRadius,
  borderColor, borderWidth, padding})` — exported alongside `BoF` — builds an
  override of that style, keeping `base`'s hover/press/disabled behavior for
  anything you don't override. It's what each of those widgets' convenience
  params use internally, and it's public so you can build your own
  `AbstractButtonStyle` the same way (e.g. for `BoF.badge`'s `style` param).
- **Direct-param widgets** (`BoF.textField`, `BoF.checkboxField`,
  `BoF.card`, `BoF.container`, `BoF.starRatingField`, etc.) already take
  plain `Color`/`TextStyle`/`BorderRadiusGeometry` fields on the underlying
  shadcn_flutter widget, so their `BoF.*` wrapper usually forwards them
  directly. Text-field backgrounds are the exception: shadcn's `decoration`
  replaces the entire field decoration, so BoF applies `backgroundColor` as a
  field-local filled theme. This preserves the inherited border, corner radius,
  padding, and other text-field theming.

A few widgets have no styling surface at all upstream (their shadcn_flutter
implementation hardcodes colors with no theme or constructor override):
`BoF.colorField`, `BoF.phoneField`, `BoF.dateInputField`,
`BoF.timeInputField`, `BoF.durationInputField`, and per-cell colors on
`BoF.otpField` (only its `spacing`/`height` are themable). Their doc comments
call this out; where a picker/dialog counterpart exists (e.g.
`BoF.datePickerField` for `BoF.dateInputField`), prefer that if custom colors
matter.

## Conditional styling

The package adds `.when`, `.unless` and `.whenNotNull` to every value, so a
modifier or wrapper can be applied only when a condition holds, without
breaking out of a chain:

```dart
final Widget title = BoF.text('Team standup');
title
    .when(compact, (t) => t.small)
    .when(selected, (t) => t.semiBold)
    .unless(selected, (t) => t.muted);

BoF.button('Save', onPressed: canSave ? save : null)
    .whenNotNull(disabledReason, (b, reason) => BoF.tooltip(b, message: reason));
```

Each returns the same type it was called on. Text modifiers such as `.small`
return a `TextModifier`, not a `Text`, so start the chain from a value typed
as `Widget` (as above) or after a first modifier
(`BoF.text('x').small.when(...)`). For lists, such as the fields passed to
`BoF.form`, prefer Dart's collection `if`.

## Core

### BoF.text

Returns a `Text`-compatible widget, so shadcn_flutter typography modifiers
chains directly onto it:

```dart
BoF.text('Title').h1
BoF.text('Heading without a border').h2
BoF.text('Section').h3
BoF.text('Body copy').muted
BoF.text('Emphasis').bold.large
```

`BoF.text(...).h2` keeps the heading typography and spacing without a bottom border.

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

Content is centered (`alignment: Alignment.center`) by default — including
the button's child area. For a full-width button with a horizontal icon and
label, set `centerContent: true` to center both widgets together horizontally
and vertically instead of placing the icon in the native edge slot:

```dart
SizedBox(
  width: double.infinity,
  child: BoF.button(
    'Continue',
    icon: const Icon(Icons.arrow_forward),
    centerContent: true,
    onPressed: next,
  ),
);
```

Pass an explicit `alignment` to position the resulting content group elsewhere.

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

Use `padding` to override the dialog's internal padding, and `trailing` to
place a widget at the end of its header (for example, an icon or dismiss
control):

```dart
BoF.alertDialog(
  context,
  title: 'Storage almost full',
  borderRadius: BorderRadius.circular(16),
  surfaceBlur: 8,
  surfaceOpacity: 0.9,
  barrierColor: Colors.black.withValues(alpha: 0.4),
  content: 'Free up space to keep syncing files.',
  trailing: const Icon(Icons.warning_amber_rounded),
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
  positiveText: 'Manage storage',
);
```

Dialog styling accepts `borderRadius` (`BorderRadiusGeometry?`), `surfaceBlur`
and `surfaceOpacity` (`double?`), and `barrierColor` (`Color?`). With null
values, radius, blur, and opacity use the app theme; barrier color keeps the
upstream default. The barrier color styles the dialog's modal backdrop.

For global defaults, configure `ShadcnApp`'s `theme` and `darkTheme` using
`ThemeData.radius`, `surfaceBlur`, and `surfaceOpacity`. These affect other
components too. BoF currently has no dialog-specific global style configuration;
a shared helper is still needed for defaults such as padding, barrier color,
and positive/negative button styles.

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

Use `leadingGap`/`trailingGap` to customize spacing around `leading`/`trailing`
widgets (null keeps theme defaults), and `borderColor`/`borderWidth` to override
the border. An explicit `style` takes precedence over border overrides.

```dart
BoF.badge(
  BoF.text('Verified'),
  type: BoFBadgeType.outline,
  leading: const Icon(Icons.check),
  trailing: const Icon(Icons.star),
  leadingGap: 8,
  trailingGap: 12,
  borderColor: Colors.teal,
  borderWidth: 2,
);
```

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

Wraps any widget with `skeletonizer` loading placeholders; toggle `enabled`
based on your loading state.

### BoF.alert

```dart
BoF.alert(title: BoF.text('Heads up'), content: BoF.text('Something happened.'));
BoF.alert(title: BoF.text('Error'), destructive: true);
```

### BoF.accordion

```dart
BoF.accordion(items: [
  BoFAccordionItem(
    title: BoF.text('Section 1'),
    content: BoF.text('Body 1'),
    headerDecoration: BoxDecoration(color: Colors.blueGrey.shade50),
    headerPadding: const EdgeInsets.symmetric(horizontal: 12),
    contentPadding: const EdgeInsets.all(12),
  ),
  BoFAccordionItem(title: BoF.text('Section 2'), content: BoF.text('Body 2')),
], dividerHeight: 0); // removes the separators
```

Each `BoFAccordionItem` accepts `headerDecoration`, `headerPadding`,
`contentDecoration`, and `contentPadding` for styling its two containers.
`dividerHeight` styles the separators for the whole accordion; use
`dividerHeight: 0` to remove every automatic separator, including the last
item's bottom divider. Only one item should set
`expanded: true`.

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

Every standalone field also accepts an optional `controller` for updating its
value programmatically — set `controller.value` and the field updates without
a rebuild or a `BoFFormController`. When passed, it takes precedence over
`initialValue`. The controller type differs per field; see each field's
section below.

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

#### Laying out fields

Fields are stacked vertically by default. To place them differently, mix
layout entries into the same list:

- `BoFRow(children, {flex, spacing, crossAxisAlignment})` puts its children
  side by side. `flex` sets each child's share of the width, like
  `Expanded.flex` (one positive entry per child; equal shares by default).
  Children are top-aligned so a hint or error under one field doesn't shift
  its neighbours.
- `BoFColumn(children, {spacing})` stacks its children — mostly useful
  inside a `BoFRow` to put several fields in one of its columns.
- `BoFCustom(widget)` renders any other widget among the fields, such as a
  section heading or a divider. It holds no value.

`spacing` on `BoFRow`/`BoFColumn` defaults to the form's own `spacing`.
Layout entries nest freely, and fields inside them behave exactly like
top-level ones: they are validated on submit, cleared by `reset()`, and
appear under their `name` in the submitted values. Field names must be
unique across the whole form.

```dart
BoF.form(
  [
    BoFCustom(BoF.text('Shipping address')),
    BoFRow([
      BoFTextField(name: 'firstName', label: BoF.text('First name')),
      BoFTextField(name: 'lastName', label: BoF.text('Last name')),
    ]),
    BoFTextField(name: 'street', label: BoF.text('Street')),
    BoFRow(
      [
        BoFTextField(name: 'city', label: BoF.text('City')),
        BoFTextField(name: 'zip', label: BoF.text('ZIP')),
      ],
      flex: [2, 1], // city is twice as wide as zip
    ),
    BoFCustom(BoF.divider()),
    BoFRow([
      BoFColumn([
        BoFTextField(name: 'phone', label: BoF.text('Phone')),
        BoFTextField(name: 'email', label: BoF.text('Email')),
      ]),
      BoFTextAreaField(name: 'notes', label: BoF.text('Delivery notes')),
    ]),
  ],
  onSubmit: (values) => print(values),
)
```

Rows don't wrap on narrow screens; if you need a different layout below a
breakpoint, build a different list for it (e.g. with `LayoutBuilder` or
`MediaQuery`).

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
controller.setValue('email', 'a@b.com'); // sets a value AND updates the rendered field
controller.addListener(() { ... });  // rebuild on any value/error change
```

#### Locking fields

Every field spec takes `enabled` (default `true`). A disabled field still shows
its value and is still included in the submitted values, but the user can't
change it and its validator is skipped, so a locked value never blocks submit:

```dart
BoFDatePickerField(
  name: 'date',
  label: BoF.text('Date'),
  initialValue: appointment.date,
  enabled: !appointment.locked,
);
```

`setValue` is for *programmatic* changes — e.g. prefilling the form once an
async fetch resolves, or a "same as shipping" checkbox that copies values
into other fields. It updates the rendered widget, not just the tracked
value. Under the hood this remounts just that one field with the new value
(the same mechanism `reset()` uses) — cheap and always correct, at the cost
of losing that field's focus/cursor position if it happened to be focused
at that exact moment. It's scoped per-field: `setValue` on one field never
touches (or interrupts typing in) any other field, since typing itself goes
through a separate internal path that doesn't trigger a remount.

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

Validators are shadcn_flutter's `Validator<T>` — composable with `&` (AND)
and `~`/unary `-` (NOT):

```dart
validator: const NotEmptyValidator() & const LengthValidator(min: 8, max: 64)
validator: ~RegexValidator(RegExp(r'^\d+$'), message: 'Add a letter.')
```

Avoid `|` (OR) for now: in shadcn_flutter 0.0.53–0.0.55 an OR of validators
passes even when every rule fails. Write the "either" rule as a single
`ConditionalValidator` instead:

```dart
validator: ConditionalValidator<String>(
  (value) => value == null || value.isEmpty || value.startsWith('https://'),
  message: 'Enter a full URL, starting with https://',
)
```

Built-in validators include `NonNullValidator<T>`, `NotEmptyValidator`,
`LengthValidator`, `SafePasswordValidator`, `MinValidator<T>`,
`MaxValidator<T>`, `RangeValidator<T>`, `RegexValidator`, `EmailValidator`,
`URLValidator`, or write your own by extending `Validator<T>`. For text, a
few behave in ways worth knowing:

- `NonNullValidator<String>` passes an emptied field (`''`); use
  `NotEmptyValidator` for required text.
- `EmailValidator`, `RegexValidator` and `SafePasswordValidator` pass an
  untouched (null) field; pair them with `NotEmptyValidator` when the field
  is required.
- `SafePasswordValidator` doesn't check length; combine it with
  `LengthValidator(min: ...)`.
- `URLValidator` only rejects text Dart can't parse as a URI, so almost
  anything passes; use `RegexValidator` when it must be a web address.
- `CompareWith` doesn't work inside `BoF.form`, since each validator only
  sees its own field's value.

The example app's **Validators** guide has a live field for each of these.

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

BoF.textField(
  placeholder: Text('Email'),
  leadingIcon: const Icon(Icons.email),
  onChanged: (v) => print(v),
);

BoF.textField(
  placeholder: Text('Password'),
  showPasswordToggle: true, // starts obscured, adds a reveal/hide button
  onChanged: (v) => print(v),
);
```

Params: `leadingIcon`/`trailingIcon` (added via shadcn_flutter's
`InputFeature.leading`/`InputFeature.trailing`), `obscureText`,
`showPasswordToggle` (+ `passwordPeekMode`: `toggle` or `hold`), `features`
(raw `List<InputFeature>` escape hatch for anything else — clear button,
copy/paste, spinner, hint popup, etc.), `keyboardType`, `textInputAction`,
`textCapitalization`, `maxLines`, `maxLength`, `readOnly`, `autofocus`,
`focusNode`, `onSubmitted`.

`obscureText` defaults to matching `showPasswordToggle` when left unset, so
`showPasswordToggle: true` alone is enough for a normal password field; pass
`obscureText: false` too if you want it to start revealed but stay
toggleable.

Controller: `TextEditingController`.

`BoFTextField` and `BoF.textField` share the same styling parameters:

- Surface: `backgroundColor`, `filled`, `borderRadius`, `borderColor`,
  `borderWidth`, `border`, `padding`, and `decoration`.
- Text: `foregroundColor`, `fontSize`, `fontWeight`, `style`, `textAlign`,
  `textAlignVertical`, and `textDirection`.
- Cursor and selection: `cursorColor`, `cursorWidth`, `cursorHeight`,
  `cursorRadius`, `showCursor`, and `selectionColor`.

Null styling values retain theme defaults. `backgroundColor` enables a fill
unless `filled: false` is supplied. Border overrides preserve inherited sides
and any color/width that you leave unset; `borderColor`/`borderWidth` override
the corresponding values in an explicit `border`. `decoration` is a complete
surface override and takes precedence over fill, border, and radius options.
`foregroundColor`/`fontSize`/`fontWeight` override the corresponding properties
of `style`.

Both APIs also accept `minLines`, `expands`, `inputFormatters`, `enabled`, and
`onChanged`, alongside the input options above. For expanding fields, pass
`maxLines: null` and `minLines: null` within a bounded-height parent.

```dart
BoFTextField(
  name: 'email',
  label: BoF.text('Email'),
  placeholder: const Text('you@example.com'),
  backgroundColor: Colors.blue.withValues(alpha: 0.08),
  filled: true,
  borderRadius: BorderRadius.circular(12),
  borderColor: Colors.blue,
  borderWidth: 2,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  fontSize: 16,
  fontWeight: FontWeight.w500,
  cursorColor: Colors.blue,
);
// Use the same appearance options with BoF.textField(...).
```

The form spec adds `name`, `label`, `hint`, and `validator`; its value is managed
by `BoFFormController`. Its `onChanged` runs after the form records the edit,
and `enabled: false` disables that input. The standalone API additionally
accepts `key` and `TextEditingController`; it has no form metadata.

`backgroundColor` also preserves the inherited border and rounded corners in
`BoF.textAreaField` and `BoF.numberField`.

### BoF.textAreaField

`BoFTextAreaField` — value type `String` — wraps `TextArea`.

```dart
BoF.textAreaField(onChanged: (v) => print(v));
```

Params: `minHeight`, `maxHeight`. Controller: `TextEditingController`.

### BoF.numberField

`BoFNumberField` — value type `num` — wraps `TextField` with a numeric
keyboard.

```dart
BoF.numberField(onChanged: (v) => print(v));
```

shadcn_flutter has no dedicated number-input widget upstream; this parses
the typed text to `num`. Controller: `TextEditingController` (holds the raw
text, not the parsed `num`).

### BoF.checkboxField

`BoFCheckboxField` — value type `CheckboxState` — wraps `ControlledCheckbox`.

```dart
BoF.checkboxField(onChanged: (v) => print(v));
```

Tri-state: `checked` / `unchecked` / `indeterminate`. Controller:
`CheckboxController`.

### BoF.switchField

`BoFSwitchField` — value type `bool` — wraps `ControlledSwitch`.

```dart
BoF.switchField(onChanged: (v) => print(v));
```

Controller: `SwitchController`.

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
Controller: `RadioGroupController<T?>`.

### BoF.selectField

`BoFSelectField<T>` — value type `T` — wraps `Select`. Dropdown,
single selection.

```dart
BoF.selectField<String>(
  options: const [BoFOption(value: 'us', label: Text('United States'))],
  onChanged: (v) => print(v),
);
```

Controller: `SelectController<T>`.

The field measures the widest option or placeholder and keeps its width when
the selection changes, within its parent's available space. An empty selection
shows `placeholder`, which defaults to `Text('Select an option')`. The controller
value takes precedence over `initialValue`, including when its value is null.

### BoF.multiSelectField

`BoFMultiSelectField<T>` — value type `Iterable<T>` — wraps
`Select`. Dropdown, multiple selection with removable, wrapping chips.

```dart
BoF.multiSelectField<String>(
  options: const [BoFOption(value: 'us', label: Text('United States'))],
  onChanged: (v) => print(v),
);
```

Controller: `MultiSelectController<T>`.

The field measures the widest option chip or placeholder, and selected chips
wrap within that width. Null and empty selections show `placeholder`, which
defaults to `Text('Select options')`.

### BoF.multipleChoiceField

`BoFMultipleChoiceField<T>` — value type `T` — wraps
`MultipleChoice`. Inline tappable chips, single selection.

```dart
BoF.multipleChoiceField<String>(
  options: const [BoFOption(value: 's', label: Text('S'))],
  onChanged: (v) => print(v),
);
```

Controller: `MultipleChoiceController<T>`.

Choose another chip to switch selections. `allowUnselect: false` prevents
clearing the current chip while still allowing a different choice.

### BoF.multipleAnswerField

`BoFMultipleAnswerField<T>` — value type `Iterable<T>` — wraps
`MultipleAnswer`. Inline tappable chips, multiple selection.

```dart
BoF.multipleAnswerField<String>(
  options: const [BoFOption(value: 's', label: Text('S'))],
  onChanged: (v) => print(v),
);
```

Controller: `MultipleAnswerController<T>`.

### BoF.datePickerField

`BoFDatePickerField` — value type `DateTime` — wraps `ControlledDatePicker`.
Popover/dialog calendar.

```dart
BoF.datePickerField(onChanged: (v) => print(v));
```

Controller: `DatePickerController`.

### BoF.dateInputField

`BoFDateInputField` — value type `DateTime` — wraps `DateInput`. Segmented
typed entry (`mm/dd/yyyy`-style).

```dart
BoF.dateInputField(onChanged: (v) => print(v));
```

Controller: `DatePickerController`.

### BoF.timePickerField

`BoFTimePickerField` — value type `TimeOfDay` — wraps `ControlledTimePicker`.
Popover/dialog.

```dart
BoF.timePickerField(onChanged: (v) => print(v));
```

Controller: `TimePickerController`.

### BoF.timeInputField

`BoFTimeInputField` — value type `TimeOfDay` — wraps `TimeInput`. Segmented
typed entry.

```dart
BoF.timeInputField(onChanged: (v) => print(v));
```

Controller: `ComponentController<TimeOfDay?>` (shadcn_flutter has no
dedicated time controller class upstream — construct one with
`ComponentValueController<TimeOfDay?>(...)`).

### BoF.durationPickerField

`BoFDurationPickerField` — value type `Duration` — wraps `DurationPicker`.
Popover/dialog.

```dart
BoF.durationPickerField(onChanged: (v) => print(v));
```

Controller: `DurationPickerController`. `DurationPicker` itself has no
controller support upstream (it's a plain value-driven widget), so this
wraps it in a small internal adapter that syncs to the controller.

### BoF.durationInputField

`BoFDurationInputField` — value type `Duration` — wraps `DurationInput`.
Segmented typed entry.

```dart
BoF.durationInputField(onChanged: (v) => print(v));
```

Controller: `ComponentController<Duration?>` (construct one with
`ComponentValueController<Duration?>(...)`).

### BoF.colorField

`BoFColorField` — value type `Color` — wraps `ControlledColorInput`.

```dart
BoF.colorField(onChanged: (v) => print(v));
```

Converts to/from shadcn's `ColorDerivative` internally, so callers only ever
deal with plain `Color`. Controller: `ColorInputController` — note the
controller itself deals in `ColorDerivative`, not `Color` (use
`controller.setColor(color)` to update it).

### BoF.phoneField

`BoFPhoneField` — value type `PhoneNumber` — wraps `PhoneInput`.

```dart
BoF.phoneField(onChanged: (v) => print(v));
```

The upstream widget has no `enabled` param, so `BoFPhoneField(enabled: false)`
blocks input and dims the widget instead. Controller: `TextEditingController` — it manages the raw number text, not a
`PhoneNumber`, since `PhoneInput` has no dedicated value controller upstream.

### BoF.sliderField

`BoFSliderField` — value type `SliderValue` — wraps `ControlledSlider`.

```dart
BoF.sliderField(min: 0, max: 1000, onChanged: (v) => print(v));
```

Params: `min`, `max`, `divisions`. Controller: `SliderController`.

### BoF.starRatingField

`BoFStarRatingField` — value type `double` — wraps `ControlledStarRating`.

```dart
BoF.starRatingField(onChanged: (v) => print(v));
```

Params: `max`, `step`. Controller: `StarRatingController`.

### BoF.otpField

`BoFOtpField` — value type `List<int?>` — wraps `InputOTP`.

```dart
BoF.otpField(length: 6, onChanged: (v) => print(v));
```

Requires `length`. The upstream widget has no `enabled` param, so
`BoFOtpField(enabled: false)` blocks input and dims the widget instead. It also has no controller of its own, so this field has no
`controller` param — programmatic updates aren't supported.

### BoF.autoCompleteField

`BoFAutoCompleteField` — value type `String` — autocomplete suggestions with
a styled `TextField`.

```dart
BoF.autoCompleteField(
  suggestions: const ['Alice', 'Bob', 'Charlie'],
  onChanged: (v) => print(v),
);
```

Requires `suggestions`. Controller: `TextEditingController`, passed through
to the inner `TextField`.

Suggestions match the current text without regard to case and appear while
the nonempty field is focused. Selecting a suggestion replaces the whole input.

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
Controller: `ChipEditingController<T>`.
