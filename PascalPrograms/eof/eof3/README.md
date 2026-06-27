# SkipIndented

A Pascal program that reads text from standard input and outputs it with leading whitespace (indentation) removed from each line.

## Description

The program processes characters one by one. For each line, it skips any leading spaces and tabs at the beginning, then prints the remaining characters as-is. Empty lines (containing only a newline) are preserved, but the newline itself resets the tracking state for the next line.

## How It Works

- Reads input character by character until EOF
- On encountering a newline (`#10`): if content was already printed on that line, outputs a newline; then resets the state for the next line
- On encountering any other character:
  - If the line hasn't started yet (`know = false`): sets `print = true` only if the character is **not** a space (`' '`) and **not** a tab (`#9`)
  - Once non-whitespace content begins (`know = true`): prints all subsequent characters including spaces

## Variables

| Variable | Type    | Purpose                                              |
|----------|---------|------------------------------------------------------|
| `c`      | `char`  | Current character being read                         |
| `know`   | `boolean` | Whether non-whitespace content on this line has begun |
| `print`  | `boolean` | Whether the current character should be printed      |

## Usage

```bash
# Compile
fpc SkipIndented.pas

# Run with input from a file
./SkipIndented < input.txt

# Run interactively (type input, press Ctrl+D to end)
./SkipIndented
```

## Example

**Input:**
```
    Hello World
        indented line
no indent here
```

**Output:**
```
Hello World
indented line
no indent here
```

## Requirements

- Free Pascal Compiler (FPC) or any standard Pascal compiler
- Input via standard input (stdin)
