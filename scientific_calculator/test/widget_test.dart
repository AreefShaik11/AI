import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scientific_calculator/main.dart';
import 'package:scientific_calculator/features/calculator/calculator_view.dart';
import 'package:scientific_calculator/features/calculator/widgets/calculator_button.dart';

void main() {
  testWidgets('CalculatorView renders and buttons update display', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Verify initial state
    expect(find.text('0'), findsAtLeastNWidgets(1));
    expect(find.text('Scientific'), findsOneWidget);

    // Tap a number button
    await tester.tap(find.text('7'));
    await tester.pump();

    // Verify display updated
    expect(find.text('7'), findsAtLeastNWidgets(2)); // One in button, one in display

    // Tap operator
    await tester.tap(find.text('+'));
    await tester.pump();
    
    await tester.tap(find.text('3'));
    await tester.pump();
    
    await tester.tap(find.text('='));
    await tester.pump();

    // Verify result
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('CalculatorButton semantics and styling', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalculatorButton(
            label: 'Test',
            onTap: () => tapped = true,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            id: 'test_btn',
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
    
    // Test Tap
    await tester.tap(find.text('Test'));
    expect(tapped, true);

    // Test Semantics
    final semantics = tester.getSemantics(find.byType(CalculatorButton));
    expect(semantics.identifier, 'test_btn');
  });

  testWidgets('History modal interaction', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Perform a calculation to generate history
    await tester.tap(find.text('5'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('='));
    await tester.pump();

    // Open history
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    expect(find.text('History'), findsOneWidget);
    expect(find.text('5+5 = 10'), findsOneWidget);
    
    // Tap the history item to restore it
    await tester.tap(find.text('5+5 = 10'));
    await tester.pumpAndSettle();
    
    // Verify it's back in display
    expect(find.text('5+5'), findsAtLeastNWidgets(1));
    
    // Open history again to test clear history functionality
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    // Tap "Clear" button in history modal
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(find.text('History'), findsNothing);

    // Open empty history
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(find.text('No history yet'), findsOneWidget);
    
    // Tap outside to close (offset 10,10 is usually safe for safety)
    await tester.tapAt(const Offset(10, 10)); 
    await tester.pumpAndSettle();
  });

  testWidgets('Button interactions: clear, backspace, operators', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.tap(find.text('8'));
    await tester.tap(find.text('9'));
    await tester.pump();
    expect(find.text('89'), findsAtLeastNWidgets(1));

    // Use byIcon for backspace as it's rendered as an Icon
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    expect(find.text('8'), findsAtLeastNWidgets(2)); // Display and button

    await tester.tap(find.text('C'));
    await tester.pump();
    expect(find.text('0'), findsAtLeastNWidgets(1));
  });

  testWidgets('Toggles updating UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Initially RAD (isDegreeMode = false is RAD) - wait, let's check initial
    // In CalculatorModel.initial(), isDegreeMode = true.
    // So DEG is active.
    
    // Tap RAD chip (RAD is initially NOT active, DEG is active)
    await tester.tap(find.text('RAD'));
    await tester.pump();
    
    // Tap DEG chip (to cover the other branch and toggle back)
    await tester.tap(find.text('DEG'));
    await tester.pump();
    
    // Tap INV button
    await tester.tap(find.text('inv'));
    await tester.pump();
    
    // Verify "2nd" indicator appears
    expect(find.text('2nd'), findsOneWidget);
    
    // Verify sin becomes asin
    expect(find.text('asin'), findsOneWidget);
  });
}
