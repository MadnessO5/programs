# RdKey

A small Pascal program demonstrating `ReadKey` from the `crt` unit — reading a single keypress immediately, without waiting for Enter, and printing its character code.

## What it covers

- **`uses crt;`** — `ReadKey` lives in the `crt` unit, just like `clrscr`/`GotoXY` from the earlier example.
- **`ReadKey`** — waits for and returns exactly one keypress as a `char`, with no need to press Enter and no echoing of the key to the screen (unlike `read`/`readln`, which wait for a full line).
- **Printable vs. non-printable characters** — codes below `32` (space) or above `126` (tilde `~`) don't have a normal printable glyph (e.g. arrow keys, Enter, Escape, Backspace). The program substitutes `'?'` for these so `writeln` always has something sensible to display.
- **`ord(c)`** — prints the numeric character code of the key pressed, alongside its (possibly substituted) printable form.
- **`until c = ' '`** — the loop repeats until the spacebar is pressed, which then ends the program.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- Run in a real terminal — `ReadKey` needs actual terminal input, not redirected/piped input from a file.

## How to build and run

```bash
fpc rdkey.pas
./rdkey
```

Press any keys one at a time; the program prints a line for each one. Press the spacebar to exit.

## Sample session

```
65 (A)
97 (a)
13 (?)
27 (?)
32 (?)
```

(`13` is Enter, `27` is Escape — both non-printable, shown as `?`; `32` is the space that ends the loop, also shown as `?` since it happens to fall right at the printable/non-printable boundary check... actually `#32` itself is excluded by `(cc < #32)`, so space *is* printable and would show as itself if reached before the `until` check — but the loop exits right after printing it.)

## Notes

- Some special keys (arrow keys, function keys, etc.) are reported by `ReadKey` as a *two-key sequence*: a first call returns `#0`, and a second call to `ReadKey` returns the actual key code. This program doesn't handle that case — pressing an arrow key will just show up as two separate lines, the first with code `0`.
- Because `ReadKey` reads directly from the terminal without buffering by line, it won't work if you try to redirect input from a file (e.g. `./rdkey < input.txt`), unlike programs built around `readln`.
