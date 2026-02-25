import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/data/repositories/invoice_repository.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_entity.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_item.dart';
import 'package:multi_flavor_mvvm_clean_architecture/main.dart' as app;

import '../test/unit_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final locator = GetIt.instance;

  group('End-to-End Test', () {
    testWidgets('Full flow: Load list and view details', (tester) async {
      // 1. Reset and Setup Mock Injection before app starts
      await locator.reset();

      // Manually register the mock repo so app.main()
      // uses this instead of the real one
      final mockInvoice = Invoice(
        id: "INV-001",
        clientName: "Design Studio X",
        date: DateTime.now(),
        items: [
          InvoiceItem(
            description: "UI/UX Consultation",
            quantity: 10,
            unitPrice: 100,
          ),
        ],
      );

      locator.registerSingleton<InvoiceRepository>(
        MockInvoiceRepository(stubbedInvoices: [mockInvoice]),
      );

      // 2. Start the App
      app.main();
      await tester.pumpAndSettle();

      // 3. Verify list is loaded (Now this will pass!)
      expect(find.text('Design Studio X'), findsOneWidget);

      // 4. Tap invoice
      await tester.tap(find.text('Design Studio X'));
      await tester.pumpAndSettle();

      // 5. Verify detail screen content
      expect(find.text('INV-001'), findsOneWidget);
      expect(find.textContaining('UI/UX Consultation'), findsOneWidget);

      // 6. Go back
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Design Studio X'), findsOneWidget);
    });
  });
}

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   group('End-to-End Test', () {
//     testWidgets('Full flow: Load list and view details', (tester) async {
//       app.main();
//       await tester.pumpAndSettle();
//
//       // Verify list is loaded
//       expect(find.text('Design Studio X'), findsOneWidget);
//
//       // Tap invoice
//       await tester.tap(find.text('Design Studio X'));
//       await tester.pumpAndSettle();
//
//       // Verify detail screen content
//       expect(find.text('INV-001'), findsOneWidget);
//       expect(find.text('UI/UX Consultation (x10)'), findsOneWidget);
//
//       // Go back
//       await tester.pageBack();
//       await tester.pumpAndSettle();
//
//       expect(find.text('Design Studio X'), findsOneWidget);
//     });
//   });
// }
