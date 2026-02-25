import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:multi_flavor_mvvm_clean_architecture/core/di/dependence_injection.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_entity.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_item.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/presentation/screens/invoice_list.dart';

import '../test/unit_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final locator = GetIt.instance;

  group('End-to-End Test', () {
    setUp(() async {
      // Allow re-registering mocks over real services for the test
      locator.allowReassignment = true;
      await locator.reset();
    });

    testWidgets('Full flow: Load list and view details', (
      WidgetTester tester,
    ) async {
      // 1. Setup the mock repository
      final mockInvoice = Invoice(
        id: "TEST-001",
        clientName: "Test Client",
        date: DateTime.now(),
        items: [
          InvoiceItem(description: "Item 1", quantity: 1, unitPrice: 100),
        ],
      );

      setupLocator(
        mockRepo: MockInvoiceRepository(stubbedInvoices: [mockInvoice]),
      );

      // 2. Start the app
      await tester.pumpWidget(const MaterialApp(home: InvoiceListScreen()));

      // 3. Wait for the mock data to populate the UI
      // CI often needs a physical time gap for Async work
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // 4. Diagnostic: If this fails, the list didn't render TEST-001
      final cardFinder = find.textContaining('TEST-001');
      expect(
        cardFinder,
        findsOneWidget,
        reason: "Could not find the invoice card with ID TEST-001",
      );

      // 5. Tap and transition
      await tester.tap(cardFinder);

      // Wait for the navigation animation to finish completely
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 6. Verify detail screen
      expect(find.text('TEST-001'), findsOneWidget);
    });
  });
}

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   final locator = GetIt.instance;
//
//   group('End-to-End Test', () {
//     testWidgets('Full flow: Load list and view details', (tester) async {
//       // 1. Reset and Setup Mock Injection before app starts
//       await locator.reset();
//
//       // Manually register the mock repo so app.main()
//       // uses this instead of the real one
//       final mockInvoice = Invoice(
//         id: "INV-001",
//         clientName: "Design Studio X",
//         date: DateTime.now(),
//         items: [
//           InvoiceItem(
//             description: "UI/UX Consultation",
//             quantity: 10,
//             unitPrice: 100,
//           ),
//         ],
//       );
//
//       locator.registerSingleton<InvoiceRepository>(
//         MockInvoiceRepository(stubbedInvoices: [mockInvoice]),
//       );
//
//       // 2. Start the App
//       app.main();
//       await tester.pumpAndSettle();
//
//       // 3. Verify list is loaded (Now this will pass!)
//       expect(find.text('Design Studio X'), findsOneWidget);
//
//       // 4. Tap invoice
//       await tester.tap(find.text('Design Studio X'));
//       await tester.pumpAndSettle();
//
//       // 5. Verify detail screen content
//       expect(find.text('INV-001'), findsOneWidget);
//       expect(find.textContaining('UI/UX Consultation'), findsOneWidget);
//
//       // 6. Go back
//       await tester.pageBack();
//       await tester.pumpAndSettle();
//
//       expect(find.text('Design Studio X'), findsOneWidget);
//     });
//   });
//}

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
