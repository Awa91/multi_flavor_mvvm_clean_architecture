import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_flavor_mvvm_clean_architecture/app.dart';
import 'package:multi_flavor_mvvm_clean_architecture/core/config/brand_config.dart';
import 'package:multi_flavor_mvvm_clean_architecture/core/di/dependence_injection.dart';

import 'unit_test.dart';

void main() {
  group('Widget Tests: UI & Branding', () {
    setUp(() {
      final locator = GetIt.instance;
      locator.reset();
      // Assume setupLocator handles DI registration
      setupLocator(mockRepo: MockInvoiceRepository());
    });

    testWidgets('App displays correct brand title and icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());
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

      // Tap the first invoice card found in the list
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Verify navigation result
      expect(find.text("TEST-001"), findsOneWidget);
      expect(find.text("Client: Test Client"), findsOneWidget);
    });

    testWidgets('Shows empty state when no invoices are returned', (
      WidgetTester tester,
    ) async {
      final locator = GetIt.instance;
      await locator.reset();

      final mockEmptyRepo = MockInvoiceRepository();

      setupLocator(mockRepo: mockEmptyRepo);

      await tester.pumpWidget(const MainApp());
      await tester.pump(); // Start the build
      await tester.pumpAndSettle(); // Wait for animation/data

      expect(find.byKey(const Key('empty-state')), findsOneWidget);
    });
  });
}
