# Pascal Guitar Simulator

A lightweight terminal-based guitar simulator written in Free Pascal for Unix/Linux systems. This program visualizes a guitar fretboard, allows you to switch frets, and plays sound synthesizing string plucks using `sox`.

---

## 📋 Features

- **Interactive Fretboard UI:** Displays 6 strings and 12 frets using terminal colors (`Crt` unit).
- **Realistic Tuning:** Default standard E tuning (`E2`, `A2`, `D2`, `G2`, `B2`, `E3`).
- **Dynamic Pitch Calculation:** Calculates note frequencies mathematically based on the chromatic scale formula ($f = f_0 \cdot 2^{n/12}$).
- **Audio Synthesis:** Triggers asynchronous audio playback using the `sox` package without freezing the application UI.

---

## 🛠️ Prerequisites

Before compiling and running the application, ensure you have the following installed on your system:

1. **Free Pascal Compiler (FPC)**
   - Debian/Ubuntu: `sudo apt install fpc`
   - Arch Linux: `sudo pacman -S fpc`
   - Fedora: `sudo dnf install fpc`

2. **SoX (Sound eXchange)** with audio backends
   - Debian/Ubuntu: `sudo apt install sox libsox-fmt-all`
   - Arch Linux: `sudo pacman -S sox`
   - Fedora: `sudo dnf install sox`

---

## 🚀 Compilation & Running

1. Save the code into a file named `GuitarSimulator.pas`.
2. Open a terminal and navigate to the directory where the file is located.
3. Compile the code using `fpc`:
   ```bash
   fpc GuitarSimulator.pas
