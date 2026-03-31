# 🧪 Scientific Calculator - Full Test Suite

This document provides a detailed breakdown of the test cases implemented in the Maestro automation suite. Each case is designed to be self-documenting and uses explicit ID targeting for maximum reliability.

---

## 1. Basic Arithmetic (`basic_math.yaml`)
**Goal**: Verify core mathematical operations.

- **CASE 1: ADDITION**
    - Tap: `{id: "btn_7"}`, `{id: "btn_add"}`, `{id: "btn_8"}`, `{id: "btn_equals"}`
    - Expect: `{id: "display_result"}` shows `15`.
- **CASE 2: SUBTRACTION**
    - Tap: `{id: "btn_50"}`, `{id: "btn_subtract"}`, `{id: "btn_25"}`, `{id: "btn_equals"}`
    - Expect: `{id: "display_result"}` shows `25`.
- **CASE 3: MULTIPLICATION**
    - Tap: `{id: "btn_6"}`, `{id: "btn_multiply"}`, `{id: "btn_7"}`, `{id: "btn_equals"}`
    - Expect: `{id: "display_result"}` shows `42`.
- **CASE 4: DIVISION**
    - Tap: `{id: "btn_100"}`, `{id: "btn_divide"}`, `{id: "btn_4"}`, `{id: "btn_equals"}`
    - Expect: `{id: "display_result"}` shows `25`.
- **CASE 5: PERCENTAGE**
    - Tap: `{id: "btn_10"}`, `{id: "btn_percent"}`, `{id: "btn_equals"}`
    - Expect: `{id: "display_result"}` shows `0.1`.

---

## 2. Scientific Functions (`scientific_math.yaml`)
**Goal**: Verify advanced mathematical functions.

- **CASE 1: TRIGONOMETRY**
    - Verify `sin(30)` equals `0.5` in DEG mode.
    - Verify `cos(60)` equals `0.5` in DEG mode.
- **CASE 2: INVERSION (2nd Function)**
    - Toggle `{id: "btn_inv"}` and verify `asin(1)` equals `90`.
- **CASE 3: LOGARITHMS**
    - Verify `log(100)` equals `2`.
- **CASE 4: POWERS & ROOTS**
    - Verify `sqrt(25)` equals `5.0`.
    - Verify `2 ^ 3` equals `8`.
- **CASE 5: PARENTHESES**
    - Verify nested expression `2 * (3 + 4)` equals `14`.

---

## 3. UI Regression (`ui_regression.yaml`)
**Goal**: Verify layout, alignment, and navigation.

- **CASE 1: HEADER**
    - Verify `Scientific` title and History icon are present.
- **CASE 2: DISPLAY**
    - Verify multi-input string behavior in `display_input`.
- **CASE 3: MODE TOGGLES**
    - Cycle between `RAD` and `DEG` chips.
- **CASE 4: SCIENTIFIC TOGGLE**
    - Verify `indicator_2nd` visibility during inversion.
- **CASE 5: NEGATIVE TESTING**
    - Confirm `menu_icon` and `bottom_nav_bar` are absent.
