# cmdline

A tiny Pascal program that prints all command-line arguments passed to it, using the built-in `ParamCount` and `ParamStr` functions.

## What it covers

- **`ParamCount`** — returns the number of command-line arguments passed to the program (not counting the program name itself).
- **`ParamStr(i)`** — returns the *i*-th command-line argument as a string. By convention, `ParamStr(0)` is the path/name of the program itself, and `ParamStr(1)`, `ParamStr(2)`, ... are the actual arguments the user typed.
- Looping `for i := 0 to ParamCount do` therefore visits every argument, starting with the program's own name at index 0.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc cmdline.pas
./cmdline one two three
```

Sample output:

```
[0]: ./cmdline
[1]: one
[2]: two
[3]: three
```

If you run it with no arguments at all:

```bash
./cmdline
```

```
[0]: ./cmdline
```

only index 0 (the program name) is printed, since `ParamCount` is `0`.

## Notes

- `ParamStr(0)` typically returns the exact path used to invoke the program (e.g. `./cmdline` or an absolute path), which can vary depending on how and from where you launch it.
- If an argument itself contains spaces, make sure to quote it on the command line (e.g. `./cmdline "hello world"`) so the shell treats it as a single argument — otherwise it will be split into two separate arguments.
- This is the standard, portable way in Pascal to read arguments the program was started with; it works the same way regardless of the operating system.
