## 0.1.6

* Added `ConditionalWidget.when`/`unless`/`whenNotNull` extension for conditional widget-chaining (e.g. `Text(...).when(isSelected, (t) => t.bold)`).
* Added `backgroundColor`, `foregroundColor`, `fontSize`, `borderRadius` and other per-widget style overrides across most `BoF` widgets (`button`, `badge`, `chip`, `card`, `container`, `avatar`, text/checkbox/select/slider/star-rating fields, date/time pickers, tooltip, progress, alert/toast, otp, radio group), via the new shared `bofButtonStyle` helper.
* Documented the handful of widgets with no styling surface upstream (`colorField`, `phoneField`, the segmented date/time/duration input fields).
* Updated the example gallery and README with a "Custom styling" section demonstrating the new overrides.
* Added `NonNullValidator<DateTime>()` usage example for `BoFDateInputField`'s mm/dd/yyyy masked date entry.

## 0.1.5

* Added a comprehensive example gallery application showcasing all `BoF` widgets.
* Updated `bofDatePickerField` to highlight the current date with an outline.
* Fixed zero-padding for single-digit months and days in `bofDateInputField`.
* Defaulted date and time pickers to `popover` mode and added support for `popoverPadding` and `dialogTitle`.
* Added unit tests for date picker today-highlighting and input segment formatting.

## 0.1.4

* Added `controller` support to text, choice, date/time, selection, and toggle fields to allow programmatic value updates.
* Implemented controller synchronization for `bofDurationPickerField` via a custom internal adapter.
* Updated documentation across all widgets to specify appropriate controller types and precedence over `initialValue`.
* Noted that `bofOtpField` remains without controller support due to underlying widget limitations.

## 0.1.3

* Fixed `AlertDialog` sizing.

## 0.1.2

* Added support for programmatically updating individual form fields through `BoFFormController.setValue`.
* Improved field updates so changing one field no longer interrupts active input in other fields.
* Added per-field remounting to keep programmatic value changes synchronized correctly.
* Added `BoFFormController.reportChange` for user-driven field updates.
* Updated documentation and added tests for programmatic value syncing.

## 0.1.1

* Added more options for text fields, including icons, password visibility, input actions, character limits, and focus controls.
* Improved button alignment, especially for buttons with icons.
* Fixed several widget bugs, including container keys, alert dialog buttons, and form reset behavior.
* Added MIT license.

## 0.1.0

Initial public release of BoF, a collection of styled widgets built on top of `shadcn_flutter`.

* Added common UI widgets such as text, buttons, containers, dialogs, avatars, badges, cards, alerts, progress indicators, and more.
* Added schema-based forms with built-in value management, validation, and submission handling.
* Added standalone field widgets for use outside forms.
* Added comprehensive widget and form documentation.
