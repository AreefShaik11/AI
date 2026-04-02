import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/calculator_service.dart';
import '../../core/app_constants.dart';
import 'calculator_model.dart';

final calculatorServiceProvider = Provider((ref) => CalculatorService());

final calculatorViewModelProvider = NotifierProvider<CalculatorViewModel, CalculatorModel>(() {
  return CalculatorViewModel();
});

class CalculatorViewModel extends Notifier<CalculatorModel> {
  @override
  CalculatorModel build() {
    return CalculatorModel.initial();
  }

  CalculatorService get _service => ref.read(calculatorServiceProvider);

  void onButtonPressed(String buttonLabel) {
    if (state.hasComputed && _isNumberOrVariable(buttonLabel)) {
      // Start fresh calculation when pressing a number immediately after evaluating
      state = state.copyWith(
        currentInput: buttonLabel == AppConstants.keyDot ? '0.' : buttonLabel,
        resultValue: '',
        hasComputed: false,
      );
      return;
    }

    // Reset the result but keep the answer to calculate over it if it's an operator
    if (state.hasComputed && _isOperator(buttonLabel)) {
      state = state.copyWith(
        currentInput: state.resultValue == 'Error' ? '0' : state.resultValue,
        resultValue: '',
        hasComputed: false,
      );
    }

    switch (buttonLabel) {
      case AppConstants.keyClear:
      case AppConstants.keyAllClear:
        clear();
        break;
      case AppConstants.keyBackspace:
        _deleteLast();
        break;
      case AppConstants.keyEquals:
        calculateResult();
        break;
      case AppConstants.keyMc:
        memoryClear();
        break;
      case AppConstants.keyMPlus:
        memoryAdd();
        break;
      case AppConstants.keyMMinus:
        memorySubtract();
        break;
      case AppConstants.keyMr:
        memoryRecall();
        break;
      case AppConstants.keyDegRad:
        _toggleMode();
        break;
      case 'inv':
        _toggleInverse();
        break;
      case AppConstants.keySin:
      case AppConstants.keyCos:
      case AppConstants.keyTan:
      case 'asin':
      case 'acos':
      case 'atan':
      case AppConstants.keyLn:
      case AppConstants.keyLog:
      case AppConstants.keySqrt:
        _appendFunction(buttonLabel);
        break;
      case 'xⁿ':
        _append('^');
        break;
      case AppConstants.keyPower2:
        _append('^2');
        break;
      case AppConstants.keyPowerY:
        _append('^');
        break;
      default:
        _append(buttonLabel);
        break;
    }
  }

  void clear() {
    state = state.copyWith(currentInput: '0', resultValue: '', hasComputed: false);
  }

  void _deleteLast() {
    if (state.currentInput.length <= 1) {
      state = state.copyWith(currentInput: '0');
    } else {
      state = state.copyWith(currentInput: state.currentInput.substring(0, state.currentInput.length - 1));
    }
  }

  void calculateResult() {
    if (state.currentInput.isEmpty || state.currentInput == '0') return;

    final result = _service.evaluate(state.currentInput, isDegreeMode: state.isDegreeMode);
    
    final newHistory = List<String>.from(state.history);
    if (result != 'Error') {
      newHistory.insert(0, '${state.currentInput} = $result');
    }

    state = state.copyWith(
      resultValue: result,
      hasComputed: true,
      history: newHistory,
    );
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }

  void memoryAdd() {
    calculateResult();
    if (state.resultValue != 'Error') {
      final val = double.tryParse(state.resultValue) ?? 0.0;
      state = state.copyWith(memoryValue: state.memoryValue + val);
    }
  }

  void memorySubtract() {
    calculateResult();
    if (state.resultValue != 'Error') {
      final val = double.tryParse(state.resultValue) ?? 0.0;
      state = state.copyWith(memoryValue: state.memoryValue - val);
    }
  }

  void memoryRecall() {
    String memStr = state.memoryValue.toString();
    if (memStr.endsWith('.0')) memStr = memStr.substring(0, memStr.length - 2);
    
    if (state.currentInput == '0') {
      state = state.copyWith(currentInput: memStr);
    } else {
      state = state.copyWith(currentInput: state.currentInput + memStr);
    }
  }

  void memoryClear() {
    state = state.copyWith(memoryValue: 0.0);
  }

  void _toggleMode() {
    state = state.copyWith(isDegreeMode: !state.isDegreeMode);
  }

  void _toggleInverse() {
    state = state.copyWith(isInverse: !state.isInverse);
  }

  void _appendFunction(String func) {
    String toAppend = '$func(';
    if (state.isInverse) {
      if (func == 'sin' || func == 'cos' || func == 'tan') {
        toAppend = 'a$func('; // arcsin, arccos, arctan
      }
    }
    if (func == AppConstants.keySqrt) toAppend = 'sqrt(';
    if (state.currentInput == '0') {
      state = state.copyWith(currentInput: toAppend);
    } else {
      state = state.copyWith(currentInput: state.currentInput + toAppend);
    }
  }


  void _append(String val) {
    if (state.currentInput == '0' && val != AppConstants.keyDot && !_isOperator(val)) {
      state = state.copyWith(currentInput: val);
    } else {
      state = state.copyWith(currentInput: state.currentInput + val);
    }
  }

  bool _isNumberOrVariable(String val) {
    final RegExp numRegExp = RegExp(r'[0-9πe]');
    return numRegExp.hasMatch(val) || val == AppConstants.keyDot;
  }

  bool _isOperator(String val) {
    const operators = [
      AppConstants.keyAdd,
      AppConstants.keySubtract,
      AppConstants.keyDivide,
      AppConstants.keyMultiply,
      AppConstants.keyPercent,
      '^',
    ];
    return operators.contains(val) || val.startsWith('^');
  }
}
