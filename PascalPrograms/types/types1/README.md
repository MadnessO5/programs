# Ordinal Types Demo (Pascal)

An interactive console program demonstrating ordinal types in Pascal: subrange types, enumerated types, and the built-in ord, pred, and succ functions.

## What it covers

- **digit10** — a subrange type (0..9)
- **LatinCaps** — a subrange of char ('A'..'Z')
- **RainbowColors** — an enumerated type with pred/succ nSignals **Signals** — an enumerated type used with case, an array lookup (Duration), and a while loop stepping through values with succ

## Requirements

- Free Pascal (fpc) or any Pascal compiler/IDE (Lazarus, online compilers like ideone/onlinegdb also work)

## How to run

fpc ordinal_types.pas
./ordinal_types
Or compile/run it in your IDE of choice.

## Usage

On start, you'll see a menu:

1 - digit10 (0..9)
2 - LatinCaps (A..Z)
3 - RainbowColors (enumerated type)
4 - Signals (enumerated type with case and a loop)
0 - exit
Enter a number to run that demo. Each demo asks for input via readln and prints the result (ord, pred, succ, etc.). After a demo finishes, you return to the menu. Enter 0 to quit.

## Notes

- Demos 3 and 4 convert an integer typed by the user into an enum value using type-casting syntax, e.g. RainbowColors(n) — make sure to enter a number within the valid range (0–6 for RainbowColors, 0–2 for Signals), otherwise the program may raise a runtime error.
