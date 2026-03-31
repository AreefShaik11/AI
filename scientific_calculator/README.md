# 🧮 Scientific Calculator - Premium Edition

Welcome to the **Scientific Calculator**! This project is a cross-platform mobile application built with **Flutter**, designed to provide a premium, modern experience for both basic and complex mathematical calculations.

---

## 🏗 Project Architecture (MVVM)

For this project, we use the **MVVM (Model-View-ViewModel)** design pattern. This is a professional way to organize code, making it easier to read, test, and maintain.

### 1. Model (`calculatorModel.dart`)
- **What it is**: The "State" of our application.
- **What it does**: It tells the app exactly what information to remember at any moment. For example:
    - What is the current number typed? (`currentInput`)
    - What was the last result? (`resultValue`)
    - Are we in Degrees or Radians mode? (`isDegreeMode`)
    - What's stored in the memory? (`memoryValue`)

### 2. ViewModel (`calculatorViewModel.dart`)
- **What it is**: The "Brain" of our application.
- **What it does**: This is where all the logic lives. When you press a button, the View tells the ViewModel, "Hey, a button was pressed!" The ViewModel then:
    - Decides what to do with that button (Add a number? Calculate? Clear everything?).
    - Updates the **Model** with the new information.
    - Tells the **View** to refresh and show the updated numbers.

### 3. View (`calculatorView.dart`)
- **What it is**: The "Face" of our application.
- **What it does**: This is the part you see and touch! It contains all the buttons, colors, and fonts. It purely displays what the **ViewModel** tells it to and sends user actions (taps) back to the ViewModel.

---

## 🧩 How the Code Works

### The Calculation Engine
We use a powerful library called `math_expressions`. 
- When you type `sin(30) + 5`, the app treats this as a **String**.
- The `CalculatorService` takes that String and "parses" it into a math tree.
- It then evaluates that tree to give you a result like `5.5`.

### Design System
- **Typography**: We use **Google Fonts (Manrope and Inter)** to give the calculator a sleek, scientific feel.
- **Colors**: The theme is designed to be "Obsidian Dark" by default, with vibrant orange (`FFAD48`) and blue (`5F9EFF`) accents to separate different types of actions.
- **Responsive Layout**: The app uses `Flexible` and `Expanded` widgets to ensure the buttons look perfect on every screen size—from a small phone to a large tablet.

---

## 📱 Cross-Platform: iOS & Android

One of the best things about this project is that it runs on both **iOS** and **Android** using the same code!

- **iOS Support**: On an iPhone, the app automatically respects the notch/dynamic island and uses smooth, high-frame-rate animations.
- **Android Support**: On Android, we've customized things like the **Splash Screen** and **System Navigation Bar** to match our obsidian theme perfectly.

---

## ⚙️ Configuration & Setup

### Requirements
- **Flutter SDK**: Ensure you have the latest version of Flutter installed (`flutter --version`).
- **Target Devices**: An Android Emulator or iOS Simulator.

### Dependencies
Open your `pubspec.yaml` to see the libraries we use:
- `flutter_riverpod`: Our state management tool.
- `math_expressions`: The math engine.
- `google_fonts`: For the premium typography.

### Run the Project
To launch the app, simply open your terminal in the project folder and run:
```bash
# To run on any connected device
flutter run

# To run specifically on iOS
flutter run -d ios

# To run specifically on Android
flutter run -d android
```

---

## 📁 Key Folders
- `/lib/core`: Contains global themes and colors.
- `/lib/features/calculator`: The home for all our calculator logic and UI.
- `/android` & `/ios`: Platform-specific configuration files.

---

*Made with ❤️ for a premium mobile experience.*
