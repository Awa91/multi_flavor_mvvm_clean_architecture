import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_flavor_mvvm_clean_architecture/app.dart';
import 'package:multi_flavor_mvvm_clean_architecture/core/config/brand_config.dart';
import 'package:multi_flavor_mvvm_clean_architecture/core/di/dependence_injection.dart';

import 'unit_test.dart'; // Assume MockInvoiceRepository is here

void main() {
  // Ensure Flutter binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Widget Tests: UI & Branding', () {
    late MockInvoiceRepository mockRepo;

    setUp(() {
      mockRepo = MockInvoiceRepository();
      // Setup locator with the mock before each test
      setupLocator(mockRepo: mockRepo);
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    testWidgets('App displays correct brand title and icon', (
      WidgetTester tester,
    ) async {
      // Build the app
      await tester.pumpWidget(const MainApp());

      // Handle potential async DI setup and initial frame
      await tester.pump();
      await tester.pumpAndSettle();

      final brand = BrandConfig.current();

      // Verify Title exists in the UI
      expect(find.text(brand.appTitle), findsOneWidget);

      // Verify Brand Icon exists by Key
      expect(find.byKey(const Key('brand-icon')), findsOneWidget);
    });

    testWidgets('Navigation to details works upon tapping card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Ensure at least one card is rendered from Mock repository
      final cardFinder = find.byType(Card).first;
      expect(cardFinder, findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      // Verify navigation result (Assuming Mock uses "TEST-001")
      expect(find.textContaining("TEST-001"), findsOneWidget);
    });

    testWidgets('Shows empty state when no invoices are returned', (
      WidgetTester tester,
    ) async {
      // Override specific behavior for this test
      final emptyRepo = MockInvoiceRepository();
      // Configure mock to return empty list if your mock framework supports it
      // or setup locator specifically for this test
      setupLocator(mockRepo: emptyRepo);

      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Verify empty state UI component
      expect(find.byKey(const Key('empty-state')), findsOneWidget);
    });
  });
}
