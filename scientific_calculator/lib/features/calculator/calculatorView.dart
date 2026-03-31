import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/appColors.dart';
import '../../core/appConstants.dart';
import 'calculatorViewModel.dart';
import 'calculatorModel.dart';
import 'widgets/calculatorButton.dart';

class CalculatorView extends ConsumerWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorViewModelProvider);
    final viewModel = ref.read(calculatorViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Custom Header
          _buildHeader(context, colorScheme),
          
          Expanded(
            child: Column(
              children: [
                // Display Area
                _buildDisplay(context, state, colorScheme),
                
                // Modifier Chips (RAD/DEG)
                _buildModifiers(state, viewModel, colorScheme),

                // Scientific Function Panel
                _buildScientificPanel(viewModel, colorScheme),
                
                const SizedBox(height: 16),
                
                // Main Keypad
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildMainKeypad(viewModel, colorScheme),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation Bar
          _buildBottomNav(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: colorScheme.onSurfaceVariant),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            Text(
              'Scientific',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.history, color: colorScheme.onSurfaceVariant),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(BuildContext context, CalculatorModel state, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            state.currentInput,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              state.resultValue.isEmpty ? state.currentInput : state.resultValue,
              style: GoogleFonts.manrope(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModifiers(CalculatorModel state, CalculatorViewModel viewModel, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          _buildChip(
            label: 'RAD',
            isActive: !state.isDegreeMode,
            onTap: () => viewModel.onButtonPressed(AppConstants.keyDegRad),
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'DEG',
            isActive: state.isDegreeMode,
            onTap: () => viewModel.onButtonPressed(AppConstants.keyDegRad),
            colorScheme: colorScheme,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.settings_input_component, size: 14, color: colorScheme.secondary),
                const SizedBox(width: 4),
                Text(
                  '2nd',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildScientificPanel(CalculatorViewModel viewModel, ColorScheme colorScheme) {
    final buttons = [
      ['sin', 'cos', 'tan', 'inv'],
      ['ln', 'log', '√', 'xⁿ'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: buttons.map((row) {
          return Row(
            children: row.map((b) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CalculatorButton(
                    label: b,
                    onTap: () => viewModel.onButtonPressed(b),
                    backgroundColor: colorScheme.surfaceContainerLow,
                    textColor: b == 'inv' ? colorScheme.secondary : colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainKeypad(CalculatorViewModel viewModel, ColorScheme colorScheme) {
    final buttons = [
      [AppConstants.keyClear, Icons.backspace, '%', AppConstants.keyDivide],
      ['7', '8', '9', AppConstants.keyMultiply],
      ['4', '5', '6', AppConstants.keySubtract],
      ['1', '2', '3', AppConstants.keyAdd],
      ['0', '.', AppConstants.keyEquals],
    ];

    return Column(
      children: buttons.map((row) {
        return Expanded(
          child: Row(
            children: row.map((b) {
              final isZero = b == '0';
              final isEquals = b == AppConstants.keyEquals;
              final isOperator = _isPrimaryOperator(b);
              final isSpecial = b == AppConstants.keyClear || b is IconData || b == '%';

              return Expanded(
                flex: isZero ? 2 : 1,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CalculatorButton(
                    label: b is IconData ? Icon(b, color: colorScheme.onSurface, size: 24) : b,
                    onTap: () => viewModel.onButtonPressed(b is IconData ? AppConstants.keyBackspace : b as String),
                    backgroundColor: isEquals 
                        ? AppColors.primary 
                        : isOperator 
                            ? AppColors.secondary 
                            : isSpecial 
                                ? colorScheme.surfaceContainerHigh 
                                : colorScheme.surfaceContainerHighest,
                    textColor: isEquals 
                        ? AppColors.onPrimary 
                        : isOperator 
                            ? AppColors.onSecondary 
                            : b == AppConstants.keyClear 
                                ? AppColors.error 
                                : colorScheme.onSurface,
                    isBold: true,
                    fontSize: isEquals ? 32 : 24,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  bool _isPrimaryOperator(dynamic b) {
    return b == AppConstants.keyDivide || b == AppConstants.keyMultiply || b == AppConstants.keySubtract || b == AppConstants.keyAdd;
  }

  Widget _buildBottomNav(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.brightness == Brightness.dark ? const Color(0xFF1A1A1C) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.calculate, true, colorScheme),
          _buildNavItem(Icons.functions, false, colorScheme),
          _buildNavItem(Icons.history, false, colorScheme),
          _buildNavItem(Icons.settings, false, colorScheme),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: isActive ? BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.1),
        shape: BoxShape.circle,
      ) : null,
      child: Icon(
        icon,
        color: isActive ? colorScheme.secondary : colorScheme.onSurfaceVariant.withOpacity(0.5),
      ),
    );
  }
}

