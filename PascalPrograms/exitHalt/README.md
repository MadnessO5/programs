# Halt & Exit Demo

A simple Pascal program demonstrating the difference between `exit` and `halt`.

## Requirements

- Free Pascal Compiler (FPC)

```bash
sudo apt install fpc
```

## Build & Run

```bash
fpc halt_exit.pas
./halt_exit
```

## Usage

```
Введи свой возраст:
17
Ты несовершеннолетний.
Готово!
```

```
Введи свой возраст:
-5
Ошибка: возраст не может быть отрицательным!
Готово!
```

```
Введи свой возраст:
200
Такого возраста не бывает. Программа завершена.
```

## The Difference

| Command | What it does |
|---------|-------------|
| `exit` | Exits the current procedure and returns to where it was called |
| `halt` | Stops the entire program immediately |

## How It Works

- Age `< 0` → `exit` leaves `CheckAge`, but `Готово!` still prints
- Age `> 150` → `halt` kills the program, `CheckAge` and `Готово!` never run
- Age `0–17` → prints "несовершеннолетний"
- Age `18–150` → prints "совершеннолетний"
