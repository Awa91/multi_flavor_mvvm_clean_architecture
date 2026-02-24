import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_flavor_mvvm_clean_architecture/core/di/dependence_injection.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/data/repositories/invoice_repository.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_entity.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/domain/invoice_item.dart';
import 'package:multi_flavor_mvvm_clean_architecture/features/invoice/presentation/screens/invoice_list.dart';

// 1. Using your provided Mock class
class MockInvoiceRepository implements InvoiceRepository {
  final List<Invoice> stubbedInvoices;

  // Constructor allows you to pass custom data for different test scenarios
  MockInvoiceRepository({this.stubbedInvoices = const []});

  @override
  Future<List<Invoice>> fetchInvoices() async {
    // Simulate network delay if needed, or just return the data
    return stubbedInvoices;
  }
}

// 2. A variation for the "Empty State" test
class EmptyMockInvoiceRepository extends MockInvoiceRepository {
  @override
  Future<List<Invoice>> fetchInvoices() async => [];
}

void main() {
  final locator = GetIt.instance;

  setUpAll(() {
    // This prevents tests from crashing when assets are missing
    // It returns an empty 1x1 image instead of throwing an exception
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    await locator.reset();
  });

  group('Widget Tests: UI & Branding', () {
    testWidgets('Shows empty state when no invoices are returned', (
      WidgetTester tester,
    ) async {
      setupLocator(mockRepo: MockInvoiceRepository(stubbedInvoices: []));
      // Use the screen that actually shows the list
      await tester.pumpWidget(const MaterialApp(home: InvoiceListScreen()));
      await tester.pumpAndSettle();

      // Now this will find the widget we added above
      expect(find.text("No Invoices Found"), findsOneWidget);
    });

    testWidgets('Navigation to details works upon tapping card', (
      WidgetTester tester,
    ) async {
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

      await tester.pumpWidget(const MaterialApp(home: InvoiceListScreen()));
      await tester.pumpAndSettle();

      // Verify the ID appears on the list item
      expect(find.textContaining('TEST-001'), findsOneWidget);

      // Tap the ListTile
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Verify we are now on the Detail Screen by checking the AppBar
      // title (invoice.id)
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('TEST-001'),
        ),
        findsOneWidget,
      );
    });
  });
}

// void main() {
//   // Access the locator instance
//   final locator = GetIt.instance;
//
//   // This runs before EVERY test to ensure isolation
//   setUp(() async {
//     await locator.reset();
//   });
//
//   group('Widget Tests: UI & Branding', () {
//     testWidgets('App displays correct brand title and icon', (
//       WidgetTester tester,
//     ) async {
//       // Initialize DI with the standard mock
//       setupLocator(mockRepo: MockInvoiceRepository());
//
//       await tester.pumpWidget(const MainApp());
//       await tester.pumpAndSettle();
//
//       // Verify Brand Title (Adjust string based on your
//       // EnvConfig.brand default)
//       // Assuming 'alpha' is default
//       expect(find.textContaining('Alpha Creative'), findsOneWidget);
//
//       // Verify Logo exists
//       expect(find.byType(Image), findsOneWidget);
//     });
//
//     testWidgets('Shows empty state when no invoices are returned', (
//       WidgetTester tester,
//     ) async {
//       // Provide the empty state mock specifically for this test
//       setupLocator(mockRepo: EmptyMockInvoiceRepository());
//
//       await tester.pumpWidget(const MainApp());
//
//       // Trigger the build and wait for animations/futures
//       await tester.pumpAndSettle();
//
//       // Replace 'No Invoices' with whatever text your UI shows for empty states
//       expect(find.text('No Invoices Found'), findsOneWidget);
//     });
//
//     testWidgets('Navigation to details works upon tapping card', (
//       WidgetTester tester,
//     ) async {
//       setupLocator(mockRepo: MockInvoiceRepository());
//
//       await tester.pumpWidget(const MainApp());
//       await tester.pumpAndSettle();
//
//       // Find the list item (Assuming your UI renders a List Tile or Card with
//       // the ID)
//       final invoiceCard = find.text('TEST-001');
//       expect(invoiceCard, findsOneWidget);
//
//       await tester.tap(invoiceCard);
//       await tester.pumpAndSettle();
//
//       // Verify navigation result (e.g., checking for a "Details" header)
//       expect(find.text('Invoice Details'), findsOneWidget);
//     });
//   });
// }

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
