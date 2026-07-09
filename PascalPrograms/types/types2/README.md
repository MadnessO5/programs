# TypeConversionDemo

An interactive console program demonstrating implicit and explicit type conversions in Pascal.

## What it covers

- **Implicit conversion (integer → real)** — assigning an integer value to a real variable (r := n) is done automatically by the compiler; no function call is needed.
- **trunc vs round** — two ways to explicitly convert a real value back to an integer:
  - trunc(r) simply drops the fractional part ("truncation").
  - round(r) rounds to the nearest whole number.
  Both are applied to the same input value so you can see the difference directly.
- **ord and chr** — the recommended way to work with character codes: ord(c) gives the numeric code of a character, chr(code) gives the character for a numebyte(c) **byte(c)** — an explicit type conversion (Free Pascal syntax: type name used like a function call), reinterpreting a char variable as a byte, since both have the same machine representation size.
- **integer(c) pitfall** — deliberately shows that converting a digit character like '5' with integer(c) gives its character *code* (53), not the number 5. The correct way to turn a digit character into its numeric value is ord(c) - ord('0'), which the program also demonstrates.

## Requirements

- Free Pascal (fpc) or any compatible Pascal compiler (explicit type(value) conversion syntax is a Free Pascal / Delphi extension, not available in classic Pascal).

## How to build and run

fpc type_conversion_demo.pas
./type_conversion_demo
The program will prompt you, in order, for:

1. An integer (to show implicit conversion to real).
2. A real number (to compare trunc and round).
3. A single character (to show ord and byte).
4. A character code 0–255 (to show chr).
5. A digit character like 5 (to show the integer(c) pitfall vs. the correct ord(c) - ord('0') approach).

## Sample session (abbreviated)

Введите целое число: 15
Неявное преобразование integer -> real: r = 15.00

Введите вещественное число: 15.75
trunc(r) = 15 (отбрасывание дробной части)
round(r) = 16 (округление к ближайшему целому)

Введите символ: A
ord(c) = 65
Явное преобразование byte(c) = 65

Введите код символа (0..255): 65
chr(65) = A

Введите цифру символом (например 5): 5
integer(c) = 53 (код символа, а не число 5!)
Чтобы получить именно число 5, символ нужно распознавать через ord(c) - ord('0')
ord(c) - ord('0') = 5
## Notes

- Explicit conversion between ordinal types (integer, char, boolean, enumerated types) is unrestricted in Free Pascal. Explicit conversion between other types requires them to have the same machine representation size (e.g. a 1-byte char and a 1-byte byte).
- For *variables* (as opposed to expression values), explicit conversion always requires matching sizes — the "convert any ordinal to any ordinal" rule only applies to values/expressions.
- Try changing round(15.5) vs round(16.5) to explore banker's rounding behavior, if you want to dig further into how round handles exact halves.
