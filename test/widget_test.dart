import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:multi_flavor_mvvm_clean_architecture/app.dart';
//import 'package:multi_flavor_mvvm_clean_architecture/core/config/brand_config.dart';
import 'package:multi_flavor_mvvm_clean_architecture/core/di/dependence_injection.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/data/repositories/invoice_repository.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_entity.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_item.dart';

//import 'unit_test.dart';

// 1. Using your provided Mock class
class MockInvoiceRepository extends Mock implements InvoiceRepository {
  @override
  Future<List<Invoice>> fetchInvoices() async {
    // Return a default list for success cases
    return [
      Invoice(
        id: "TEST-001",
        clientName: "Test Client",
        date: DateTime.now(),
        items: [
          InvoiceItem(description: "Item 1", quantity: 1, unitPrice: 100),
        ],
      ),
    ];
  }
}

// 2. A variation for the "Empty State" test
class EmptyMockInvoiceRepository extends MockInvoiceRepository {
  @override
  Future<List<Invoice>> fetchInvoices() async => [];
}

void main() {
  // Access the locator instance
  final locator = GetIt.instance;

  // This runs before EVERY test to ensure isolation
  setUp(() async {
    await locator.reset();
  });

  group('Widget Tests: UI & Branding', () {
    testWidgets('App displays correct brand title and icon', (
      WidgetTester tester,
    ) async {
      // Initialize DI with the standard mock
      setupLocator(mockRepo: MockInvoiceRepository());

      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Verify Brand Title (Adjust string based on your
      // EnvConfig.brand default)
      // Assuming 'alpha' is default
      expect(find.textContaining('Alpha Creative'), findsOneWidget);

      // Verify Logo exists
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Shows empty state when no invoices are returned', (
      WidgetTester tester,
    ) async {
      // Provide the empty state mock specifically for this test
      setupLocator(mockRepo: EmptyMockInvoiceRepository());

      await tester.pumpWidget(const MainApp());

      // Trigger the build and wait for animations/futures
      await tester.pumpAndSettle();

      // Replace 'No Invoices' with whatever text your UI shows for empty states
      expect(find.text('No Invoices Found'), findsOneWidget);
    });

    testWidgets('Navigation to details works upon tapping card', (
      WidgetTester tester,
    ) async {
      setupLocator(mockRepo: MockInvoiceRepository());

      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Find the list item (Assuming your UI renders a List Tile or Card with
      // the ID)
      final invoiceCard = find.text('TEST-001');
      expect(invoiceCard, findsOneWidget);

      await tester.tap(invoiceCard);
      await tester.pumpAndSettle();

      // Verify navigation result (e.g., checking for a "Details" header)
      expect(find.text('Invoice Details'), findsOneWidget);
    });
  });
}

// void main() {
//   // Ensure Flutter binding is initialized
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   group('Widget Tests: UI & Branding', () {
//     late MockInvoiceRepository mockRepo;
//
//     setUp(() {
//       mockRepo = MockInvoiceRepository();
//       // Setup locator with the mock before each test
//       setupLocator(mockRepo: mockRepo);
//     });
//
//     tearDown(() async {
//       await GetIt.instance.reset();
//     });
//
//     testWidgets('App displays correct brand title and icon', (
//       WidgetTester tester,
//     ) async {
//       // Build the app
//       await tester.pumpWidget(const MainApp());
//
//       // Handle potential async DI setup and initial frame
//       await tester.pump();
//       await tester.pumpAndSettle();
//
//       final brand = BrandConfig.current();
//
//       // Verify Title exists in the UI
//       expect(find.text(brand.appTitle), findsOneWidget);
//
//       // Verify Brand Icon exists by Key
//       expect(find.byKey(const Key('brand-icon')), findsOneWidget);
//     });
//
//     testWidgets('Navigation to details works upon tapping card', (
//       WidgetTester tester,
//     ) async {
//       await tester.pumpWidget(const MainApp());
//       await tester.pumpAndSettle();
//
//       // Ensure at least one card is rendered from Mock repository
//       final cardFinder = find.byType(Card).first;
//       expect(cardFinder, findsOneWidget);
//
//       await tester.tap(cardFinder);
//       await tester.pumpAndSettle();
//
//       // Verify navigation result (Assuming Mock uses "TEST-001")
//       expect(find.textContaining("TEST-001"), findsOneWidget);
//     });
//
//     testWidgets('Shows empty state when no invoices are returned', (
//       WidgetTester tester,
//     ) async {
//       // Override specific behavior for this test
//       final emptyRepo = MockInvoiceRepository();
//       // Configure mock to return empty list if your mock framework supports it
//       // or setup locator specifically for this test
//       setupLocator(mockRepo: emptyRepo);
//
//       await tester.pumpWidget(const MainApp());
//       await tester.pumpAndSettle();
//
//       // Verify empty state UI component
//       expect(find.byKey(const Key('empty-state')), findsOneWidget);
//     });
//   });
// }
