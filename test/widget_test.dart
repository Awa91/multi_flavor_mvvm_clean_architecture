// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
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

    testWidgets('App displays correct brand title and icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      final brand = BrandConfig.current();

      // Verify Title exists in the UI
      expect(find.text(brand.appTitle), findsOneWidget);

      // Verify Brand Icon exists by Key
      expect(find.byKey(const Key('brand-icon')), findsOneWidget);
    });

    testWidgets('Navigation to details works upon tapping card',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Tap the first invoice card found in the list
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Verify navigation result
      expect(find.text("TEST-001"), findsOneWidget);
      expect(find.text("Client: Test Client"), findsOneWidget);
    });

    testWidgets('Shows empty state when no invoices are returned',
        (WidgetTester tester) async {
      final locator = GetIt.instance;
      locator.reset();

      final mockEmptyRepo = MockInvoiceRepository();
      // If using Mockito/Mocktail, you can stub the behavior:
      // when(mockEmptyRepo.fetchInvoices()).thenAnswer((_) async => []);

      setupLocator(mockRepo: mockEmptyRepo);

      await tester.pumpWidget(const MainApp());
      await tester.pump(); // Start the build
      await tester.pumpAndSettle(); // Wait for animation/data

      expect(find.byKey(const Key('empty-state')), findsOneWidget);
    });
  });
}

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:multi_flavor_mvvm_clean_architecture/main.dart';
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());
//
//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();
//
//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
