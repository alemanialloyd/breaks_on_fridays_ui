import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

/// Live form for the Validators guide: one text field per common validator,
/// so each rule can be tried on its own.
class ValidatorsDemo extends StatefulWidget {
  const ValidatorsDemo({super.key});

  @override
  State<ValidatorsDemo> createState() => _ValidatorsDemoState();
}

class _ValidatorsDemoState extends State<ValidatorsDemo> {
  final controller = BoFFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      BoF.form(
        [
          BoFRow([
            BoFTextField(
              name: 'username',
              label: BoF.text('Username'),
              hint: BoF.text('NotEmptyValidator & LengthValidator(3–20)'),
              validator:
                  const NotEmptyValidator() &
                  const LengthValidator(min: 3, max: 20),
            ),
            BoFTextField(
              name: 'email',
              label: BoF.text('Email'),
              hint: BoF.text('NotEmptyValidator & EmailValidator'),
              validator: const NotEmptyValidator() & const EmailValidator(),
            ),
          ]),
          BoFRow([
            BoFTextField(
              name: 'zip',
              label: BoF.text('ZIP code'),
              hint: BoF.text('RegexValidator, custom message'),
              validator: RegexValidator(
                RegExp(r'^\d{5}$'),
                message: 'Use a 5-digit ZIP code.',
              ),
            ),
            BoFTextField(
              name: 'website',
              label: BoF.text('Website (optional)'),
              hint: BoF.text('ConditionalValidator, empty allowed'),
              validator: ConditionalValidator<String>(
                (value) =>
                    value == null ||
                    value.isEmpty ||
                    RegExp(r'^https?://\S+\.\S+$').hasMatch(value),
                message: 'Enter a full URL, starting with https://',
              ),
            ),
          ]),
          BoFTextField(
            name: 'password',
            label: BoF.text('Password'),
            hint: BoF.text('LengthValidator(min: 8) & SafePasswordValidator'),
            showPasswordToggle: true,
            validator:
                const LengthValidator(min: 8) & const SafePasswordValidator(),
          ),
          BoFTextField(
            name: 'username_locked',
            label: BoF.text('Account ID (locked)'),
            hint: BoF.text('enabled: false — its validator is skipped'),
            initialValue: '',
            enabled: false,
            validator: const NotEmptyValidator(),
          ),
        ],
        controller: controller,
        onSubmit: (values) => BoF.toast(
          context,
          title: 'All validators passed',
          message: 'onSubmit received ${values.length} values.',
        ),
      ),
      Row(
        children: [
          BoF.button('Submit', onPressed: controller.submit),
          const SizedBox(width: 8),
          BoF.button(
            'Reset',
            type: BoFButtonType.outline,
            onPressed: controller.reset,
          ),
        ],
      ),
    ],
  );
}

/// Live demo for the Conditional styling guide: toggles feed `.when`,
/// `.unless` and `.whenNotNull` on one text widget.
class ConditionalDemo extends StatefulWidget {
  const ConditionalDemo({super.key});

  @override
  State<ConditionalDemo> createState() => _ConditionalDemoState();
}

class _ConditionalDemoState extends State<ConditionalDemo> {
  bool selected = true;
  bool compact = false;
  bool flagged = false;

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Keyed by value so the switch remounts with the new state.
      BoF.switchField(
        key: ValueKey('$label-$value'),
        initialValue: value,
        onChanged: onChanged,
      ),
      const SizedBox(width: 8),
      BoF.text(label).small,
    ],
  );

  @override
  Widget build(BuildContext context) {
    final Color? flagColor = flagged
        ? Theme.of(context).colorScheme.destructive
        : null;
    final Widget title = BoF.text('Team standup');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            _toggle('selected', selected, (v) => setState(() => selected = v)),
            _toggle('compact', compact, (v) => setState(() => compact = v)),
            _toggle('flagged', flagged, (v) => setState(() => flagged = v)),
          ],
        ),
        const SizedBox(height: 20),
        title
            .when(compact, (t) => t.small)
            .when(selected, (t) => t.semiBold)
            .unless(selected, (t) => t.muted)
            .whenNotNull(
              flagColor,
              (t, color) => DefaultTextStyle.merge(
                style: TextStyle(color: color),
                child: t,
              ),
            ),
      ],
    );
  }
}
