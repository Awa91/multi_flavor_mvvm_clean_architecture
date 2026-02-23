

import '../../domain/invoice_entity.dart';
import '../../domain/invoice_item.dart';

class InvoiceRepository {
  // Simulated API call
  Future<List<Invoice>> fetchInvoices() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Invoice(
        id: "INV-001",
        clientName: "Design Studio X",
        date: DateTime.now(),
        items: [
          InvoiceItem(description: "UI/UX Consultation", quantity: 10, unitPrice: 150),
          InvoiceItem(description: "Logo Design", quantity: 1, unitPrice: 2000),
        ],
      ),
      Invoice(
        id: "INV-002",
        clientName: "Tech Solutions Ltd",
        date: DateTime.now().subtract(const Duration(days: 2)),
        items: [
          InvoiceItem(description: "Cloud Architecture", quantity: 5, unitPrice: 300),
        ],
      ),
    ];
  }
}