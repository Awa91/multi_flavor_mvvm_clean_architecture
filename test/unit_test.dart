import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/data/repositories/invoice_repository.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_entity.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_item.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/presentation/view_models/invoice_view_model.dart';



// Manual Mock or use Mockito/Mocktail
class MockInvoiceRepository extends Mock implements InvoiceRepository {
  @override
  Future<List<Invoice>> fetchInvoices() async {
    return [
      Invoice(
        id: "TEST-001",
        clientName: "Test Client",
        date: DateTime.now(),
        items: [InvoiceItem(description: "Item 1", quantity: 1, unitPrice: 100)],
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

      // Business logic check
      expect(invoice.totalAmount, 300.0);
    });

    test('InvoiceViewModel state flow (Loading -> Loaded)', () async {
      final mockRepo = MockInvoiceRepository();
      final vm = InvoiceViewModel(mockRepo);

      expect(vm.isLoading, false);

      final future = vm.loadInvoices();
      expect(vm.isLoading, true); // Verify state changed to loading

      await future;
      expect(vm.isLoading, false); // Verify state reverted after finish
      expect(vm.invoices.length, 1);
    });
  });
}

//
// class MockInvoiceRepository extends Mock implements InvoiceRepository {
//   @override
//   Future<List<Invoice>> fetchInvoices() async {
//     return [
//       Invoice(
//         id: "TEST-001",
//         clientName: "Test Client",
//         date: DateTime.now(),
//         items: [InvoiceItem(description: "Item 1", quantity: 1, unitPrice: 100)],
//       ),
//     ];
//   }
// }
//
// void main() {
//   group('Unit Tests: Domain Logic', () {
//     test('Invoice total calculation should be correct', () {
//       final item1 = InvoiceItem(description: "A", quantity: 2, unitPrice: 50);
//       final item2 = InvoiceItem(description: "B", quantity: 1, unitPrice: 200);
//       final invoice = Invoice(
//         id: "1",
//         clientName: "Test",
//         date: DateTime.now(),
//         items: [item1, item2],
//       );
//
//       expect(invoice.totalAmount, 300.0);
//     });
//
//     test('InvoiceViewModel state flow', () async {
//       final mockRepo = MockInvoiceRepository();
//       final vm = InvoiceViewModel(mockRepo);
//
//       expect(vm.isLoading, false);
//
//       final future = vm.loadInvoices();
//       expect(vm.isLoading, true);
//
//       await future;
//       expect(vm.isLoading, false);
//       expect(vm.invoices.length, 1);
//     });
//   });
//
//   group('Widget Tests: UI & Branding', () {
//     setUp(() {
//       final locator = GetIt.instance;
//       locator.reset();
//       setupLocator(mockRepo: MockInvoiceRepository());
//     });
//
//     testWidgets('App displays correct brand title and icon', (WidgetTester tester) async {
//       await tester.pumpWidget(const MainApp());
//       await tester.pumpAndSettle();
//
//       final brand = BrandConfig.current();
//
//       // Verify Title
//       expect(find.text(brand.appTitle), findsOneWidget);
//
//       // Verify Brand Icon exists
//       expect(find.byKey(const Key('brand-icon')), findsOneWidget);
//     });
//
//     testWidgets('Navigation to details works', (WidgetTester tester) async {
//       await tester.pumpWidget(const MainApp());
//       await tester.pumpAndSettle();
//
//       // Tap the first invoice card
//       await tester.tap(find.byType(Card).first);
//       await tester.pumpAndSettle();
//
//       // Check if we are on the detail screen
//       expect(find.text("TEST-001"), findsOneWidget);
//       expect(find.text("Client: Test Client"), findsOneWidget);
//     });
//
//     testWidgets('Shows empty state when no invoices', (WidgetTester tester) async {
//       // Override repo with empty return
//       final locator = GetIt.instance;
//       locator.reset();
//       final mockEmptyRepo = MockInvoiceRepository();
//       when(mockEmptyRepo.fetchInvoices()).thenAnswer((_) async => []);
//       setupLocator(mockRepo: mockEmptyRepo);
//
//       await tester.pumpWidget(const MainApp());
//       await tester.pump(); // Start loading
//       await tester.pumpAndSettle(); // Finish loading
//
//       expect(find.byKey(const Key('empty-state')), findsOneWidget);
//     });
//   });
// }
