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
              errorBuilder: (_, _, _) => const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              "Configuration Details",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(indent: 50, endIndent: 50),
            const _DetailRow(label: "Environment", value: EnvConfig.env),
            const _DetailRow(label: "Brand", value: EnvConfig.brand),
            const _DetailRow(label: "API Key", value: EnvConfig.apiKey),
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

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late final InvoiceViewModel _viewModel;
//
//   @override
//   void initState() {
//     super.initState();
//     _viewModel = locator<InvoiceViewModel>();
//     _viewModel.loadInvoices();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final brand = BrandConfig.current();
//
//     return Scaffold(
//       appBar: AppBar(title: Text(brand.appTitle)),
//       body: ListenableBuilder(
//         listenable: _viewModel,
//         builder: (context, _) {
//           return Column(
//             children: [
//               const SizedBox(height: 20),
//               // ADDED: key for 'brand-icon' test
//               Image.asset(
//                 brand.logoPath,
//                 key: const Key('brand-icon'),
//                 width: 150,
//                 errorBuilder: (_, _, _) => const Icon(Icons.image, size: 100),
//               ),
//
//               const SizedBox(height: 10),
//               Text(
//                 "Configuration: ${EnvConfig.env} | ${EnvConfig.brand}",
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               const Divider(indent: 50, endIndent: 50),
//
//               // UI Logic to handle Loading, Empty, and List states
//               Expanded(child: _buildContent()),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     if (_viewModel.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (_viewModel.invoices.isEmpty) {
//       // ADDED: key for 'empty-state' test
//       return const Center(
//         key: Key('empty-state'),
//         child: Text("No invoices found."),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: _viewModel.invoices.length,
//       padding: const EdgeInsets.all(16),
//       itemBuilder: (context, index) {
//         final invoice = _viewModel.invoices[index];
//         // ADDED: Card widget for 'tapping card' test
//         return Card(
//           child: ListTile(
//             title: Text(invoice.clientName),
//             subtitle: Text("ID: ${invoice.id}"),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               // Mock navigation to satisfy the "TEST-001" visibility test
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Scaffold(
//                     appBar: AppBar(title: const Text("Detail")),
//                     body: Center(child: Text("Invoice ID: ${invoice.id}")),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
