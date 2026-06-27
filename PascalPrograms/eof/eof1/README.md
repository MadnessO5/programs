# reads — Newline Detector

A Pascal program that reads text from standard input and prints `Ok` each time a newline character is encountered.

## Description

The program scans input character by character. Every time it finds a newline (`#10`), it outputs `Ok` on a new line. After all input is processed, it prints `Good bye`.

## How It Works

- Enters a loop that reads characters until EOF
- On encountering a newline (`#10`): prints `Ok`
- All other characters are ignored
- After the loop ends: prints `Good bye`

## Variables

| Variable | Type   | Purpose                      |
|----------|--------|------------------------------|
| `c`      | `char` | Current character being read |

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
World
!
```

**Output:**
```
Ok
Ok
Ok
Good bye
```

Each `Ok` corresponds to one newline found in the input — in other words, one completed line.

## Requirements

- Free Pascal Compiler (FPC) or any standard Pascal compiler
- Input via standard input (stdin)
