import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/config/brand_config.dart';
import 'core/config/env_config.dart';
import 'core/di/dependence_injection.dart';
import 'features/font/font_view_model.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = BrandConfig.current();
    final fontVM = locator<FontViewModel>();

    return ListenableBuilder(
      listenable: fontVM,
      builder: (context, _) {
        return MaterialApp(
          title: brand.appTitle,
          theme: brand.themeData.copyWith(
            textTheme: GoogleFonts.getTextTheme(
              brand.fontName,
              brand.themeData.textTheme,
            ).apply(fontFamily: null), // System font fallback
          ),
          debugShowCheckedModeBanner: !EnvConfig.isProduction,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = BrandConfig.current();

    return Scaffold(
      appBar: AppBar(title: Text(brand.appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // This image is swapped by the CI/CD script
            Image.asset(
              brand.logoPath,
              width: 150,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              "Configuration Details",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(indent: 50, endIndent: 50),
            _DetailRow(label: "Environment", value: EnvConfig.env),
            _DetailRow(label: "Brand", value: EnvConfig.brand),
            _DetailRow(label: "API Key", value: EnvConfig.apiKey),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text("$label: $value"),
    );
  }
}
