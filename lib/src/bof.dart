import 'forms/bof_form.dart';
import 'widgets/accordion.dart';
import 'widgets/alert.dart';
import 'widgets/alert_dialog.dart';
import 'widgets/autocomplete.dart';
import 'widgets/avatar.dart';
import 'widgets/badge.dart';
import 'widgets/button.dart';
import 'widgets/checkbox.dart';
import 'widgets/card.dart';
import 'widgets/chip.dart';
import 'widgets/chip_input.dart';
import 'widgets/choice.dart';
import 'widgets/color.dart';
import 'widgets/container.dart';
import 'widgets/date_time.dart';
import 'widgets/divider.dart';
import 'widgets/dropdown_menu.dart';
import 'widgets/input.dart';
import 'widgets/otp.dart';
import 'widgets/phone.dart';
import 'widgets/popover.dart';
import 'widgets/progress.dart';
import 'widgets/radio_group.dart';
import 'widgets/select.dart';
import 'widgets/skeleton.dart';
import 'widgets/slider.dart';
import 'widgets/star_rating.dart';
import 'widgets/text.dart';
import 'widgets/toast.dart';
import 'widgets/tooltip.dart';

export 'extensions/conditional.dart';
export 'extensions/style_override.dart';
export 'forms/bof_choice_fields.dart';
export 'forms/bof_datetime_fields.dart';
export 'forms/bof_field.dart';
export 'forms/bof_form_controller.dart';
export 'forms/bof_misc_fields.dart';
export 'forms/bof_option.dart';
export 'widgets/accordion.dart' show BoFAccordionItem;
export 'widgets/badge.dart' show BoFBadgeType;
export 'widgets/button.dart' show BoFButtonType, BoFIconPosition;
export 'widgets/container.dart' show BoFContainerType;
export 'widgets/dropdown_menu.dart' show BoFMenuItem;

/// Entry point for BreaksOnFridays' styled widgets, built on top of
/// [shadcn_flutter].
///
/// Usage:
/// ```dart
/// BoF.text('Title').h1
/// BoF.button('Press Me', onPressed: () {})
/// BoF.button('Cancel', type: BoFButtonType.outline, onPressed: () {})
/// BoF.container(BoF.text('Card'), type: BoFContainerType.outline)
/// BoF.alertDialog(context, title: 'Delete?', content: 'This cannot be undone.',
///     positiveText: 'Delete', negativeText: 'Cancel')
///
/// // Standalone form widgets — no form/controller/validation involved.
/// // Named to match their `BoFXxxField` form-spec counterpart:
/// BoF.textField(onChanged: (v) => print(v))
/// BoF.checkboxField(onChanged: (v) => print(v))
///
/// // A full schema-based form, when you need validation + submit:
/// BoF.form([
///   BoFTextField(name: 'email', label: BoF.text('Email')),
/// ], onSubmit: (values) => print(values))
/// ```
class BoF {
  BoF._();

  /// A styled text widget. See [bofText].
  static const text = bofText;

  /// A styled button. See [bofButton].
  static const button = bofButton;

  /// A styled container. See [bofContainer].
  static const container = bofContainer;

  /// Shows a styled alert dialog. See [bofAlertDialog].
  static const alertDialog = bofAlertDialog;

  /// A schema-based form. See [bofForm].
  static const form = bofForm;

  // Display/layout widgets.

  /// A circular avatar showing an image or initials. See [bofAvatar].
  static const avatar = bofAvatar;

  /// A compact badge/tag. See [bofBadge].
  static const badge = bofBadge;

  /// A compact tag/filter chip. See [bofChip].
  static const chip = bofChip;

  /// A small button for a [chip]'s leading/trailing slot. See [bofChipButton].
  static const chipButton = bofChipButton;

  /// A horizontal rule. See [bofDivider].
  static const divider = bofDivider;

  /// A vertical rule. See [bofVerticalDivider].
  static const verticalDivider = bofVerticalDivider;

  /// Shows a tooltip on hover. See [bofTooltip].
  static const tooltip = bofTooltip;

  /// Shows a popover card on hover/long-press. See [bofPopover].
  static const popover = bofPopover;

  /// A horizontal progress bar. See [bofProgress].
  static const progress = bofProgress;

