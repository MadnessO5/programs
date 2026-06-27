# reads — Line Character Counter

A Pascal program that reads text from standard input and reports the number of characters in each line.

## Description

The program processes input line by line. For each line it counts the number of characters (excluding the newline itself) and prints the result. After all input is consumed, it prints a farewell message.

## How It Works

- Initializes a counter `n` to `0`
- Reads characters one by one until EOF
- On encountering a newline (`#10`):
  - Prints: `In this string --- <n> --- simbols`
  - Resets `n` to `0` to start counting the next line
- For any other character: increments `n` by 1
- After the loop ends: prints `Good bye`

## Variables

| Variable | Type      | Purpose                        |
|----------|-----------|--------------------------------|
| `c`      | `char`    | Current character being read   |
| `n`      | `integer` | Character count for current line |

## Usage

```bash
# Compile
fpc reads.pas

# Run with input from a file
./reads < input.txt

# Run interactively (type input, press Ctrl+D to end)
./reads
```

## Example

**Input:**
```
Hello
Hi there
```

**Output:**
```
In this string ---  5 --- simbols
In this string ---  8 --- simbols
Good bye
```

> **Note:** The last line of input may not be counted if it does not end with a newline character.

## Requirements

- Free Pascal Compiler (FPC) or any standard Pascal compiler
- Input via standard input (stdin)
