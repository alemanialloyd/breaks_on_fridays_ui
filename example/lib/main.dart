import 'package:breaks_on_fridays_ui/breaks_on_fridays_ui.dart';

import 'sections/core_section.dart';
import 'sections/display_section.dart';
import 'sections/form_fields_section.dart';

void main() => runApp(const GalleryApp());

class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'BoF Widget Gallery',
      theme: ThemeData(
        colorScheme: _isDark ? ColorSchemes.darkZinc : ColorSchemes.lightZinc,
        radius: 0.5,
      ),
      home: Scaffold(
        headers: [
          AppBar(
            title: BoF.text('BoF Widget Gallery').semiBold,
            trailing: [
              BoF.button(
                null,
                icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
                type: BoFButtonType.ghost,
                onPressed: () => setState(() => _isDark = !_isDark),
              ),
            ],
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoreSection(),
              DisplaySection(),
              FormFieldsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
