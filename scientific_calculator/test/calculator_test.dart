import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scientific_calculator/services/calculator_service.dart';
import 'package:scientific_calculator/features/calculator/calculator_view_model.dart';

void main() {
  group('CalculatorService Tests', () {
    late CalculatorService service;

    setUp(() {
      service = CalculatorService();
    });

    test('Basic arithmetic', () {
      expect(service.evaluate('2+2'), '4');
      expect(service.evaluate('10−5'), '5');
      expect(service.evaluate('3×4'), '12');
      expect(service.evaluate('20÷5'), '4');
      expect(service.evaluate('2^3'), '8');
      expect(service.evaluate('10%'), '0.1');
    });

    test('Constants π and e', () {
      expect(service.evaluate('π').startsWith('3.14159'), isTrue);
      expect(service.evaluate('e').startsWith('2.71828'), isTrue);
      expect(service.evaluate('E').startsWith('2.71828'), isTrue);
    });

    test('Trigonometric functions in Degree mode', () {
      expect(service.evaluate('sin(90)', isDegreeMode: true), '1');
      expect(service.evaluate('cos(0)', isDegreeMode: true), '1');
      expect(service.evaluate('tan(45)', isDegreeMode: true), '1');
      expect(service.evaluate('asin(1)', isDegreeMode: true), '90');
      expect(service.evaluate('acos(1)', isDegreeMode: true), '0');
      expect(double.parse(service.evaluate('atan(1)', isDegreeMode: true)), closeTo(45.0, 0.0001));
    });

    test('Trigonometric functions in Radian mode', () {
      expect(service.evaluate('sin(0)', isDegreeMode: false), '0');
      expect(double.parse(service.evaluate('sin(π/2)', isDegreeMode: false)), closeTo(1.0, 0.0001));
      expect(service.evaluate('asin(1)', isDegreeMode: false).startsWith('1.57079'), isTrue);
    });

    test('Logarithmic and square root functions', () {
      expect(service.evaluate('log(100)'), '2');
      expect(service.evaluate('ln(e)'), '1');
      expect(service.evaluate('sqrt(16)'), '4');
      expect(service.evaluate('√25'), '5');
    });

    test('Edge cases and error handling', () {
      expect(service.evaluate('5/0'), 'Error');
      expect(service.evaluate('sqrt(-1)'), 'Error');
      expect(service.evaluate('log(-1)'), 'Error');
      expect(service.evaluate(''), '0');
      expect(service.evaluate('invalid'), 'Error');
    });

    test('Formatting results', () {
      expect(service.evaluate('1/3'), '0.3333333333');
      expect(service.evaluate('1.0000000000'), '1');
      expect(service.evaluate('1.23000'), '1.23');
    });

    test('Auto-closing parentheses', () {
      expect(service.evaluate('sin(90'), '1');
      expect(service.evaluate('((2+3'), '5');
    });
  });

  group('CalculatorViewModel Tests', () {
    late ProviderContainer container;
    late CalculatorViewModel viewModel;

    setUp(() {
      container = ProviderContainer();
      viewModel = container.read(calculatorViewModelProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state', () {
      expect(viewModel.state.currentInput, '0');
      expect(viewModel.state.resultValue, '');
      expect(viewModel.state.memoryValue, 0.0);
    });

    test('Input numbers and basic operations', () {
      viewModel.onButtonPressed('7');
      expect(viewModel.state.currentInput, '7');
      viewModel.onButtonPressed('+');
      expect(viewModel.state.currentInput, '7+');
      viewModel.onButtonPressed('3');
      expect(viewModel.state.currentInput, '7+3');
      viewModel.onButtonPressed('=');
      expect(viewModel.state.resultValue, '10');
    });

    test('Delete last character', () {
      viewModel.onButtonPressed('123');
      viewModel.onButtonPressed('⌫'); // AppConstants.keyBackspace or IconData
      expect(viewModel.state.currentInput, '12');
      viewModel.onButtonPressed('⌫');
      expect(viewModel.state.currentInput, '1');
      viewModel.onButtonPressed('⌫');
      expect(viewModel.state.currentInput, '0');
    });

    test('Clear and All Clear', () {
      viewModel.onButtonPressed('123');
      viewModel.onButtonPressed('C');
      expect(viewModel.state.currentInput, '0');
      expect(viewModel.state.resultValue, '');
    });

    test('Toggles: Deg/Rad and Inverse', () {
      expect(viewModel.state.isDegreeMode, true);
      viewModel.onButtonPressed('deg');
      expect(viewModel.state.isDegreeMode, false);

      expect(viewModel.state.isInverse, false);
      viewModel.onButtonPressed('inv');
      expect(viewModel.state.isInverse, true);
    });

    test('Memory operations (M+, M-, MR, MC)', () {
      viewModel.onButtonPressed('10');
      viewModel.onButtonPressed('m+');
      expect(viewModel.state.memoryValue, 10.0);

      viewModel.onButtonPressed('5');
      viewModel.onButtonPressed('m-');
      expect(viewModel.state.memoryValue, 5.0);

      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('mr');
      expect(viewModel.state.currentInput, '5');

      viewModel.onButtonPressed('mc');
      expect(viewModel.state.memoryValue, 0.0);
    });

    test('Scientific function appending', () {
      viewModel.onButtonPressed('sin');
      expect(viewModel.state.currentInput, 'sin(');
      
      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('inv');
      viewModel.onButtonPressed('sin');
      expect(viewModel.state.currentInput, 'asin(');
    });

    test('Special keys: π, e, %, xʸ, x²', () {
      viewModel.onButtonPressed('π');
      expect(viewModel.state.currentInput, 'π');
      
      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('xʸ');
      expect(viewModel.state.currentInput, '0^');

      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('x²');
      expect(viewModel.state.currentInput, '0^2');
    });

    test('Memory recall scenarios', () {
      // Recall to 0
      viewModel.onButtonPressed('C'); // currentInput is '0'
      viewModel.onButtonPressed('10');
      viewModel.onButtonPressed('m+');
      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('mr');
      expect(viewModel.state.currentInput, '10');

      // Recall to existing input (covers currentInput != '0' branch)
      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('5');
      viewModel.onButtonPressed('mr');
      expect(viewModel.state.currentInput, '510');
    });

    test('Function append with existing input', () {
      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('2');
      viewModel.onButtonPressed('sin');
      expect(viewModel.state.currentInput, '2sin(');
    });

    test('Special xⁿ key', () {
      viewModel.onButtonPressed('C');
      viewModel.onButtonPressed('5');
      viewModel.onButtonPressed('xⁿ');
      expect(viewModel.state.currentInput, '5^');
    });

    test('Calculate error state continue', () {
      viewModel.onButtonPressed('5');
      viewModel.onButtonPressed('÷');
      viewModel.onButtonPressed('0');
      viewModel.onButtonPressed('=');
      expect(viewModel.state.resultValue, 'Error');
      
      viewModel.onButtonPressed('+');
      expect(viewModel.state.currentInput, '0+'); // continua from 0 if error
    });
  });
}
