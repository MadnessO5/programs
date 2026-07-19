# Text File Demos

Two Pascal programs demonstrating text files (`text`), based on section 2.9.2 ("Текстовые файлы").

## Files

- **`gennumtx.pas`** — generates a text file (`numbers.txt`) containing 100 integers, starting at 1000 and increasing by 1001 each time, one per line.
- **`multandadd.pas`** — reads a text file (given as a command-line argument) containing one or more floating-point numbers per line, multiplies the numbers within each line, sums the per-line products across all lines, and prints the total.

## What they cover

- **`text`** — the built-in file type for text files. Only `text` files support the notion of "lines", which is what makes `writeln`/`readln` and the `eoln` function meaningful; other file types (typed files, untyped/block files) are just sequences of bytes with no inherent concept of a line.
- **`assign` / `rewrite` / `reset` / `close`** — the standard open/close sequence: `rewrite` for writing (creating or truncating the file), `reset` for reading (the file must already exist).
- **No random access, no read/write mixing** — text files must be written straight through from beginning to end (optionally in multiple `append`-opened sessions), and can't have their position seeked backward or forward; once written, they can only be *re*written from scratch (via `rewrite` again), not edited in place.
- **`SeekEof(f)` / `SeekEoln(f)`** — the file-parameter versions of the `SeekEof`/`SeekEoln` functions used earlier for standard input (see the §2.5.4 discussion cited in the text): they skip over whitespace to check whether anything meaningful remains in the file or the current line, "un-reading" the first non-whitespace character they find so a subsequent `read` still sees it.
- **`readln(f)` after a reading loop** — needed to consume the newline character left in the stream once a line's values have all been read with `read`; skipping this call would cause the program to loop forever re-checking the same (already logically finished) line.
- **`ParamCount` / `ParamStr(1)`** — `multandadd.pas` takes its input filename from the command line rather than hardcoding it, checking first that an argument was actually given.
- **`{$I-}` / `IOResult`** — used in `multandadd.pas` to report a clear error if the file can't be opened, instead of the notoriously unhelpful default Free Pascal I/O error.
- **`output` / `input` (and `stdout` / `stdin`)** — mentioned in the source material as the built-in `text`-typed variables naming the standard output/input streams; `writeln(output, 'Hello')` is exactly equivalent to `writeln('Hello')`. Neither demo program here uses them explicitly, but they're relevant background for understanding why a `text` parameter can accept either an opened file variable or the standard streams interchangeably.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc gennumtx.pas
./gennumtx
```

This creates `numbers.txt` in the current directory (100 lines: `1000`, `2001`, `3002`, ... up to the 100th value).

```bash
fpc multandadd.pas
./multandadd numbers.txt
```

Since `numbers.txt` from `gennumtx.pas` has exactly one number per line, this will just print the sum of all 100 numbers (each line's "product" is trivially that single number).

To see the multiplication logic in action, create a file with multiple numbers per line, e.g.:

```
echo "2.0 3.0 5.0
0.5 12.0" > sample.txt
./multandadd sample.txt
```

Expected output:

```
36.00000
```

(2.0 × 3.0 × 5.0 = 30, plus 0.5 × 12.0 = 6, total 36.)

## Notes

- If you run `multandadd` with no arguments, it prints `Please specify the file name` and exits with status 1, instead of crashing or hanging.
- If the given file doesn't exist (or can't be opened for another reason), it prints `Could not open <filename>` and exits with status 1, thanks to the `{$I-}`/`IOResult` check around `reset`.
- Removing the `readln(f)` call after the inner `while not SeekEoln(f) do` loop in `multandadd.pas` would make the program hang in an infinite loop — try it (in a copy of the file) to see why the source material calls this line out specifically.
