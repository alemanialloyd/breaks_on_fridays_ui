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
