# TypeSystemDemo

An interactive Pascal program demonstrating the type system from section 2.6 of the textbook. The user enters data via the keyboard; each menu item covers one concept from the chapter.

## Menu

| Option | Type used | What it does |
|--------|-----------|--------------|
| 1 | `MyNumber = real` | Read two numbers, print their sum |
| 2 | `SimObjectId = integer` | Read an object ID and name, print the record |
| 3 | `AreaType = MyNumber` *(local type)* | Read a radius, compute circle area |
| 4 | `StudentMark = 1..10` | Read a mark, validate the subrange |
| 5 | `1..12` *(anonymous type)* | Read a month number, validate the subrange |
| 0 | — | Exit |

The program loops in `repeat … until choice = 0`.

## Concepts Covered

- **Type synonyms** — `MyNumber = real`, `SimObjectId = integer`: change the underlying type in one place and every variable using it updates automatically.
- **Local type section** — `AreaType` is declared inside `ShowCircleArea` and is invisible outside it.
- **Subrange types** — `StudentMark = 1..10` and the anonymous `1..12` restrict the set of valid values; the program checks bounds manually and reports an error on invalid input.
- **Anonymous types** — declared inline in `var` without giving the type a name.

## How to Run

```bash
fpc TypeSystemDemo.pas
./TypeSystemDemo
```

## Example Session

```
1 - MyNumber = real        (sum two numbers)
2 - SimObjectId = integer  (enter object)
3 - AreaType = MyNumber    (circle area)
4 - StudentMark = 1..10   (enter mark)
5 - anonymous type 1..12  (enter month)
0 - exit
> 3

Radius : 5
Radius :     5.0000
Area   :    78.5398

> 4

Mark (1..10) : 11
Error: out of range 1..10

> 0
```

## Requirements

- Free Pascal Compiler (FPC) 3.x or later
