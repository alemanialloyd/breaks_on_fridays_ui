import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

/// One labeled entry in the gallery: a title, an optional one-line caption,
/// and the widget being showcased, boxed so its layout bounds are visible
/// even for widgets with a transparent background.
class GalleryEntry extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;

  const GalleryEntry({
    super.key,
    required this.title,
    this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoF.text(title).semiBold,
          if (description != null) BoF.text(description!).muted.small,
          const SizedBox(height: 8),
          BoF.container(
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
            type: BoFContainerType.outline,
          ),
        ],
      ),
    );
  }
}

/// A category heading followed by its [GalleryEntry] children, with extra
/// spacing so sections stay visually distinct while scrolling.
class GallerySection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const GallerySection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoF.text(title).h2,
          const SizedBox(height: 8),
          BoF.divider(),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
