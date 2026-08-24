## 0.1.1

* `BoF.textField`/`BoFTextField`: added `leadingIcon`/`trailingIcon`,
  `showPasswordToggle` (+ `passwordPeekMode`), a raw `features:
  List<InputFeature>` escape hatch, and `textInputAction`,
  `textCapitalization`, `maxLength`, `readOnly`, `autofocus`, `focusNode`,
  `onSubmitted`.
* `BoF.button`: content is now centered (`alignment: Alignment.center`) by
  default, including icon+label buttons — the underlying `Button` otherwise
  left-aligns whenever an icon is present. Pass an explicit `alignment` to
  override.
* Reviewed every widget wrapper; fixed a `key` handling bug in
  `BoF.container`, a wrong-`Navigator`-context bug in `BoF.alertDialog`'s
  default buttons, and made `BoFFormController.reset()` actually reset the
  rendered field widgets instead of only clearing tracked values.
* Added a `LICENSE` (MIT) ahead of the package going open source.

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

