import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/data/repositories/invoice_repository.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_entity.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_item.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/presentation/view_models/invoice_view_model.dart';

class MockInvoiceRepository extends Mock implements InvoiceRepository {
  @override
  Future<List<Invoice>> fetchInvoices() async {
    return [
      Invoice(
        id: "TEST-001",
        clientName: "Test Client",
        date: DateTime.now(),
        items: [
          InvoiceItem(description: "Item 1", quantity: 1, unitPrice: 100)
        ],
      ),
    ];
  }
}

void main() {
  group('Unit Tests: Domain & ViewModel', () {
    test('Invoice total calculation should be correct', () {
      final item1 = InvoiceItem(description: "A", quantity: 2, unitPrice: 50);
      final item2 = InvoiceItem(description: "B", quantity: 1, unitPrice: 200);
      final invoice = Invoice(
        id: "1",
        clientName: "Test",
        date: DateTime.now(),
        items: [item1, item2],
      );

      expect(invoice.totalAmount, 300.0);
    });

    test('InvoiceViewModel state flow (Loading -> Loaded)', () async {
      final mockRepo = MockInvoiceRepository();
      final vm = InvoiceViewModel(mockRepo);

      expect(vm.isLoading, false);

      final future = vm.loadInvoices();
      expect(vm.isLoading, true);

      await future;
      expect(vm.isLoading, false);
      expect(vm.invoices.length, 1);
    });
  });
}
