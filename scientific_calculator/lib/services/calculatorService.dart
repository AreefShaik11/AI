import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  /// Evaluates a mathematical expression string and returns the result.
  /// Handles basic and scientific operations.
  String evaluate(String expression, {bool isDegreeMode = true}) {
    if (expression.isEmpty) return '0';

    try {
      String evalExpression = _preprocessExpression(expression, isDegreeMode);
      
      Parser p = Parser();
      Expression exp = p.parse(evalExpression);
      ContextModel cm = ContextModel();

      // Ensure 'pi' and 'e' are bound if math_expressions requires it, though it usually handles it.
      // We will explicitly inject them just in case.
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      double evalResult = exp.evaluate(EvaluationType.REAL, cm);
      
      if (evalResult.isNaN) return 'Error';
      if (evalResult.isInfinite) return 'Error';

      return _formatResult(evalResult);
    } catch (e) {
      return 'Error';
    }
  }

  String _preprocessExpression(String exp, bool isDegreeMode) {
    String result = exp
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('π', 'pi')
        .replaceAll('E', 'e'); // 'e' is used for the constant

    // math_expressions uses '^' for power, so 'x^y' should just be '^'
    // For sqrt, we replace `√` or `sqrt`
    result = result.replaceAll('√', 'sqrt');

    // Handle log base 10 (math_expressions expects 2 arguments for log(b, x))
    // We replace log( with (1/ln(10))*ln( 
    result = result.replaceAll('log(', '(1/2.302585092994046)*ln(');

    // Handle percentage: simply convert X% to (X/100).
    // Using regex to accurately capture percentage suffix.
    result = result.replaceAll(RegExp(r'%'), '/100');

    // Handle Degree to Radian conversion for Trigonometric functions
    // The user presses 'sin' producing 'sin('
    if (isDegreeMode) {
      // (pi/180) = 0.017453292519943295
      const deg2rad = '(pi/180)*';
      result = result.replaceAll('sin(', 'sin($deg2rad');
      result = result.replaceAll('cos(', 'cos($deg2rad');
      result = result.replaceAll('tan(', 'tan($deg2rad');
    }

    // Handle missing closing parentheses to allow evaluating 'sin(30' directly
    int openP = '^'.allMatches(result).length; // Just a placeholder, actually we need to count manually
    int openCount = 0;
    int closeCount = 0;
    for (int i = 0; i < result.length; i++) {
      if (result[i] == '(') openCount++;
      if (result[i] == ')') closeCount++;
    }
    
    // Append missing closing parentheses
    while (openCount > closeCount) {
      result += ')';
      closeCount++;
    }

    return result;
  }

  String _formatResult(double result) {
    // If the number is effectively an integer
    if (result == result.truncateToDouble()) {
      return result.truncate().toString();
    }
    
    // We limit precision to prevent extremely long decimals like 0.3333333333333333
    // but avoid formatting it into e-notation unnecessarily if it's typical.
    String str = result.toStringAsPrecision(10);
    // Remove trailing zeros in decimal part and then remove trailing decimal point if any
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return str;
  }
}
