# Tic-Tac-Toe

A two-player tic-tac-toe game written in Pascal. No arrays — just 9 variables and simple logic.

## Requirements

- Free Pascal Compiler (FPC)

```bash
sudo apt install fpc
```

## Build & Run

```bash
fpc tictactoe.pas
./tictactoe
```

## How to Play

The board positions are numbered 1 to 9:

```
 1 | 2 | 3
---+---+---
 4 | 5 | 6
---+---+---
 7 | 8 | 9
```

- Player **X** goes first
- Enter a number from 1 to 9 to place your symbol
- First to get 3 in a row (horizontal, vertical, or diagonal) wins!

## Example

```
  Поле:             Позиции:
   X | O |              1 | 2 | 3
  ---+---+---       ---+---+---
     | X |              4 | 5 | 6
  ---+---+---       ---+---+---
     |   | X           7 | 8 | 9

  *** Игрок X победил! ***
```

## Features

- Two players on the same keyboard
- Rejects invalid input (out of range or already taken)
- Tracks wins for X, wins for O, and draws
- Play multiple rounds in one session

## Code Structure

| Element | Description |
|---------|-------------|
| `c1..c9` | 9 variables storing the board (no arrays!) |
| `GetCell(n)` | Returns the symbol at position n |
| `SetCell(n, p)` | Places a symbol at position n |
| `CheckWin(p)` | Checks all 8 winning combinations |
| `Line(a, b, c, p)` | Checks if 3 cells match |
| `SwitchPlayer` | Switches turn between X and O |
| `PrintStats` | Shows wins and draws |
