# StringTypeDemo

An interactive console program demonstrating Pascal's `string` type: how it's really an array of `char` under the hood, its length byte, assignment between different maximum lengths, concatenation, and `var`-parameters.

## What it covers

- **`string[15]` vs plain `string`** — `s1: string[15]` has a maximum length of 15 characters (occupies 16 bytes); plain `s2: string` defaults to a maximum length of 255 characters (occupies 256 bytes).
- **The hidden length byte, `s[0]`** — every `string` variable's element `s[0]` holds the string's current length, stored as a `char` (since all array elements must share one type). The program prints `ord(s1[0])` to show the length as a number.
- **`length(s)`** — the conventional, readable way to get a string's length (equivalent to `ord(s[0])`).
- **Assignment between different maximum lengths** — assigning a longer/looser `string` (`s2`) into a shorter-limited one (`s1: string[15]`) is allowed, but the value is silently truncated to fit.
- **`var`-parameters accepting any `string` type** — `AppendKadabra(var str: string)` can accept a variable declared as `string[15]` or plain `string` alike, which is a deliberate exception to Pascal's usual "the variable's type must exactly match the `var`-parameter's type" rule.
- **String concatenation with `+`** — combining strings, including appending inside a procedure via a `var`-parameter.
- **The empty string literal `''`** — two apostrophes with nothing between them, length 0 (not to be confused with `' '`, a string containing one space character).
- **Implicit `char` → `string` conversion** — accumulating a string one character at a time with `s := s + c`, where `c` is a `char`.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc string_type_demo.pas
./string_type_demo
```

The program will prompt you for:

1. A string up to 15 characters (stored in `s1`).
2. A string of any length (stored in `s2`), then assigns it into `s1` (may get truncated).
3. A starting string (e.g. `abra`), then appends `'kadabra'` to it via a `var`-parameter procedure.
4. Nothing further — it then builds and prints the Latin alphabet by accumulating characters into an initially empty string.

## Sample session (abbreviated)

```
Введите строку до 15 символов (для s1): abrakadabra
s1 = abrakadabra
length(s1) = 11
ord(s1[0]) = 11 (байт длины строки)
s1[1] = a

Введите строку любой длины (для s2): a very long example string that is definitely longer than fifteen characters
s2 = a very long example string that is definitely longer than fifteen characters
length(s2) = 77

Присвоим s2 в s1 (может обрезаться до 15 символов):
s1 теперь = a very long ex
length(s1) = 15

Введите начало строки (например abra): abra
После вызова AppendKadabra(var str: string): abrakadabra

Пустая строка перед циклом, length(s) = 0
Строка после накопления символов через неявное char -> string:
ABCDEFGHIJKLMNOPQRSTUVWXYZ
```

## Notes

- Try declaring `AppendKadabra`'s parameter as `var str: string[15]` instead of plain `string` and see that Free Pascal then refuses to compile a call with an argument of a different maximum length — this is exactly the exception the source material calls out: a `var`-parameter of the *unconstrained* `string` type accepts strings of any declared maximum length, but a `var`-parameter of a *specific* `string[N]` type does not.
- Passing and returning `string` values by value only copies the *significant* part of the string (its current content plus the length byte), not the full 256-byte buffer, which is why plain `string` is cheap to use even though its declared maximum length is large.
