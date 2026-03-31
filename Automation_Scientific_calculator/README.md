# 🤖 Automation: Scientific Calculator

This project contains the automated test suite for the **Scientific Calculator** mobile application, powered by **Maestro Studio**.

## 🎯 Overview
This is a dedicated automation project designed to verify the core functionality and premium UI of the calculator app independently from its source code.

## 🚀 Getting Started

### Prerequisites
- **Maestro CLI**: Install it with `curl -Ls "https://get.maestro.mobile.dev" | bash`.
- **Target App**: Ensure the `scientific_calculator` app is installed on your connected emulator or simulator.

### Running Tests
Navigate to this directory and run the following commands:

```bash
# Run the basic arithmetic suite
maestro test maestro/basic_math.yaml

# Open Maestro Studio for interactive automation
maestro studio
```

## 📂 Project Structure
- `maestro/`: Contains all YAML flow files and test case documentation.
    - `basic_math.yaml`: Flow for testing addition, multiplication, and AC.
    - `test_cases.md`: Detailed breakdown of all test steps and expectations.

## 🧪 Key Test Scenarios
1. **Basic Math**: Verification of arithmetic operators.
2. **Scientific functions**: Validation of sin, cos, log, etc.
3. **History**: Ensuring calculations are saved and can be reloaded.
4. **UI Cleanup**: Confirming the removal of the bottom bar and menu button.

---
*Automate excellence, one calculation at a time.*
