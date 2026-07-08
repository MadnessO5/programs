# UserTypesParamsDemo

An interactive console program demonstrating two rules about passing user-defined types to Pascal subprograms:

1. Anonymous types are not allowed in parameter lists — a type used as a parameter must be declared with a name first.
2. Large values (records, arrays) should be passed by reference (var or const) rather than by value, to avoid the cost of copying them on every call.

## What it covers

- **MyRange = 1..100** — a named subrange type. Writing procedure p1(b: 1..100) directly would be a compile-time error in Pascal; the type has to be declared first and referenced by name, as shown in PrintValue(v: MyRange).
- **CheckPoint** — a record type (checkpoint data: number, latitude, longitude, hidden flag, penalty).
- **CheckPointArray** — an array of CheckPoint, a "large" structure that would be expensive to copy.
- **FillTrack(var t: CheckPointArray; cnt: integer)** — takesvar-parameter*var-parameter**, so no copy is made; the local name t becomes a synonym for the caller's variable.
- **PrintTrack(const t: CheckPointArray; cnt: integer)** — tconst-parameter **const-parameter**: no copy is made either, but the procedure is not allowed to modify it, which documents intent and adds a safety check.

## Requirements

- Free Pascal (fpc) or any compatible Pascal compiler.

## How to build and run

fpc user_types_params_demo.pas
./user_types_params_demo
The program will ask:

1. A value for b in range 1..100 (of type MyRange), which is printed by PrintValue.
2. How many checkpoints to fill in (up to 75).
3. For each checkpoint: latitude, longitude, and penalty (entered via FillTrack, using a var-parameter).
4. A summary of all checkpoints, printed via PrintTrack, using a const-parameter.

## Sample session (abbreviated)

Введите значение b (1..100): 42
Значение из диапазона MyRange: 42

Сколько контрольных пунктов заполнить? (не более 75): 2
Пункт №1:
  Широта: 54.83843
  Долгота: 37.59556
  Штраф (мин): 30
Пункт №2:
  Широта: 54.90000
  Долгота: 37.61000
  Штраф (мин): 45

Сводка по дистанции:
track[1]: широта=54.83843 долгота=37.59556 штраф=30
track[2]: широта=54.90000 долгота=37.61000 штраф=45
## Notes

- Try changing FillTrack's parameter from var to a plain value parameter (t: CheckPointArray) and note that the array then gets copied on every call — with a large array or a tight loop, this becomes noticeably slower.
- Try changing PrintTrack's const t to var t and attempt to modify t[i] inside the procedure to see how const protects against accidental writes.
- hidden is hardcoded to false in FillTrack for simplicity; feel free to prompt for it too, as in the earlier CheckPointDemo and ComplexDataDemo examples.
