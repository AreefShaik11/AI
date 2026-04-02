import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import 'calculator_view_model.dart';
import 'calculator_model.dart';
import 'widgets/calculator_button.dart';

class CalculatorView extends ConsumerWidget {
  const CalculatorView({super.key});

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
          _buildHeader(context, colorScheme, state, viewModel),
          
          Expanded(
            child: Column(
              children: [
                // Display Area
                _buildDisplay(context, state, colorScheme),
                
                // Modifier Chips (RAD/DEG)
                _buildModifiers(state, viewModel, colorScheme),

                // Scientific Function Panel
                _buildScientificPanel(viewModel, colorScheme, state),
                
                const SizedBox(height: 16),
                
                // Main Keypad
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildMainKeypad(viewModel, colorScheme),
                  ),
                ),
                SizedBox(height: 16 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme, CalculatorModel state, CalculatorViewModel viewModel) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Semantics(
              identifier: 'title_scientific',
              child: Text(
                'Scientific',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const Spacer(),
            Semantics(
              label: 'btn_history',
              identifier: 'btn_history',
              button: true,
              child: IconButton(
                icon: Icon(Icons.history, color: colorScheme.onSurfaceVariant),
                onPressed: () => _showHistory(context, state, viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistory(BuildContext context, CalculatorModel state, CalculatorViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      viewModel.clearHistory();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: state.history.isEmpty
                    ? Center(
                        child: Text(
                          'No history yet',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.history.length,
                        itemBuilder: (context, index) {
                          final item = state.history[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: InkWell(
                              onTap: () {
                                // Load history item back into input
                                final parts = item.split(' = ');
                                viewModel.onButtonPressed(AppConstants.keyClear);
                                for (var char in parts[0].characters) {
                                  viewModel.onButtonPressed(char);
                                }
                                Navigator.pop(context);
                              },
                              child: Semantics(
                                identifier: 'history_item_$index',
                                child: Text(
                                  item,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
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
          Semantics(
            identifier: 'display_input',
            child: Text(
              state.currentInput,
              style: GoogleFonts.inter(
                fontSize: 18,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Semantics(
              identifier: 'display_result',
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
            id: 'chip_rad',
            label: 'RAD',
            isActive: !state.isDegreeMode,
            onTap: () => viewModel.onButtonPressed(AppConstants.keyDegRad),
            colorScheme: colorScheme,
          ),
          const SizedBox(width: 8),
          _buildChip(
            id: 'chip_deg',
            label: 'DEG',
            isActive: state.isDegreeMode,
            onTap: () => viewModel.onButtonPressed(AppConstants.keyDegRad),
            colorScheme: colorScheme,
          ),
          const Spacer(),
          if (state.isInverse)
            Semantics(
              identifier: 'indicator_2nd',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
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
            ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String id,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Semantics(
      identifier: id,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? colorScheme.surfaceContainerHighest : colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
      ),
    );
  }

  Widget _buildScientificPanel(CalculatorViewModel viewModel, ColorScheme colorScheme, CalculatorModel state) {
    final buttons = [
      ['(', ')', 'π', 'E'],
      [
        state.isInverse ? 'asin' : 'sin',
        state.isInverse ? 'acos' : 'cos',
        state.isInverse ? 'atan' : 'tan',
        'inv'
      ],
      ['ln', 'log', '√', 'xʸ'],
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
      children: buttons.map((row) => Expanded(
        child: Row(
          children: row.map((b) => _buildKeypadButton(b, viewModel, colorScheme)).toList(),
        ),
      )).toList(),
    );
  }

  Widget _buildKeypadButton(dynamic b, CalculatorViewModel viewModel, ColorScheme colorScheme) {
    final isZero = b == '0';
    final isEquals = b == AppConstants.keyEquals;

    return Expanded(
      flex: isZero ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: CalculatorButton(
          label: b is IconData ? Icon(b, color: colorScheme.onSurface, size: 24) : b,
          onTap: () => viewModel.onButtonPressed(b is IconData ? AppConstants.keyBackspace : b as String),
          backgroundColor: _getButtonBackgroundColor(b, colorScheme),
          textColor: _getButtonTextColor(b, colorScheme),
          isBold: true,
          fontSize: isEquals ? 32 : 24,
        ),
      ),
    );
  }

  Color _getButtonBackgroundColor(dynamic b, ColorScheme colorScheme) {
    if (b == AppConstants.keyEquals) return AppColors.primary;
    if (_isPrimaryOperator(b)) return AppColors.secondary;
    if (b == AppConstants.keyClear || b is IconData || b == '%') {
      return colorScheme.surfaceContainerHigh;
    }
    return colorScheme.surfaceContainerHighest;
  }

  Color _getButtonTextColor(dynamic b, ColorScheme colorScheme) {
    if (b == AppConstants.keyEquals) return AppColors.onPrimary;
    if (_isPrimaryOperator(b)) return AppColors.onSecondary;
    if (b == AppConstants.keyClear) return AppColors.error;
    return colorScheme.onSurface;
  }

  bool _isPrimaryOperator(dynamic b) {
    return b == AppConstants.keyDivide || b == AppConstants.keyMultiply || b == AppConstants.keySubtract || b == AppConstants.keyAdd;
  }
}

