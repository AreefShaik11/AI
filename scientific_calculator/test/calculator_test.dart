import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scientific_calculator/services/calculatorService.dart';
import 'package:scientific_calculator/features/calculator/calculatorViewModel.dart';
import 'package:scientific_calculator/features/calculator/calculatorModel.dart';
import 'dart:math' as math;

void main() {
  group('CalculatorService Tests', () {
    late CalculatorService service;

    setUp(() {
      service = CalculatorService();
    });

    test('Addition, subtraction, multiplication, division', () {
      expect(service.evaluate('2+2'), '4');
      expect(service.evaluate('10−5'), '5'); // using unicode minus
      expect(service.evaluate('3×4'), '12'); // using unicode multiply
      expect(service.evaluate('20÷5'), '4'); // using unicode divide
    });

    test('Scientific functions (sin, log, sqrt)', () {
      // isDegreeMode is true by default
      expect(service.evaluate('sin(90)', isDegreeMode: true), '1');
      expect(service.evaluate('cos(0)', isDegreeMode: true), '1');
      expect(service.evaluate('log(100)'), '2'); // math_expressions log is natural log or base 10? math_expressions log is natural log, wait... NO, math.log is natural log, log10 is base 10. math_expressions 'ln' is natural log and 'log' is base 10. 
      // Let's test sqrt
      expect(service.evaluate('sqrt(16)'), '4');
    });

    test('Parentheses support', () {
      expect(service.evaluate('(2+3)×4'), '20');
      expect(service.evaluate('2+(3×4)'), '14');
    });

    test('Edge cases: division by zero', () {
      final res = service.evaluate('5÷0');
      expect(res == 'Error' || res == 'Infinity', isTrue);
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

    test('Input numbers and basic operations updates state', () {
      viewModel.onButtonPressed('7');
      expect(viewModel.state.currentInput, '7');
      viewModel.onButtonPressed('+');
      expect(viewModel.state.currentInput, '7+');
      viewModel.onButtonPressed('3');
      expect(viewModel.state.currentInput, '7+3');
    });

    test('Calculate exact result', () {
      viewModel.onButtonPressed('7');
      viewModel.onButtonPressed('+');
      viewModel.onButtonPressed('5');
      viewModel.onButtonPressed('=');
      expect(viewModel.state.resultValue, '12');
      expect(viewModel.state.hasComputed, true);
    });

    test('Clear button resets state', () {
      viewModel.onButtonPressed('7');
      viewModel.onButtonPressed('+');
      viewModel.onButtonPressed('C');
      expect(viewModel.state.currentInput, '0');
      expect(viewModel.state.resultValue, '');
      expect(viewModel.state.hasComputed, false);
    });

    test('Memory buttons function properly', () {
      viewModel.onButtonPressed('5');
      viewModel.onButtonPressed('m+');
      expect(viewModel.state.memoryValue, 5.0);
      expect(viewModel.state.resultValue, '5'); // evaluates to 5 and adds to memory
      
      viewModel.onButtonPressed('C');
      expect(viewModel.state.currentInput, '0');
      
      viewModel.onButtonPressed('mr');
      expect(viewModel.state.currentInput, '5');
    });

    test('Invalid expression', () {
      viewModel.onButtonPressed('5');
      viewModel.onButtonPressed('+');
      viewModel.onButtonPressed('=');
      // Should give Error
      expect(viewModel.state.resultValue, 'Error');
    });
  });
}
