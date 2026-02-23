import 'package:flutter_test/flutter_test.dart';
import 'package:multi_flavor_mvvm_clean_architecture/main.dart' as app;
import 'package:integration_test/integration_test.dart';



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Full flow: Load list and view details', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify list is loaded
      expect(find.text('Design Studio X'), findsOneWidget);

      // Tap invoice
      await tester.tap(find.text('Design Studio X'));
      await tester.pumpAndSettle();

      // Verify detail screen content
      expect(find.text('INV-001'), findsOneWidget);
      expect(find.text('UI/UX Consultation (x10)'), findsOneWidget);

      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Design Studio X'), findsOneWidget);
    });
  });
}
