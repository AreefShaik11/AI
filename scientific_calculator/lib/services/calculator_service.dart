import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  /// Evaluates a mathematical expression string and returns the result.
  /// Handles basic and scientific operations.
  String evaluate(String expression, {bool isDegreeMode = true}) {
    if (expression.isEmpty) return '0';

    try {
      String evalExpression = _preprocessExpression(expression, isDegreeMode);
      
      final p = GrammarParser();
      final exp = p.parse(evalExpression);
      ContextModel cm = ContextModel();

      // Ensure 'pi' and 'e' are bound if math_expressions requires it, though it usually handles it.
      // We will explicitly inject them just in case.
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      // ignore: deprecated_member_use
      final double evalResult = exp.evaluate(EvaluationType.REAL, cm);
      
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
        .replaceAll('π', math.pi.toString())
        .replaceAll('e', math.e.toString())
        .replaceAll('E', math.e.toString()); // Both lowercase and uppercase E

    // For sqrt, we replace `√` with `sqrt(` and ensure it's closed later
    result = result.replaceAll('√', 'sqrt(');

    // Standardize inverse trig function names for math_expressions (asin -> arcsin etc.)
    result = result.replaceAll('asin(', 'arcsin(');
    result = result.replaceAll('acos(', 'arccos(');
    result = result.replaceAll('atan(', 'arctan(');

    // Handle log base 10 (math_expressions expects 2 arguments for log(b, x))
    // We replace log( with (1/ln(10))*ln( 
    result = result.replaceAll('log(', '(1/2.302585092994046)*ln(');

    // Handle percentage: simply convert X% to (X/100).
    // Using regex to accurately capture percentage suffix.
    result = result.replaceAll(RegExp(r'%'), '/100');

    // Handle Degree/Radian conversion for Trigonometric functions
    if (isDegreeMode) {
      // Inverse Trig: Convert Result (Rad -> Deg)
      // For arcsin(x), the result is in Radians. We multiply by (180/pi) to get Degrees.
      final rad2deg = '(${180 / math.pi})*';
      result = result.replaceAll('arcsin(', '${rad2deg}arcsin(');
      result = result.replaceAll('arccos(', '${rad2deg}arccos(');
      result = result.replaceAll('arctan(', '${rad2deg}arctan(');

      // Normal Trig: Convert Input (Deg -> Rad)
      // For sin(x), the input is in Degrees. We multiply by (pi/180) to get Radians.
      // We use word boundaries (\b) to ensure 'sin(' doesn't match 'arcsin('
      final deg2rad = '(${math.pi / 180})*';
      result = result.replaceAll(RegExp(r'\bsin\('), 'sin($deg2rad');
      result = result.replaceAll(RegExp(r'\bcos\('), 'cos($deg2rad');
      result = result.replaceAll(RegExp(r'\btan\('), 'tan($deg2rad');
    }

    // Handle missing closing parentheses to allow evaluating 'sin(30' directly
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
