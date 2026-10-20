import 'package:flutter_test/flutter_test.dart';

import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

void main() {
  group('conditional styling on widgets', () {
    test('icon modifiers chain without retyping the icon', () {
      const icon = Icon(LucideIcons.star);

      final small = icon.when(true, (i) => i.iconSmall);
      expect(small, isA<WrappedIcon>());
      expect((small as WrappedIcon).child, same(icon));

      expect(icon.when(false, (i) => i.iconSmall), same(icon));
      expect(icon.unless(false, (i) => i.iconSmall), isA<WrappedIcon>());
      expect(icon.unless(true, (i) => i.iconSmall), same(icon));
    });

    test('the transform sees the widget as its own type', () {
      const icon = Icon(LucideIcons.star, size: 12);
      final resized = icon.whenNotNull<double>(
        24,
        (i, size) => Icon(i.icon, size: size),
      );
      expect((resized as Icon).icon, LucideIcons.star);
      expect(resized.size, 24);
      expect(icon.whenNotNull<double>(null, (i, _) => i.iconLarge), same(icon));
    });

    test('text modifiers chain straight off BoF.text', () {
      final text = BoF.text('Title');
      final styled = text
          .when(true, (t) => t.small)
          .when(false, (t) => t.semiBold)
          .unless(false, (t) => t.muted);
      expect(styled, isA<TextModifier>());
      expect(text.when(false, (t) => t.small), same(text));
    });

    test('any widget can be wrapped', () {
      const child = SizedBox();
      final wrapped = child.whenNotNull(
        'Why',
        (c, reason) => Tooltip(tooltip: (_) => Text(reason), child: c),
      );
      expect(wrapped, isA<Tooltip>());
      expect(
        child.whenNotNull<String>(null, (c, _) => const Text('x')),
        same(child),
      );
    });
  });

  group('conditional chaining on other values', () {
    test('keeps the original type', () {
      const style = TextStyle(fontSize: 12);
      final TextStyle bigger = style.when(
        true,
        (s) => s.copyWith(fontSize: 20),
      );
      expect(bigger.fontSize, 20);
      expect(style.unless(true, (s) => s.copyWith(fontSize: 20)), same(style));

      final int total = 3.whenNotNull<int>(4, (n, extra) => n + extra);
      expect(total, 7);
      expect(3.whenNotNull<int>(null, (n, extra) => n + extra), 3);
    });
  });
}