  /// A circular progress indicator / spinner. See [bofCircularProgress].
  static const circularProgress = bofCircularProgress;

  /// A loading-placeholder skeleton. See [bofSkeleton].
  static const skeleton = bofSkeleton;

  /// An inline message/warning banner. See [bofAlert].
  static const alert = bofAlert;

  /// A list of collapsible sections. See [bofAccordion].
  static const accordion = bofAccordion;

  /// A card-styled container. See [bofCard].
  static const card = bofCard;

  /// Shows a toast notification. See [bofToast].
  static const toast = bofToast;

  /// Shows a dropdown menu. See [bofDropdownMenu].
  static const dropdownMenu = bofDropdownMenu;

  // Standalone form widgets. Each is named after its matching `BoFXxxField`
  // form spec and renders the exact same widget, without the
  // form/controller/validation machinery — use these when you just need one
  // value.

  /// A single-line text input. Matches [BoFTextField]. See [bofTextField].
  static const textField = bofTextField;

  /// A multi-line text input. Matches [BoFTextAreaField]. See [bofTextAreaField].
  static const textAreaField = bofTextAreaField;

  /// A numeric text input. Matches [BoFNumberField]. See [bofNumberField].
  static const numberField = bofNumberField;

  /// A tri-state checkbox. Matches [BoFCheckboxField]. See [bofCheckboxField].
  static const checkboxField = bofCheckboxField;

  /// A boolean switch. Matches [BoFSwitchField]. See [bofSwitchField].
  static const switchField = bofSwitchField;

  /// A single-choice radio group. Matches [BoFRadioGroupField]. See [bofRadioGroupField].
  static const radioGroupField = bofRadioGroupField;

  /// A single-selection dropdown. Matches [BoFSelectField]. See [bofSelectField].
  static const selectField = bofSelectField;

  /// A multi-selection dropdown. Matches [BoFMultiSelectField]. See [bofMultiSelectField].
  static const multiSelectField = bofMultiSelectField;

  /// An inline single choice, rendered as tappable chips. Matches
  /// [BoFMultipleChoiceField]. See [bofMultipleChoiceField].
  static const multipleChoiceField = bofMultipleChoiceField;

  /// An inline multi-choice, rendered as tappable chips. Matches
  /// [BoFMultipleAnswerField]. See [bofMultipleAnswerField].
  static const multipleAnswerField = bofMultipleAnswerField;

  /// A popover/dialog date picker. Matches [BoFDatePickerField]. See [bofDatePickerField].
  static const datePickerField = bofDatePickerField;

  /// A segmented, typed date entry. Matches [BoFDateInputField]. See [bofDateInputField].
  static const dateInputField = bofDateInputField;

  /// A popover/dialog time picker. Matches [BoFTimePickerField]. See [bofTimePickerField].
  static const timePickerField = bofTimePickerField;

  /// A segmented, typed time entry. Matches [BoFTimeInputField]. See [bofTimeInputField].
  static const timeInputField = bofTimeInputField;

  /// A popover/dialog duration picker. Matches [BoFDurationPickerField]. See [bofDurationPickerField].
  static const durationPickerField = bofDurationPickerField;

  /// A segmented, typed duration entry. Matches [BoFDurationInputField]. See [bofDurationInputField].
  static const durationInputField = bofDurationInputField;

  /// A color swatch input. Matches [BoFColorField]. See [bofColorField].
  static const colorField = bofColorField;

  /// A phone number input. Matches [BoFPhoneField]. See [bofPhoneField].
  static const phoneField = bofPhoneField;

  /// A slider. Matches [BoFSliderField]. See [bofSliderField].
  static const sliderField = bofSliderField;

  /// A star rating. Matches [BoFStarRatingField]. See [bofStarRatingField].
  static const starRatingField = bofStarRatingField;

  /// A one-time-password / PIN input. Matches [BoFOtpField]. See [bofOtpField].
  static const otpField = bofOtpField;

  /// A text input with a suggestion popover. Matches [BoFAutoCompleteField].
  /// See [bofAutoCompleteField].
  static const autoCompleteField = bofAutoCompleteField;

  /// A free-form list of chips parsed from typed text. Matches
  /// [BoFChipInputField]. See [bofChipInputField].
  static const chipInputField = bofChipInputField;
}
