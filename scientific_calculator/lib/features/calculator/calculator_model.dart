class CalculatorModel {
  final String currentInput;
  final String resultValue;
  final bool isDegreeMode;
  final bool isInverse;
  final double memoryValue;
  final bool hasComputed; // True if '=' was just pressed
  final List<String> history;

  const CalculatorModel({
    required this.currentInput,
    required this.resultValue,
    required this.isDegreeMode,
    required this.isInverse,
    required this.memoryValue,
    required this.hasComputed,
    this.history = const [],
  });

  factory CalculatorModel.initial() {
    return const CalculatorModel(
      currentInput: '0',
      resultValue: '',
      isDegreeMode: true,
      isInverse: false,
      memoryValue: 0.0,
      hasComputed: false,
      history: [],
    );
  }

  CalculatorModel copyWith({
    String? currentInput,
    String? resultValue,
    bool? isDegreeMode,
    bool? isInverse,
    double? memoryValue,
    bool? hasComputed,
    List<String>? history,
  }) {
    return CalculatorModel(
      currentInput: currentInput ?? this.currentInput,
      resultValue: resultValue ?? this.resultValue,
      isDegreeMode: isDegreeMode ?? this.isDegreeMode,
      isInverse: isInverse ?? this.isInverse,
      memoryValue: memoryValue ?? this.memoryValue,
      hasComputed: hasComputed ?? this.hasComputed,
      history: history ?? this.history,
    );
  }
}


