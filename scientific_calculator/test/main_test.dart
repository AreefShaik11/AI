import 'package:flutter_test/flutter_test.dart';
import 'package:scientific_calculator/main.dart' as app;

void main() {
  testWidgets('Main entry point test', (WidgetTester tester) async {
    // Calling the actual main() function of the app
    // Note: This might cause issues if main() has async logic or setup that conflicts with tests
    // But for this simple app, it should be fine to hit the coverage.
    app.main();
    await tester.pump();
    
    // Check if the app rendered
    expect(find.byType(app.MyApp), findsOneWidget);
  });
}
