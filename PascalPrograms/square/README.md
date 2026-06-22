# Quadratic Equation Solver

A simple Pascal program that solves quadratic equations of the form:

**ax² + bx + c = 0**

## Requirements

- Free Pascal Compiler (FPC)

```bash
sudo apt install fpc
```

## Build & Run

```bash
fpc quadratic.pas
./quadratic
```

## Usage

```
ax^2 + bx + c = 0
a = 1
b = -5
c = 6
x1 = 2.0000
x2 = 3.0000
```

## How It Works

1. Enter coefficients `a`, `b`, `c`
2. The program calculates the discriminant: **D = b² - 4ac**
3. If `a = 0` — not a quadratic equation, error
4. If `D < 0` — no real roots
5. If `D >= 0` — two roots are calculated using the formula:

**x = (-b ± √D) / 2a**

## Code Structure

| Element | Description |
|---------|-------------|
| `procedure quadratic` | Solves the equation, returns roots via `var` parameters |
| `ok` | `true` if roots were found, `false` otherwise |
| `x1`, `x2` | The two roots of the equation |
| `sqrt(d)` | Built-in Pascal function for square root |
| `:0:4` | Output format — 4 decimal places |
