import 'package:flutter/material.dart';

import '../../../../core/config/brand_config.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/di/dependence_injection.dart';
import '../../../font/font_view_model.dart';
import '../view_models/invoice_view_model.dart';
import 'invoice_detail.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  late final InvoiceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<InvoiceViewModel>();
    _viewModel.loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    final brand = BrandConfig.current();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              brand.logoPath,
              key: const Key('brand-icon'),
              // Keeping the key for your widget tests
              width: 100, // Adjust size as needed
              height: 100,
            ),
            const SizedBox(width: 12),
            Text(brand.appTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showConfigSheet(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: _viewModel.invoices.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final invoice = _viewModel.invoices[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
                  title: Text(
                    invoice.clientName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${invoice.id} • ${invoice.date.day}/${invoice.date.month}/${invoice.date.year}",
                  ),
                  trailing: Text(
                    "\$${invoice.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InvoiceDetailScreen(invoice: invoice),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("New Invoice"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showConfigSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Environment Details",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            const _DetailRow(label: "Environment", value: EnvConfig.env),
            const _DetailRow(label: "Brand", value: EnvConfig.brand),
            const _DetailRow(label: "API Base", value: EnvConfig.apiKey),
            _DetailRow(
              label: "WiFi Active",
              value: locator<FontViewModel>().isWifi
                  ? "Yes (HQ Fonts)"
                  : "No (System Fonts)",
            ),
            const SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
