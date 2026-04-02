import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_constants.dart';

class CalculatorButton extends StatelessWidget {
  final dynamic label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final bool isBold;
  final String? id; // Explicit ID for automation

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 28,
    this.isBold = false,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    // Priority: Explicit id -> Generated semantic label
    String semanticLabel = id ?? _getSemanticLabel(label is String ? label : '_icon');

    return Semantics(
      identifier: semanticLabel, // Provide the ID for Maestro
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
    if (buttonLabel == '_icon') return 'btn_icon';
    
    switch (buttonLabel) {
      case AppConstants.keyAdd:
        return 'btn_add';
      case AppConstants.keySubtract:
        return 'btn_subtract';
      case AppConstants.keyMultiply:
        return 'btn_multiply';
      case AppConstants.keyDivide:
        return 'btn_divide';
      case AppConstants.keySin:
        return 'btn_sin';
      case AppConstants.keyCos:
        return 'btn_cos';
      case AppConstants.keyTan:
        return 'btn_tan';
      case 'asin':
        return 'btn_asin';
      case 'acos':
        return 'btn_acos';
      case 'atan':
        return 'btn_atan';
      case AppConstants.keyEquals:
        return 'btn_equals';
      case AppConstants.keyClear:
      case AppConstants.keyAllClear:
        return 'btn_clear';
      case AppConstants.keyPercent:
        return 'btn_percent';
      case AppConstants.keyDot:
        return 'btn_dot';
      case '(':
        return 'btn_left_paren';
      case ')':
        return 'btn_right_paren';
      case '√':
        return 'btn_sqrt';
      case 'xⁿ':
        return 'btn_pow_y';
      case 'log':
        return 'btn_log';
      case 'ln':
        return 'btn_ln';
      case 'π':
        return 'btn_pi';
      case 'E':
        return 'btn_e';
      default:
        // For numbers and other simple labels
        return 'btn_${buttonLabel.toLowerCase()}';
    }
  }


}