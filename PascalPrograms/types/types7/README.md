# Case Statement Demos

Two interactive Pascal programs demonstrating the `case` statement (Pascal's generalized version of `if`), based on section 2.7 ("Оператор выбора").

## Files

- **`symbol_type.pas`** — a transcription of the book's `SymbolType` example: reads one character and classifies it (letter, digit, arithmetic sign, punctuation, formatting code, etc.) using a `case` statement with ranges (`'a'..'z'`), lists of values, and character codes (`#9`, `#27`).
- **`case_style_demo.pas`** — a short illustration of the style warning from the text: contrasts a `case` keyed on "magic numbers" (`1`, `2`, `3`, ...) with the same logic keyed on a named enumerated type (`Command = (cmdOpen, cmdSave, ...)`), which is far more self-documenting.

## What they cover

- `case <expression> of` requires the expression to have an **ordinal type** (see §2.6.3): `char`, integer types, `boolean`, or an enumerated type.
- Each branch lists one or more constant values (or ranges, using `..`), followed by a colon and a statement.
- An optional `else` branch runs if the expression doesn't match any listed value.
- **Values in a `case` must be compile-time constants** — you can't branch on a runtime-computed value directly, only compare the `case` expression against fixed constants.
- Nested `case` statements are almost always a sign the code should be split into separate subprograms instead.
- The style pitfall: keying a `case` on plain integers (`1`, `2`, `3`, ...) with no explanation of what each number means makes code very hard to read and easy to get wrong; using a named enumerated type instead documents intent directly in the code.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc symbol_type.pas
./symbol_type
```

```bash
fpc case_style_demo.pas
./case_style_demo
```

## Sample session — `symbol_type`

```
Введите один символ: +
The symbol is an arithmetic operation symbol
```

## Sample session — `case_style_demo`

```
Плохой стиль — case по магическим числам (не делайте так):
1 - Open, 2 - Save, 3 - Close, 4 - Print, 5 - Exit
Введите номер команды (1..5): 2

Сохраняем файл

Хороший стиль — case по перечислимому типу с осмысленными именами:
Сохраняем файл
```

Both branches print the same result — the point is that the second version's code (`cmdSave: writeln(...)`) is self-explanatory, while the first version's code (`2: writeln(...)`) requires you to remember or look up what `2` means.

## Notes

- In `symbol_type.pas`, `read(c)` (not `readln`) is used deliberately, matching the book's original example — it reads exactly one character without consuming the rest of the line.
- In `case_style_demo.pas`, `Command(choice - 1)` is an explicit type conversion from an ordinal integer to the enumerated type — valid because ordinal types can always be explicitly converted into one another (see §2.6.8), and there's no input validation here for simplicity; entering something outside `1..5` will still fall through to `else` for the numeric `case`, but the type conversion for the enum version assumes a valid range and isn't checked.
