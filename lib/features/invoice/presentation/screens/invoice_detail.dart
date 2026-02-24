import 'package:flutter/material.dart';

import '../../domain/invoice_entity.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Invoice invoice;
  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(invoice.id)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Client: ${invoice.clientName}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text("Date: ${invoice.date.toIso8601String().split('T')[0]}"),
            const Divider(height: 40),
            const Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...invoice.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${item.description} (x${item.quantity.toInt()})",
                      ),
                    ),
                    Text("\$${item.total.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${invoice.totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
