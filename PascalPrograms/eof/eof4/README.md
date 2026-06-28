# SimpleSum

A Pascal program that reads a sequence of integers from standard input and outputs their count and total sum.

## Description

The program reads integers one by one until the end of input, accumulating their sum and keeping track of how many numbers were read. At the end it prints both values on a single line.

## How It Works

- Initializes `sum` and `count` to `0`
- Uses `seekeof` to loop until the end of file (skipping whitespace, newlines, and blank lines between numbers)
- For each integer read: adds it to `sum` and increments `count`
- After the loop: prints `count` and `sum` separated by a space

> **Note:** `seekeof` (as opposed to `eof`) skips whitespace before checking for end-of-file, which makes the program robust to numbers spread across multiple lines or separated by extra spaces.

## Variables

| Variable | Type      | Purpose                          |
|----------|-----------|----------------------------------|
| `sum`    | `longint` | Running total of all integers    |
| `count`  | `longint` | Number of integers read so far   |
| `n`      | `longint` | Current integer being read       |

## Usage

```bash
# Compile
fpc SimpleSum.pas

# Run with input from a file
./SimpleSum < input.txt

# Run interactively (type numbers, press Ctrl+D to end)
./SimpleSum
```

## Example

**Input:**
```
3 7 2
10
-4 1
```

**Output:**
```
6 19
```

6 numbers were read, their sum is 3 + 7 + 2 + 10 + (−4) + 1 = 19.

## Input Constraints

- Numbers must be valid integers in the `longint` range (−2 147 483 648 to 2 147 483 647)
- Numbers can be separated by spaces, tabs, or newlines in any combination
- Empty lines are handled correctly thanks to `seekeof`

## Requirements

- Free Pascal Compiler (FPC) or any standard Pascal compiler
- Input via standard input (stdin)
