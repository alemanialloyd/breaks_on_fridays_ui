## 0.1.0

Initial public release. A thin, opinionated layer of styled widgets on top
of [shadcn_flutter](https://pub.dev/packages/shadcn_flutter), accessed
through a single `BoF` entry point.

* **Core widgets**: `BoF.text`, `BoF.button` (with icon-only/label-only/icon+
  label positioning via `BoFIconPosition`), `BoF.container`, `BoF.alertDialog`.
* **Display & layout widgets**: `BoF.avatar`, `BoF.badge`, `BoF.chip`,
  `BoF.divider`/`BoF.verticalDivider`, `BoF.tooltip`, `BoF.popover`,
  `BoF.progress`/`BoF.circularProgress`, `BoF.skeleton`, `BoF.alert`,
  `BoF.accordion`, `BoF.card`, `BoF.toast`, `BoF.dropdownMenu`.
* **Schema-based forms**: `BoF.form` renders a list of `BoFField` specs
  (23 field kinds covering every shadcn_flutter form widget) with no
  `TextEditingController` to manage — values, validation, and submission are
  driven by `BoFFormController`. Every field kind is also available
  standalone as `BoF.xxxField` for single-value use outside a form.
* Full field-by-field and widget-by-widget documentation in the README, with
  a glossary linking to every section.

