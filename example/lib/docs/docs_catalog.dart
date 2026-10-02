import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

import '../gallery_section.dart';
import '../sections/core_section.dart';
import '../sections/display_section.dart';
import '../sections/form_fields_section.dart';

/// A focused documentation page for one public BoF entry point.
class DocPage {
  final String id;
  final String title;
  final String group;
  final String description;
  final String code;
  final List<String> notes;
  final List<DocParameter> parameters;

  const DocPage({
    required this.id,
    required this.title,
    required this.group,
    required this.description,
    required this.code,
    this.notes = const [],
    this.parameters = const [],
  });
}

/// A selected public parameter and the behavior relevant to its caller.
class DocParameter {
  final String name;
  final String type;
  final String description;

  const DocParameter({
    required this.name,
    required this.type,
    required this.description,
  });
}

const _controllerNote =
    'A supplied controller takes precedence over initialValue. Keep it in '
    'your widget state and dispose it when that state is removed.';
const _standaloneNote =
    'Standalone fields manage their own value. Use the matching BoF field '
    'spec inside BoF.form to add a name, label, hint, and validator.';
const _pickerStyleNote =
    'backgroundColor, foregroundColor, fontSize, and borderRadius style the '
    'picker trigger button. Unset options keep the theme defaults.';

/// The complete component catalog, in navigation order.
final List<DocPage> componentPages = const [
  DocPage(
    id: 'text',
    title: 'Text',
    group: 'Core',
    description:
        'Display text with the typography of your app. BoF.text returns a '
        'plain Text widget, so shadcn_flutter typography modifiers chain '
        'directly onto it.',
    code: '''Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BoF.text('Title').h1,
    BoF.text('Section').h3,
    BoF.text('Body copy').muted,
    BoF.text('Emphasis').bold.large,
  ],
);''',
    notes: [
      'Combine modifiers such as .bold.large or .muted.small for common text treatments.',
      'Use style for a TextStyle override and maxLines with overflow for constrained text.',
    ],
    parameters: [
      DocParameter(
        name: 'data',
        type: 'String',
        description: 'Required positional text to display.',
      ),
      DocParameter(
        name: 'style',
        type: 'TextStyle?',
        description: 'Optional text appearance override.',
      ),
      DocParameter(
        name: 'textAlign',
        type: 'TextAlign?',
        description: 'Horizontal alignment of text within its bounds.',
      ),
      DocParameter(
        name: 'maxLines',
        type: 'int?',
        description: 'Maximum number of visible lines.',
      ),
      DocParameter(
        name: 'overflow',
        type: 'TextOverflow?',
        description: 'How text that exceeds its bounds is displayed.',
      ),
      DocParameter(
        name: 'semanticsLabel',
        type: 'String?',
        description: 'Alternative label read by assistive technologies.',
      ),
    ],
  ),
  DocPage(
    id: 'button',
    title: 'Button',
    group: 'Core',
    description:
        'Trigger an action with a consistent button style. Choose from '
        'primary, secondary, outline, ghost, link, text, and destructive variants.',
    code: '''Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    BoF.button('Save', onPressed: () {}),
    BoF.button('Cancel', type: BoFButtonType.outline, onPressed: () {}),
    BoF.button('Delete', type: BoFButtonType.destructive, onPressed: () {}),
    BoF.button(
      'Next',
      icon: const Icon(LucideIcons.arrowRight),
      iconPosition: BoFIconPosition.right,
      onPressed: () {},
    ),
  ],
);''',
    notes: [
      'Supply a label, an icon, or both. An icon-only button uses ButtonDensity.icon unless density is specified.',
      'For a full-width button, centerContent: true centers the icon and label together. alignment controls the group position.',
      'backgroundColor, foregroundColor, fontSize, fontWeight, borderRadius, borderColor, borderWidth, and padding override individual style properties.',
    ],
    parameters: [
      DocParameter(
        name: 'label',
        type: 'String?',
        description:
            'Positional text label; pass null for an icon-only button.',
      ),
      DocParameter(
        name: 'type',
        type: 'BoFButtonType',
        description: 'Visual variant. Defaults to primary.',
      ),
      DocParameter(
        name: 'onPressed',
        type: 'VoidCallback?',
        description: 'Callback when the button is activated.',
      ),
      DocParameter(
        name: 'icon',
        type: 'Widget?',
        description: 'Optional icon beside or above the label.',
      ),
      DocParameter(
        name: 'iconPosition',
        type: 'BoFIconPosition',
        description: 'left, right, top, or bottom. Defaults to left.',
      ),
      DocParameter(
        name: 'centerContent',
        type: 'bool',
        description:
            'Centers a horizontal icon and label as one group. Defaults to true.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool?',
        description: 'Overrides the button enabled state.',
      ),
    ],
  ),
  DocPage(
    id: 'container',
    title: 'Container',
    group: 'Core',
    description:
        'Group content on an outlined or filled surface. BoF.container wraps '
        'OutlinedContainer and resolves its fill and border from your theme.',
    code: '''Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    BoF.container(BoF.text('Outline'), type: BoFContainerType.outline),
    BoF.container(BoF.text('Filled'), type: BoFContainerType.filled),
    BoF.container(BoF.text('Danger'), type: BoFContainerType.destructive),
  ],
);''',
    notes: [
      'Types are filled, secondary, outline, ghost, and destructive.',
      'Explicit backgroundColor, borderColor, and borderWidth override the selected type.',
      'Use BoF.card when you want a content card with card-specific fill, shadow, and padding defaults.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget',
        description: 'Required positional content.',
      ),
      DocParameter(
        name: 'type',
        type: 'BoFContainerType',
        description: 'Surface variant. Defaults to outline.',
      ),
      DocParameter(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'Space inside the surface.',
      ),
      DocParameter(
        name: 'backgroundColor',
        type: 'Color?',
        description: 'Override the type-based fill color.',
      ),
      DocParameter(
        name: 'borderColor',
        type: 'Color?',
        description: 'Override the type-based border color.',
      ),
      DocParameter(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'Override the corner shape.',
      ),
    ],
  ),
  DocPage(
    id: 'alert-dialog',
    title: 'Alert dialog',
    group: 'Core',
    description:
        'Ask for confirmation or show focused content in a modal dialog. '
        'The returned Future completes when the dialog closes.',
    code: '''Builder(
  builder: (context) => BoF.button(
    'Delete item',
    type: BoFButtonType.destructive,
    onPressed: () async {
      final confirmed = await BoF.alertDialog(
        context,
        title: 'Delete item',
        content: 'This action cannot be undone.',
        positiveText: 'Delete',
        negativeText: 'Cancel',
        positiveType: BoFButtonType.destructive,
      );
      if (confirmed == true) {
        // Delete the item here.
      }
    },
  ),
);''',
    notes: [
      'Default positive and negative actions return true and false. Custom onPositive or onNegative callbacks must close the dialog themselves.',
      'titleWidget and contentWidget override their string counterparts; actions replaces the default buttons.',
      'borderRadius, surfaceBlur, surfaceOpacity, and barrierColor customize the surface and modal backdrop. ThemeData supplies radius, blur, and opacity defaults.',
    ],
    parameters: [
      DocParameter(
        name: 'context',
        type: 'BuildContext',
        description: 'Required positional context used to present the dialog.',
      ),
      DocParameter(
        name: 'title / content',
        type: 'String?',
        description: 'Text for the heading and body.',
      ),
      DocParameter(
        name: 'positiveText / negativeText',
        type: 'String?',
        description: 'Labels for the default actions.',
      ),
      DocParameter(
        name: 'positiveType / negativeType',
        type: 'BoFButtonType',
        description: 'Default action variants: primary and outline.',
      ),
      DocParameter(
        name: 'actions',
        type: 'List<Widget>?',
        description: 'Custom action widgets instead of the default buttons.',
      ),
      DocParameter(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'Internal dialog padding.',
      ),
      DocParameter(
        name: 'trailing',
        type: 'Widget?',
        description: 'Widget at the end of the dialog header.',
      ),
      DocParameter(
        name: 'barrierColor',
        type: 'Color?',
        description: 'Color of the modal backdrop.',
      ),
    ],
  ),
  DocPage(
    id: 'avatar',
    title: 'Avatar',
    group: 'Display & layout',
    description:
        'Represent a person with a photo or initials. When a photo fails '
        'to load, the avatar falls back to its initials.',
    code: """BoF.avatar(initials: 'JD');""",
    notes: [
      'Pass photoUrl to display a remote image while keeping initials as a fallback.',
      'badge accepts an AvatarWidget, typically AvatarBadge, positioned with badgeAlignment and badgeGap.',
      'backgroundColor, size, and borderRadius customize the avatar. textStyle controls the initials color, size, and weight.',
    ],
    parameters: [
      DocParameter(
        name: 'initials',
        type: 'String',
        description: 'Required initials shown when no photo is available.',
      ),
      DocParameter(
        name: 'photoUrl',
        type: 'String?',
        description: 'Network image URL.',
      ),
      DocParameter(
        name: 'size',
        type: 'double?',
        description: 'Avatar dimensions.',
      ),
      DocParameter(
        name: 'badge',
        type: 'AvatarWidget?',
        description: 'Optional status or count overlay.',
      ),
      DocParameter(
        name: 'badgeAlignment',
        type: 'AlignmentGeometry?',
        description: 'Position of the badge around the avatar.',
      ),
    ],
  ),
  DocPage(
    id: 'badge',
    title: 'Badge',
    group: 'Display & layout',
    description:
        'Add a compact status or category label. Badge variants share the '
        'button styling system for a consistent appearance.',
    code: '''Wrap(
  spacing: 12,
  children: [
    BoF.badge(BoF.text('New')),
    BoF.badge(BoF.text('Alert'), type: BoFBadgeType.destructive),
    BoF.badge(
      BoF.text('Verified'),
      type: BoFBadgeType.outline,
      leading: const Icon(LucideIcons.check),
      leadingGap: 8,
      borderColor: Colors.teal,
      borderWidth: 2,
    ),
  ],
);''',
    notes: [
      'Variants are primary, secondary, outline, and destructive.',
      'Use backgroundColor, foregroundColor, fontSize, fontWeight, borderRadius, borderColor, and borderWidth for individual overrides.',
      'An explicit AbstractButtonStyle in style takes precedence over the convenience style overrides.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget',
        description: 'Required positional label or content.',
      ),
      DocParameter(
        name: 'type',
        type: 'BoFBadgeType',
        description: 'Badge variant. Defaults to primary.',
      ),
      DocParameter(
        name: 'leading / trailing',
        type: 'Widget?',
        description: 'Optional content on either side of the label.',
      ),
      DocParameter(
        name: 'leadingGap / trailingGap',
        type: 'double?',
        description:
            'Spacing around leading and trailing widgets; null keeps theme defaults.',
      ),
      DocParameter(
        name: 'style',
        type: 'AbstractButtonStyle?',
        description: 'Complete button style override.',
      ),
    ],
  ),
  DocPage(
    id: 'chip',
    title: 'Chip',
    group: 'Display & layout',
    description:
        'Display a compact tag or filter with optional leading and trailing '
        'actions. BoF.chipButton fits naturally into these action slots.',
    code: '''BoF.chip(
  BoF.text('Filter'),
  trailing: BoF.chipButton(
    child: const Icon(LucideIcons.x),
    onPressed: () {},
  ),
);''',
    notes: [
      'Use BoF.chipButton for small actions such as removing a chip.',
      'backgroundColor, foregroundColor, fontSize, fontWeight, and borderRadius override the chip appearance.',
      'An explicit style replaces the convenience style overrides.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget',
        description: 'Required positional chip content.',
      ),
      DocParameter(
        name: 'leading / trailing',
        type: 'Widget?',
        description: 'Optional widgets before and after the content.',
      ),
      DocParameter(
        name: 'style',
        type: 'AbstractButtonStyle?',
        description: 'Complete chip style override.',
      ),
      DocParameter(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'Corner shape for the chip surface.',
      ),
    ],
  ),
  DocPage(
    id: 'divider',
    title: 'Divider',
    group: 'Display & layout',
    description:
        'Separate sections with a horizontal rule, optionally interrupted by a centered label.',
    code: '''Column(
  children: [
    BoF.divider(),
    const SizedBox(height: 16),
    BoF.divider(child: BoF.text('OR')),
  ],
);''',
    notes: [
      'Use childAlignment and padding to position and space an optional label.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget?',
        description: 'Optional widget inserted into the rule.',
      ),
      DocParameter(
        name: 'color',
        type: 'Color?',
        description: 'Line color; null retains the theme default.',
      ),
      DocParameter(
        name: 'height',
        type: 'double?',
        description: 'Total height occupied by the divider.',
      ),
      DocParameter(
        name: 'thickness',
        type: 'double?',
        description: 'Thickness of the visible line.',
      ),
      DocParameter(
        name: 'indent / endIndent',
        type: 'double?',
        description: 'Space before and after the line.',
      ),
    ],
  ),
  DocPage(
    id: 'vertical-divider',
    title: 'Vertical divider',
    group: 'Display & layout',
    description:
        'Separate adjacent content with a vertical rule. Place it in a parent with a bounded height.',
    code: '''SizedBox(
  height: 48,
  child: Row(
    children: [
      BoF.text('A'),
      BoF.verticalDivider(),
      BoF.text('B'),
    ],
  ),
);''',
    notes: [
      'This is the vertical counterpart of BoF.divider, with width instead of height.',
    ],
    parameters: [
      DocParameter(
        name: 'width',
        type: 'double?',
        description: 'Total width occupied by the divider.',
      ),
      DocParameter(
        name: 'thickness',
        type: 'double?',
        description: 'Thickness of the visible line.',
      ),
      DocParameter(
        name: 'color',
        type: 'Color?',
        description: 'Line color; null retains the theme default.',
      ),
      DocParameter(
        name: 'child',
        type: 'Widget?',
        description: 'Optional widget inserted into the line.',
      ),
      DocParameter(
        name: 'padding',
        type: 'EdgeInsetsGeometry',
        description: 'Defaults to 8 logical pixels above and below.',
      ),
    ],
  ),
  DocPage(
    id: 'tooltip',
    title: 'Tooltip',
    group: 'Display & layout',
    description:
        'Provide a short explanation when someone hovers over a control.',
    code: '''BoF.tooltip(
  BoF.button('Hover me', onPressed: () {}),
  message: 'Tooltip text',
);''',
    notes: [
      'Supply message or builder. A builder takes precedence and is called when the tooltip is shown.',
      'backgroundColor, borderRadius, padding, and textStyle customize the default message container.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget',
        description: 'Required positional hover target.',
      ),
      DocParameter(
        name: 'message',
        type: 'String?',
        description: 'Text shown in the default tooltip container.',
      ),
      DocParameter(
        name: 'builder',
        type: 'WidgetBuilder?',
        description: 'Custom tooltip content, rebuilt on show.',
      ),
      DocParameter(
        name: 'waitDuration',
        type: 'Duration',
        description: 'Delay before showing; defaults to 500 milliseconds.',
      ),
      DocParameter(
        name: 'alignment / anchorAlignment',
        type: 'AlignmentGeometry',
        description: 'Tooltip and target alignment for positioning.',
      ),
    ],
  ),
  DocPage(
    id: 'popover',
    title: 'Popover',
    group: 'Display & layout',
    description:
        'Reveal richer supporting content in a hover card when a target is hovered or long-pressed.',
    code: '''BoF.popover(
  const Icon(LucideIcons.info),
  content: BoF.card(BoF.text('Popover content')),
);''',
    notes: [
      'Supply content or builder. A builder takes precedence and rebuilds the card on show.',
      'Style the supplied content directly, for example with BoF.card.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget',
        description: 'Required positional hover or long-press target.',
      ),
      DocParameter(
        name: 'content',
        type: 'Widget?',
        description: 'Content displayed in the hover card.',
      ),
      DocParameter(
        name: 'builder',
        type: 'WidgetBuilder?',
        description: 'Builds custom content each time the card is shown.',
      ),
      DocParameter(
        name: 'wait / debounce',
        type: 'Duration?',
        description:
            'Show and debounce timing, using upstream defaults when null.',
      ),
      DocParameter(
        name: 'offset',
        type: 'Offset?',
        description: 'Additional displacement from the anchor.',
      ),
    ],
  ),
  DocPage(
    id: 'progress',
    title: 'Progress',
    group: 'Display & layout',
    description:
        'Show completion with a horizontal progress bar, or use an indeterminate bar when the amount is unknown.',
    code: '''Column(
  children: [
    BoF.progress(progress: 0.65),
    const SizedBox(height: 12),
    BoF.progress(),
  ],
);''',
    notes: [
      'A null progress value displays an indeterminate animation.',
      'Use disableAnimation: true to snap to a new determinate value.',
      'color, backgroundColor, and borderRadius customize the bar and track.',
    ],
    parameters: [
      DocParameter(
        name: 'progress',
        type: 'double?',
        description: 'Current progress; null is indeterminate.',
      ),
      DocParameter(
        name: 'min / max',
        type: 'double',
        description: 'Progress range. Defaults to 0 and 1.',
      ),
      DocParameter(
        name: 'disableAnimation',
        type: 'bool',
        description: 'Disables value-transition animation. Defaults to false.',
      ),
      DocParameter(
        name: 'color',
        type: 'Color?',
        description: 'Color of the filled portion.',
      ),
      DocParameter(
        name: 'backgroundColor',
        type: 'Color?',
        description: 'Color of the unfilled track.',
      ),
    ],
  ),
  DocPage(
    id: 'circular-progress',
    title: 'Circular progress',
    group: 'Display & layout',
    description:
        'Display determinate progress as a ring or show a spinner for an ongoing task.',
    code: '''Wrap(
  spacing: 16,
  children: [
    BoF.circularProgress(value: 0.65),
    BoF.circularProgress(),
  ],
);''',
    notes: [
      'A null value displays an indeterminate spinner.',
      'Set animated: false to disable transitions between determinate values.',
      'color, backgroundColor, strokeWidth, and size control the appearance.',
    ],
    parameters: [
      DocParameter(
        name: 'value',
        type: 'double?',
        description: 'Completion fraction from 0 to 1; null is indeterminate.',
      ),
      DocParameter(
        name: 'size',
        type: 'double?',
        description: 'Diameter of the indicator.',
      ),
      DocParameter(
        name: 'strokeWidth',
        type: 'double?',
        description: 'Thickness of the ring.',
      ),
      DocParameter(
        name: 'animated',
        type: 'bool',
        description: 'Animate determinate value changes. Defaults to true.',
      ),
      DocParameter(
        name: 'onSurface',
        type: 'bool',
        description:
            'Use the upstream on-surface treatment. Defaults to false.',
      ),
    ],
  ),
  DocPage(
    id: 'skeleton',
    title: 'Skeleton',
    group: 'Display & layout',
    description:
        'Turn existing content into loading placeholders while preserving its layout.',
    code: """BoF.skeleton(BoF.text('Loading...'), enabled: true);""",
    notes: [
      'Drive enabled from your loading state to restore the original child when loading completes.',
      'Avatar and Image children are handled as skeleton leaves automatically.',
      'leaf paints one placeholder; unite combines a subtree. replacement supplies a custom loading widget.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget',
        description: 'Required positional content to skeletonize.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Show placeholders. Defaults to true.',
      ),
      DocParameter(
        name: 'leaf',
        type: 'bool',
        description: 'Treat the child as one placeholder. Defaults to false.',
      ),
      DocParameter(
        name: 'unite',
        type: 'bool',
        description: 'Combine the subtree into a single skeleton region.',
      ),
      DocParameter(
        name: 'replacement',
        type: 'Widget?',
        description: 'Custom replacement while the skeleton is enabled.',
      ),
    ],
  ),
  DocPage(
    id: 'alert',
    title: 'Alert',
    group: 'Display & layout',
    description:
        'Show a message inline with optional leading and trailing content. Use destructive styling for errors or warnings.',
    code: '''Column(
  children: [
    BoF.alert(
      title: BoF.text('Heads up'),
      content: BoF.text('Something happened.'),
    ),
    const SizedBox(height: 12),
    BoF.alert(title: BoF.text('Error'), destructive: true),
  ],
);''',
    notes: [
      'backgroundColor, borderColor, and padding override the alert theme for this instance.',
    ],
    parameters: [
      DocParameter(
        name: 'title',
        type: 'Widget?',
        description: 'Heading content.',
      ),
      DocParameter(
        name: 'content',
        type: 'Widget?',
        description: 'Message or supporting content.',
      ),
      DocParameter(
        name: 'leading / trailing',
        type: 'Widget?',
        description: 'Optional icon or action widgets.',
      ),
      DocParameter(
        name: 'destructive',
        type: 'bool',
        description: 'Apply destructive styling. Defaults to false.',
      ),
      DocParameter(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'Internal spacing override.',
      ),
    ],
  ),
  DocPage(
    id: 'accordion',
    title: 'Accordion',
    group: 'Display & layout',
    description:
        'Organize related content into collapsible sections. Only one section is expanded at a time.',
    code: '''BoF.accordion(
  dividerHeight: 0,
  items: [
    BoFAccordionItem(
      title: BoF.text('Section 1'),
      content: BoF.text('Body 1'),
      headerPadding: const EdgeInsets.symmetric(horizontal: 12),
      contentPadding: const EdgeInsets.all(12),
    ),
    BoFAccordionItem(
      title: BoF.text('Section 2'),
      content: BoF.text('Body 2'),
    ),
  ],
);''',
    notes: [
      'Set expanded: true on at most one BoFAccordionItem to choose the initially open section.',
      'Items accept headerDecoration, headerPadding, contentDecoration, and contentPadding.',
      'dividerHeight: 0 removes separators throughout the accordion.',
    ],
    parameters: [
      DocParameter(
        name: 'items',
        type: 'List<BoFAccordionItem>',
        description: 'Required collapsible sections.',
      ),
      DocParameter(
        name: 'dividerHeight',
        type: 'double?',
        description:
            'Separator height and thickness; null uses theme defaults.',
      ),
      DocParameter(
        name: 'item.title',
        type: 'Widget',
        description: 'Required content of the clickable header.',
      ),
      DocParameter(
        name: 'item.content',
        type: 'Widget',
        description: 'Required content shown when expanded.',
      ),
      DocParameter(
        name: 'item.expanded',
        type: 'bool',
        description: 'Whether this section starts expanded. Defaults to false.',
      ),
    ],
  ),
  DocPage(
    id: 'card',
    title: 'Card',
    group: 'Display & layout',
    description:
        'Present related content in a card with dedicated fill, shadow, and padding defaults.',
    code: """BoF.card(BoF.text('Card body'), filled: true);""",
    notes: [
      'BoF.card has card-specific defaults; BoF.container is a general surface with BoFContainerType variants.',
      'Use fillColor for the card fill and textStyle for inherited text styling inside the card.',
      'surfaceOpacity and surfaceBlur control the card surface treatment.',
    ],
    parameters: [
      DocParameter(
        name: 'child',
        type: 'Widget',
        description: 'Required positional card content.',
      ),
      DocParameter(
        name: 'filled',
        type: 'bool?',
        description: 'Enable a filled surface; null uses the theme default.',
      ),
      DocParameter(
        name: 'fillColor',
        type: 'Color?',
        description: 'Fill color override.',
      ),
      DocParameter(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'Space inside the card.',
      ),
      DocParameter(
        name: 'boxShadow',
        type: 'List<BoxShadow>?',
        description: 'Shadow override.',
      ),
      DocParameter(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'Corner shape override.',
      ),
    ],
  ),
  DocPage(
    id: 'toast',
    title: 'Toast',
    group: 'Display & layout',
    description:
        'Show a temporary notification after an action. The returned ToastOverlay can be inspected or closed programmatically.',
    code: '''Builder(
  builder: (context) => BoF.button(
    'Show toast',
    onPressed: () => BoF.toast(
      context,
      title: 'Saved',
      message: 'Your changes were saved.',
    ),
  ),
);''',
    notes: [
      'Requires a ToastLayer ancestor, which ShadcnApp provides.',
      'The default body uses BoF.alert styling. content replaces the message within that alert; builder replaces the complete toast body.',
      'Read overlay.isShowing or call overlay.close() on the returned ToastOverlay.',
      'backgroundColor, borderColor, and padding style the default alert body.',
    ],
    parameters: [
      DocParameter(
        name: 'context',
        type: 'BuildContext',
        description: 'Required positional context beneath a ToastLayer.',
      ),
      DocParameter(
        name: 'title / message',
        type: 'String?',
        description: 'Text for the default notification body.',
      ),
      DocParameter(
        name: 'location',
        type: 'ToastLocation',
        description: 'Overlay position. Defaults to bottomRight.',
      ),
      DocParameter(
        name: 'showDuration',
        type: 'Duration',
        description: 'Visible duration. Defaults to 5 seconds.',
      ),
      DocParameter(
        name: 'dismissible',
        type: 'bool',
        description:
            'Allow dismissal and show a close button. Defaults to true.',
      ),
      DocParameter(
        name: 'builder',
        type: 'ToastBuilder?',
        description: 'Custom body builder with access to the toast overlay.',
      ),
    ],
  ),
  DocPage(
    id: 'dropdown-menu',
    title: 'Dropdown menu',
    group: 'Display & layout',
    description:
        'Open a contextual menu anchored to a widget. Each BoFMenuItem describes an action or nested submenu.',
    code: '''Builder(
  builder: (context) => BoF.button(
    'Open menu',
    onPressed: () => BoF.dropdownMenu(
      context,
      items: [
        BoFMenuItem(child: BoF.text('Edit'), onPressed: () {}),
        BoFMenuItem(child: BoF.text('Delete'), onPressed: () {}),
      ],
    ),
  ),
);''',
    notes: [
      'Use a Builder at the trigger to provide a context near the intended anchor.',
      'BoFMenuItem supports leading, trailing, enabled, and subMenu for nested actions.',
      'The call returns an OverlayCompleter<Object?> from shadcn_flutter.',
    ],
    parameters: [
      DocParameter(
        name: 'context',
        type: 'BuildContext',
        description: 'Required positional context used as the menu anchor.',
      ),
      DocParameter(
        name: 'items',
        type: 'List<BoFMenuItem>',
        description: 'Required menu items.',
      ),
      DocParameter(
        name: 'alignment / anchorAlignment',
        type: 'AlignmentGeometry?',
        description: 'Menu and anchor alignment.',
      ),
      DocParameter(
        name: 'offset',
        type: 'Offset?',
        description: 'Additional displacement from the anchor.',
      ),
      DocParameter(
        name: 'modal',
        type: 'bool',
        description: 'Show as a modal overlay. Defaults to true.',
      ),
      DocParameter(
        name: 'consumeOutsideTaps',
        type: 'bool',
        description: 'Consume outside taps. Defaults to false.',
      ),
    ],
  ),
  DocPage(
    id: 'form',
    title: 'Form',
    group: 'Forms',
    description:
        'Build a validated form from field specifications. Each field owns '
        'its input value, and onSubmit receives a Map<String, Object?> '
        'only when every validator passes.',
    code: '''class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  final controller = BoFFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      BoF.form(
        [
          BoFTextField(
            name: 'email',
            label: BoF.text('Email'),
            validator: const NotEmptyValidator() & const EmailValidator(),
          ),
          BoFDateInputField(
            name: 'birthday',
            label: BoF.text('Birthday'),
            validator: const NonNullValidator<DateTime>(),
          ),
          BoFCheckboxField(
            name: 'agree',
            label: BoF.text('I agree to the terms'),
          ),
        ],
        controller: controller,
        onSubmit: (values) {
          BoF.toast(context, title: 'Saved', message: 'Account details saved.');
        },
      ),
      const SizedBox(height: 12),
      BoF.button('Submit', onPressed: () => controller.submit()),
    ],
  );
}''',
    notes: [
      'Every spec requires name and label; hint and validator are optional. name becomes a key in the submitted values map.',
      'Validation runs on changes and again on submit. Compose validators with & (AND), | (OR), and ~ or unary - (NOT).',
      'BoFFormController exposes values, value<T>(name), errorOf(name), isValid, submit(), reset(), setValue(), and listeners.',
      'Keep an externally supplied controller in State and dispose it there. Without a controller, the form creates and disposes its own.',
      'setValue updates the rendered input by remounting only that field, so it can reset its focus and cursor position.',
      'Pass a GlobalKey to locate the form for scrolling, independently of its data controller.',
    ],
    parameters: [
      DocParameter(
        name: 'fields',
        type: 'List<BoFField>',
        description: 'Required positional list of field specifications.',
      ),
      DocParameter(
        name: 'controller',
        type: 'BoFFormController?',
        description:
            'Optional access to live values, errors, reset, and submit.',
      ),
      DocParameter(
        name: 'onSubmit',
        type: 'ValueChanged<Map<String, Object?>>?',
        description: 'Receives finished values after successful validation.',
      ),
      DocParameter(
        name: 'spacing',
        type: 'double',
        description: 'Vertical gap between fields. Defaults to 16.',
      ),
      DocParameter(
        name: 'key',
        type: 'Key?',
        description:
            'Optional widget key; use a GlobalKey to read currentContext.',
      ),
    ],
  ),
  DocPage(
    id: 'text-field',
    title: 'Text field',
    group: 'Forms',
    description:
        'Collect text with optional icons, input features, and a built-in password reveal control. Values are Strings.',
    code: '''Column(
  children: [
    BoF.textField(
      placeholder: const Text('Search'),
      onChanged: (value) {},
    ),
    const SizedBox(height: 12),
    BoF.textField(
      placeholder: const Text('Email'),
      leadingIcon: const Icon(LucideIcons.mail),
      onChanged: (value) {},
    ),
    const SizedBox(height: 12),
    BoF.textField(
      placeholder: const Text('Password'),
      showPasswordToggle: true,
      onChanged: (value) {},
    ),
  ],
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'showPasswordToggle: true starts obscured unless obscureText: false is supplied. passwordPeekMode supports toggle and hold.',
      'backgroundColor enables a local fill while preserving inherited borders and corners, unless filled: false is supplied.',
      'decoration replaces the entire surface and takes precedence over fill, border, and radius. foregroundColor, fontSize, and fontWeight override matching properties in style.',
      'For an expanding field, set expands: true, maxLines: null, and minLines: null inside a bounded-height parent.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'String?',
        description: 'Initial text when no controller is supplied.',
      ),
      DocParameter(
        name: 'controller',
        type: 'TextEditingController?',
        description: 'Read or update text programmatically.',
      ),
      DocParameter(
        name: 'placeholder',
        type: 'Widget?',
        description: 'Content shown when the field is empty.',
      ),
      DocParameter(
        name: 'onChanged / onSubmitted',
        type: 'ValueChanged<String>?',
        description: 'Callbacks for edits and submission.',
      ),
      DocParameter(
        name: 'leadingIcon / trailingIcon',
        type: 'Widget?',
        description: 'Convenience input features around the text.',
      ),
      DocParameter(
        name: 'showPasswordToggle',
        type: 'bool',
        description: 'Add a reveal/hide control. Defaults to false.',
      ),
      DocParameter(
        name: 'features',
        type: 'List<InputFeature>?',
        description: 'Additional input features, such as a clear button.',
      ),
      DocParameter(
        name: 'enabled / readOnly',
        type: 'bool',
        description:
            'Whether the input is enabled and whether its text can be edited.',
      ),
      DocParameter(
        name: 'backgroundColor / foregroundColor',
        type: 'Color?',
        description: 'Surface fill and text color overrides.',
      ),
      DocParameter(
        name: 'borderColor / borderWidth',
        type: 'Color? / double?',
        description:
            'Override matching border properties while retaining inherited sides.',
      ),
      DocParameter(
        name: 'cursorColor / selectionColor',
        type: 'Color?',
        description: 'Cursor and selected-text highlight colors.',
      ),
    ],
  ),
  DocPage(
    id: 'text-area-field',
    title: 'Text area',
    group: 'Forms',
    description:
        'Collect longer text in a multiline field with configurable minimum and maximum height.',
    code: '''BoF.textAreaField(
  placeholder: const Text('Write a message'),
  minHeight: 100,
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFTextAreaField. Values are Strings.',
      'backgroundColor preserves the inherited border and rounded corners. foregroundColor, fontSize, and borderRadius also accept overrides.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'String?',
        description: 'Initial text.',
      ),
      DocParameter(
        name: 'controller',
        type: 'TextEditingController?',
        description: 'Read or update text programmatically.',
      ),
      DocParameter(
        name: 'minHeight',
        type: 'double',
        description: 'Minimum field height. Defaults to 100.',
      ),
      DocParameter(
        name: 'maxHeight',
        type: 'double',
        description: 'Maximum field height. Defaults to infinity.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<String>?',
        description: 'Receives edited text.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'number-field',
    title: 'Number field',
    group: 'Forms',
    description:
        'Collect a numeric value with a numeric keyboard. The wrapper parses text to num and reports null when it cannot be parsed.',
    code: '''BoF.numberField(
  placeholder: const Text('Amount'),
  initialValue: 25,
  allowDecimal: true,
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFNumberField. The TextEditingController stores raw text, while onChanged receives the parsed num?.',
      'allowDecimal configures the requested keyboard; it does not enforce integer-only input.',
      'backgroundColor preserves inherited field styling. foregroundColor, fontSize, and borderRadius accept overrides.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'num?',
        description: 'Initial numeric value.',
      ),
      DocParameter(
        name: 'controller',
        type: 'TextEditingController?',
        description: 'Controller for the raw input text.',
      ),
      DocParameter(
        name: 'allowDecimal',
        type: 'bool',
        description:
            'Request a keyboard with decimal support. Defaults to true.',
      ),
      DocParameter(
        name: 'placeholder',
        type: 'Widget?',
        description: 'Content shown when empty.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<num?>?',
        description: 'Receives a number or null for invalid/empty text.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'checkbox-field',
    title: 'Checkbox',
    group: 'Forms',
    description:
        'Represent a tri-state selection: checked, unchecked, or indeterminate.',
    code: '''BoF.checkboxField(
  initialValue: CheckboxState.unchecked,
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFCheckboxField. Its value is CheckboxState, rather than bool.',
      'backgroundColor, activeColor, borderColor, borderRadius, and size customize the checkbox.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'CheckboxState',
        description: 'Initial state. Defaults to unchecked.',
      ),
      DocParameter(
        name: 'controller',
        type: 'CheckboxController?',
        description: 'Read or update the state programmatically.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<CheckboxState>?',
        description: 'Receives changes in checked state.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
      DocParameter(
        name: 'activeColor',
        type: 'Color?',
        description: 'Color when the checkbox is active.',
      ),
    ],
  ),
  DocPage(
    id: 'switch-field',
    title: 'Switch',
    group: 'Forms',
    description:
        'Toggle a boolean setting with a switch. Values are true or false.',
    code: '''BoF.switchField(
  initialValue: false,
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFSwitchField.',
      'activeColor, inactiveColor, activeThumbColor, inactiveThumbColor, and borderRadius customize the switch.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'bool',
        description: 'Initial value. Defaults to false.',
      ),
      DocParameter(
        name: 'controller',
        type: 'SwitchController?',
        description: 'Read or update the switch programmatically.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<bool>?',
        description: 'Receives the new boolean value.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
      DocParameter(
        name: 'activeColor / inactiveColor',
        type: 'Color?',
        description: 'Track colors for each switch state.',
      ),
    ],
  ),
  DocPage(
    id: 'radio-group-field',
    title: 'Radio group',
    group: 'Forms',
    description:
        'Choose one typed value from a visible list of options, rendered as radio items or cards.',
    code: '''BoF.radioGroupField<String>(
  options: const [
    BoFOption(value: 'free', label: Text('Free')),
    BoFOption(value: 'pro', label: Text('Pro')),
  ],
  initialValue: 'free',
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFRadioGroupField<T>. BoFOption<T> contains value, label, and an optional enabled flag.',
      'card: true renders RadioCard items. color, hoverColor, borderWidth, and borderRadius apply to the card variant.',
    ],
    parameters: [
      DocParameter(
        name: 'options',
        type: 'List<BoFOption<T>>',
        description: 'Required typed choices.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'T?',
        description: 'Initial selected option.',
      ),
      DocParameter(
        name: 'controller',
        type: 'RadioGroupController<T?>?',
        description: 'Read or update the selection programmatically.',
      ),
      DocParameter(
        name: 'card',
        type: 'bool',
        description: 'Use card-style items. Defaults to false.',
      ),
      DocParameter(
        name: 'direction',
        type: 'Axis',
        description: 'Item layout direction. Defaults to vertical.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<T?>?',
        description: 'Receives the selected value.',
      ),
    ],
  ),
  DocPage(
    id: 'select-field',
    title: 'Select',
    group: 'Forms',
    description:
        'Choose one typed value from a dropdown. Each option supplies the label shown for its value.',
    code: '''BoF.selectField<String>(
  placeholder: const Text('Choose a country'),
  options: const [
    BoFOption(value: 'us', label: Text('United States')),
    BoFOption(value: 'ph', label: Text('Philippines')),
  ],
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFSelectField<T>. Options can be disabled individually with BoFOption.enabled.',
      'filled changes the field treatment and borderRadius overrides its corners.',
    ],
    parameters: [
      DocParameter(
        name: 'options',
        type: 'List<BoFOption<T>>',
        description: 'Required choices for the dropdown.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'T?',
        description: 'Initial selected option.',
      ),
      DocParameter(
        name: 'controller',
        type: 'SelectController<T>?',
        description: 'Read or update the selection programmatically.',
      ),
      DocParameter(
        name: 'placeholder',
        type: 'Widget?',
        description: 'Content shown before an option is selected.',
      ),
      DocParameter(
        name: 'filled',
        type: 'bool',
        description: 'Use a filled field. Defaults to false.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<T?>?',
        description: 'Receives the selected value.',
      ),
    ],
  ),
  DocPage(
    id: 'multi-select-field',
    title: 'Multi-select',
    group: 'Forms',
    description:
        'Choose several typed values from a dropdown. The selected value is an Iterable<T>.',
    code: '''BoF.multiSelectField<String>(
  placeholder: const Text('Choose countries'),
  options: const [
    BoFOption(value: 'us', label: Text('United States')),
    BoFOption(value: 'ph', label: Text('Philippines')),
  ],
  onChanged: (values) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFMultiSelectField<T>. Options may be disabled individually.',
      'borderRadius overrides the field corner shape.',
    ],
    parameters: [
      DocParameter(
        name: 'options',
        type: 'List<BoFOption<T>>',
        description: 'Required choices for the dropdown.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'Iterable<T>?',
        description: 'Initially selected values.',
      ),
      DocParameter(
        name: 'controller',
        type: 'MultiSelectController<T>?',
        description: 'Read or update selected values programmatically.',
      ),
      DocParameter(
        name: 'placeholder',
        type: 'Widget?',
        description: 'Content shown before a selection is made.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<Iterable<T>?>?',
        description: 'Receives the current selection.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'multiple-choice-field',
    title: 'Multiple choice',
    group: 'Forms',
    description:
        'Choose one value from inline tappable chips, keeping every option visible.',
    code: '''BoF.multipleChoiceField<String>(
  options: const [
    BoFOption(value: 's', label: Text('S')),
    BoFOption(value: 'm', label: Text('M')),
    BoFOption(value: 'l', label: Text('L')),
  ],
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFMultipleChoiceField<T>. Set allowUnselect: false to keep a selected option from being toggled off.',
      'selectedBackgroundColor, selectedForegroundColor, selectedFontSize, and selectedBorderRadius style selected chips; unselected counterparts style the others.',
    ],
    parameters: [
      DocParameter(
        name: 'options',
        type: 'List<BoFOption<T>>',
        description: 'Required chip choices.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'T?',
        description: 'Initial selected value.',
      ),
      DocParameter(
        name: 'controller',
        type: 'MultipleChoiceController<T>?',
        description: 'Read or update the selection programmatically.',
      ),
      DocParameter(
        name: 'allowUnselect',
        type: 'bool',
        description: 'Allow clearing the selected chip. Defaults to true.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<T?>?',
        description: 'Receives the selected value or null.',
      ),
    ],
  ),
  DocPage(
    id: 'multiple-answer-field',
    title: 'Multiple answer',
    group: 'Forms',
    description:
        'Choose several values from inline tappable chips. Each option can be toggled independently.',
    code: '''BoF.multipleAnswerField<String>(
  options: const [
    BoFOption(value: 's', label: Text('S')),
    BoFOption(value: 'm', label: Text('M')),
    BoFOption(value: 'l', label: Text('L')),
  ],
  onChanged: (values) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFMultipleAnswerField<T>. Values are Iterable<T>.',
      'Use selectedBackgroundColor, selectedForegroundColor, selectedFontSize, selectedBorderRadius and unselected counterparts to style both states.',
    ],
    parameters: [
      DocParameter(
        name: 'options',
        type: 'List<BoFOption<T>>',
        description: 'Required chip choices.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'Iterable<T>?',
        description: 'Initially selected values.',
      ),
      DocParameter(
        name: 'controller',
        type: 'MultipleAnswerController<T>?',
        description: 'Read or update the selection programmatically.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<Iterable<T>?>?',
        description: 'Receives selected values.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'date-picker-field',
    title: 'Date picker',
    group: 'Forms',
    description:
        'Choose a DateTime from a calendar in a popover or dialog. The calendar outlines today.',
    code: '''BoF.datePickerField(
  placeholder: const Text('Choose a date'),
  mode: PromptMode.popover,
  onChanged: (date) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      _pickerStyleNote,
      'The form spec is BoFDatePickerField. Popover is the default; mode: PromptMode.dialog opts into Cancel/Save dialog actions.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'DateTime?',
        description: 'Initial selected date.',
      ),
      DocParameter(
        name: 'controller',
        type: 'DatePickerController?',
        description: 'Read or update the date programmatically.',
      ),
      DocParameter(
        name: 'mode',
        type: 'PromptMode',
        description: 'Popover or dialog presentation. Defaults to popover.',
      ),
      DocParameter(
        name: 'placeholder',
        type: 'Widget?',
        description: 'Content shown when no date is selected.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<DateTime?>?',
        description: 'Receives the selected date.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'date-input-field',
    title: 'Date input',
    group: 'Forms',
    description:
        'Type a date into segmented input. The field pads single-digit days and months and uses the app localization for part order.',
    code: '''BoF.dateInputField(
  onChanged: (date) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFDateInputField. Incomplete dates report null; NonNullValidator<DateTime> rejects an incomplete form date.',
      'The upstream segmented-input surface has no color or border override. Use BoF.datePickerField when custom colors are needed.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'DateTime?',
        description: 'Initial date.',
      ),
      DocParameter(
        name: 'controller',
        type: 'DatePickerController?',
        description: 'Read or update the date programmatically.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<DateTime?>?',
        description: 'Receives a complete date or null.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'time-picker-field',
    title: 'Time picker',
    group: 'Forms',
    description:
        'Choose a TimeOfDay in a popover or dialog, with optional seconds.',
    code: '''BoF.timePickerField(
  mode: PromptMode.popover,
  onChanged: (time) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      _pickerStyleNote,
      'The form spec is BoFTimePickerField. Set mode: PromptMode.dialog for dialog presentation.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'TimeOfDay?',
        description: 'Initial selected time.',
      ),
      DocParameter(
        name: 'controller',
        type: 'TimePickerController?',
        description: 'Read or update the time programmatically.',
      ),
      DocParameter(
        name: 'showSeconds',
        type: 'bool',
        description: 'Include seconds. Defaults to false.',
      ),
      DocParameter(
        name: 'mode',
        type: 'PromptMode',
        description: 'Presentation mode. Defaults to popover.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<TimeOfDay?>?',
        description: 'Receives the selected time.',
      ),
    ],
  ),
  DocPage(
    id: 'time-input-field',
    title: 'Time input',
    group: 'Forms',
    description:
        'Enter a TimeOfDay through segmented typed input with optional seconds.',
    code: '''BoF.timeInputField(
  showSeconds: false,
  onChanged: (time) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFTimeInputField. Construct a controller with ComponentValueController<TimeOfDay?>(initialTime).',
      'The upstream surface has no color or border override. Use BoF.timePickerField for a trigger with custom colors.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'TimeOfDay?',
        description: 'Initial time.',
      ),
      DocParameter(
        name: 'controller',
        type: 'ComponentController<TimeOfDay?>?',
        description: 'Read or update the time programmatically.',
      ),
      DocParameter(
        name: 'showSeconds',
        type: 'bool',
        description: 'Include a seconds segment. Defaults to false.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<TimeOfDay?>?',
        description: 'Receives the current time.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'duration-picker-field',
    title: 'Duration picker',
    group: 'Forms',
    description:
        'Choose a Duration with a picker. BoF manages the value and controller synchronization for the underlying widget.',
    code: '''BoF.durationPickerField(
  initialValue: const Duration(minutes: 30),
  onChanged: (duration) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      _pickerStyleNote,
      'The form spec is BoFDurationPickerField. Its value is a Duration.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'Duration',
        description: 'Initial duration. Defaults to Duration.zero.',
      ),
      DocParameter(
        name: 'controller',
        type: 'DurationPickerController?',
        description: 'Read or update the duration programmatically.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<Duration?>?',
        description: 'Receives the selected duration.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
      DocParameter(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'Picker trigger corner shape.',
      ),
    ],
  ),
  DocPage(
    id: 'duration-input-field',
    title: 'Duration input',
    group: 'Forms',
    description: 'Type a Duration into segmented input, with optional seconds.',
    code: '''BoF.durationInputField(
  showSeconds: true,
  onChanged: (duration) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFDurationInputField. Construct a controller with ComponentValueController<Duration?>(initialDuration).',
      'The upstream surface has no color or border override. Use BoF.durationPickerField when custom trigger colors are needed.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'Duration?',
        description: 'Initial duration.',
      ),
      DocParameter(
        name: 'controller',
        type: 'ComponentController<Duration?>?',
        description: 'Read or update the duration programmatically.',
      ),
      DocParameter(
        name: 'showSeconds',
        type: 'bool',
        description: 'Include a seconds segment. Defaults to false.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<Duration?>?',
        description: 'Receives the current duration.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'color-field',
    title: 'Color picker',
    group: 'Forms',
    description:
        'Choose a color with a swatch input. The public callback uses plain Color values.',
    code: '''BoF.colorField(
  initialValue: Colors.teal,
  showAlpha: true,
  onChanged: (color) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFColorField. ColorInputController stores ColorDerivative; call controller.setColor(color) to update it with a plain Color.',
      'The upstream widget has no surface color or border override.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'Color',
        description: 'Initial color. Defaults to opaque black.',
      ),
      DocParameter(
        name: 'controller',
        type: 'ColorInputController?',
        description: 'Controller that stores ColorDerivative values.',
      ),
      DocParameter(
        name: 'showAlpha',
        type: 'bool',
        description: 'Allow choosing transparency. Defaults to false.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<Color>?',
        description: 'Receives a plain Color.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'phone-field',
    title: 'Phone input',
    group: 'Forms',
    description:
        'Collect a phone number using the upstream PhoneInput. Changes are reported as PhoneNumber values.',
    code: '''BoF.phoneField(
  onChanged: (phoneNumber) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFPhoneField. The TextEditingController manages raw number text, rather than a PhoneNumber.',
      'The upstream widget has no enabled parameter or surface styling overrides.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'PhoneNumber?',
        description: 'Initial phone number.',
      ),
      DocParameter(
        name: 'controller',
        type: 'TextEditingController?',
        description: 'Controller for the raw number text.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<PhoneNumber?>?',
        description: 'Receives the current phone number.',
      ),
      DocParameter(
        name: 'key',
        type: 'Key?',
        description: 'Optional widget identity.',
      ),
    ],
  ),
  DocPage(
    id: 'slider-field',
    title: 'Slider',
    group: 'Forms',
    description:
        'Choose a numeric value by dragging along a track. SliderValue supports a single value or a range.',
    code: '''BoF.sliderField(
  initialValue: const SliderValue.single(250),
  min: 0,
  max: 1000,
  divisions: 20,
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFSliderField. Values are SliderValue objects.',
      'trackColor styles the inactive track, activeColor styles the filled portion, and trackHeight controls its height.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'SliderValue',
        description: 'Initial single or range value. Defaults to single(0).',
      ),
      DocParameter(
        name: 'controller',
        type: 'SliderController?',
        description: 'Read or update slider values programmatically.',
      ),
      DocParameter(
        name: 'min / max',
        type: 'double',
        description: 'Allowed bounds. Defaults to 0 and 1.',
      ),
      DocParameter(
        name: 'divisions',
        type: 'int?',
        description:
            'Number of discrete intervals; null allows continuous values.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<SliderValue>?',
        description: 'Receives the current slider value.',
      ),
      DocParameter(
        name: 'trackColor / activeColor',
        type: 'Color?',
        description: 'Inactive and filled track colors.',
      ),
    ],
  ),
  DocPage(
    id: 'star-rating-field',
    title: 'Star rating',
    group: 'Forms',
    description:
        'Collect a rating with configurable maximum and step size, including fractional stars.',
    code: '''BoF.starRatingField(
  initialValue: 3.5,
  max: 5,
  step: 0.5,
  onChanged: (rating) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFStarRatingField. Values are doubles.',
      'activeColor, backgroundColor, and starSize customize the stars.',
    ],
    parameters: [
      DocParameter(
        name: 'initialValue',
        type: 'double',
        description: 'Initial rating. Defaults to 0.',
      ),
      DocParameter(
        name: 'controller',
        type: 'StarRatingController?',
        description: 'Read or update the rating programmatically.',
      ),
      DocParameter(
        name: 'max',
        type: 'double',
        description: 'Maximum rating. Defaults to 5.',
      ),
      DocParameter(
        name: 'step',
        type: 'double',
        description: 'Rating increment. Defaults to 0.5.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<double>?',
        description: 'Receives the current rating.',
      ),
      DocParameter(
        name: 'starSize',
        type: 'double?',
        description: 'Size of each star.',
      ),
    ],
  ),
  DocPage(
    id: 'otp-field',
    title: 'OTP input',
    group: 'Forms',
    description:
        'Collect a fixed-length one-time password or PIN in individual character cells.',
    code: '''BoF.otpField(
  length: 6,
  onChanged: (digits) {},
);''',
    notes: [
      _standaloneNote,
      'The form spec is BoFOtpField. Values are List<int?>; null represents an empty character slot.',
      'This field has no controller or enabled parameter. Programmatic updates are not supported by the upstream widget.',
      'Only spacing and height are exposed for styling; per-cell colors cannot be overridden.',
    ],
    parameters: [
      DocParameter(
        name: 'length',
        type: 'int',
        description: 'Required number of input cells.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'List<int?>?',
        description: 'Initial characters, with null for empty slots.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<List<int?>>?',
        description: 'Receives the current character values.',
      ),
      DocParameter(
        name: 'spacing',
        type: 'double?',
        description: 'Gap between cells.',
      ),
      DocParameter(
        name: 'height',
        type: 'double?',
        description: 'Input cell height.',
      ),
    ],
  ),
  DocPage(
    id: 'auto-complete-field',
    title: 'Autocomplete',
    group: 'Forms',
    description:
        'Suggest existing Strings while someone types into a text field.',
    code: '''BoF.autoCompleteField(
  placeholder: const Text('Name'),
  suggestions: const ['Alice', 'Bob', 'Charlie'],
  onChanged: (value) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFAutoCompleteField. The controller is passed to the inner TextField.',
      'backgroundColor, foregroundColor, fontSize, and borderRadius customize the text field. A backgroundColor supplies a complete BoxDecoration override.',
    ],
    parameters: [
      DocParameter(
        name: 'suggestions',
        type: 'List<String>',
        description: 'Required suggestions offered by the autocomplete.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'String?',
        description: 'Initial text.',
      ),
      DocParameter(
        name: 'controller',
        type: 'TextEditingController?',
        description: 'Read or update the inner field text.',
      ),
      DocParameter(
        name: 'placeholder',
        type: 'Widget?',
        description: 'Content shown when empty.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<String>?',
        description: 'Receives text changes.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
  DocPage(
    id: 'chip-input-field',
    title: 'Chip input',
    group: 'Forms',
    description:
        'Parse typed text into a free-form list of typed chips. Supply the parser and the widget used to render each value.',
    code: '''BoF.chipInputField<String>(
  chipBuilder: (context, value) => BoF.chip(BoF.text(value)),
  onChipSubmitted: (text) => text.trim().isEmpty ? null : text.trim(),
  onChanged: (values) {},
);''',
    notes: [
      _standaloneNote,
      _controllerNote,
      'The form spec is BoFChipInputField<T>. Return null from onChipSubmitted to reject text that cannot become a chip.',
      'ChipEditingController<T> manages both chips and input text.',
      'backgroundColor, foregroundColor, fontSize, and borderRadius customize the field. backgroundColor supplies a complete BoxDecoration override.',
    ],
    parameters: [
      DocParameter(
        name: 'chipBuilder',
        type: 'Widget Function(BuildContext, T)',
        description: 'Required builder for each chip value.',
      ),
      DocParameter(
        name: 'onChipSubmitted',
        type: 'T? Function(String)',
        description: 'Required parser for submitted text; null rejects it.',
      ),
      DocParameter(
        name: 'initialValue',
        type: 'List<T>?',
        description: 'Initial chips.',
      ),
      DocParameter(
        name: 'controller',
        type: 'ChipEditingController<T>?',
        description: 'Read or update chips and text programmatically.',
      ),
      DocParameter(
        name: 'onChanged',
        type: 'ValueChanged<List<T>>?',
        description: 'Receives the current chip list.',
      ),
      DocParameter(
        name: 'enabled',
        type: 'bool',
        description: 'Allow interaction. Defaults to true.',
      ),
    ],
  ),
];

const _galleryTitles = <String, String>{
  'text': 'BoF.text',
  'button': 'BoF.button',
  'container': 'BoF.container',
  'alert-dialog': 'BoF.alertDialog',
  'avatar': 'BoF.avatar',
  'badge': 'BoF.badge',
  'chip': 'BoF.chip',
  'divider': 'BoF.divider',
  'vertical-divider': 'BoF.verticalDivider',
  'tooltip': 'BoF.tooltip',
  'popover': 'BoF.popover',
  'progress': 'BoF.progress',
  'circular-progress': 'BoF.circularProgress',
  'skeleton': 'BoF.skeleton',
  'alert': 'BoF.alert',
  'accordion': 'BoF.accordion',
  'card': 'BoF.card',
  'toast': 'BoF.toast',
  'dropdown-menu': 'BoF.dropdownMenu',
  'form': 'BoF.form',
  'text-field': 'BoF.textField',
  'text-area-field': 'BoF.textAreaField',
  'number-field': 'BoF.numberField',
  'checkbox-field': 'BoF.checkboxField',
  'switch-field': 'BoF.switchField',
  'radio-group-field': 'BoF.radioGroupField',
  'select-field': 'BoF.selectField',
  'multi-select-field': 'BoF.multiSelectField',
  'multiple-choice-field': 'BoF.multipleChoiceField',
  'multiple-answer-field': 'BoF.multipleAnswerField',
  'date-picker-field': 'BoF.datePickerField',
  'date-input-field': 'BoF.dateInputField',
  'time-picker-field': 'BoF.timePickerField',
  'time-input-field': 'BoF.timeInputField',
  'duration-picker-field': 'BoF.durationPickerField',
  'duration-input-field': 'BoF.durationInputField',
  'color-field': 'BoF.colorField',
  'phone-field': 'BoF.phoneField',
  'slider-field': 'BoF.sliderField',
  'star-rating-field': 'BoF.starRatingField',
  'otp-field': 'BoF.otpField',
  'auto-complete-field': 'BoF.autoCompleteField',
  'chip-input-field': 'BoF.chipInputField',
};

/// Reuse the package's live gallery examples without the old gallery chrome.
Widget buildComponentPreview(BuildContext context, String id) {
  final galleryTitle = _galleryTitles[id];
  if (galleryTitle == null) return const SizedBox.shrink();

  final GallerySection section;
  if (id == 'form' ||
      componentPages.any((page) => page.id == id && page.group == 'Core')) {
    section = const CoreSection().build(context) as GallerySection;
  } else if (componentPages.any(
    (page) => page.id == id && page.group == 'Display & layout',
  )) {
    section = const DisplaySection().build(context) as GallerySection;
  } else {
    section = const FormFieldsSection().build(context) as GallerySection;
  }

  for (final entry in section.children.whereType<GalleryEntry>()) {
    if (entry.title == galleryTitle) return entry.child;
  }
  return const SizedBox.shrink();
}
