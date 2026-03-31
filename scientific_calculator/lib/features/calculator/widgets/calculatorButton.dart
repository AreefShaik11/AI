import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/appConstants.dart';

class CalculatorButton extends StatelessWidget {
  final dynamic label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool isBold;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 28,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String semanticLabel = _getSemanticLabel(label is String ? label : 'icon');

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: label is Widget 
              ? label 
              : Text(
                  label.toString(),
                  style: GoogleFonts.manrope(
                    fontSize: fontSize,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                    color: textColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }

  String _getSemanticLabel(String buttonLabel) {
    switch (buttonLabel) {
      case AppConstants.keyAdd:
        return 'btnAdd';
      case AppConstants.keySubtract:
        return 'btnSubtract';
      case AppConstants.keyMultiply:
        return 'btnMultiply';
      case AppConstants.keyDivide:
        return 'btnDivide';
      case AppConstants.keySin:
        return 'btnSin';
      case AppConstants.keyCos:
        return 'btnCos';
      case AppConstants.keyTan:
        return 'btnTan';
      case AppConstants.keyEquals:
        return 'btnEquals';
      case AppConstants.keyClear:
      case AppConstants.keyAllClear:
        return 'btnClear';
      default:
        return 'btn$buttonLabel';
    }
  }
}

