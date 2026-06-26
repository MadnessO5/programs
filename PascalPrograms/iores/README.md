# NoviceFileDemo — Pascal `{$I-}` and `IOResult` example

A beginner-friendly Pascal program that shows how to work with text files
**without crashing** when something goes wrong.

---

## The core idea

By default, Pascal throws a runtime error the moment a file operation fails
and your program stops. The compiler directive `{$I-}` turns that behaviour
off so you can check the result yourself:

```pascal
{$I-}
Reset(F);              // this might fail — but won't crash
ErrCode := IOResult;   // 0 = OK, anything else = error code
{$I+}

if ErrCode <> 0 then
  Writeln('Something went wrong, code: ', ErrCode);
```

| Directive | Meaning |
|-----------|---------|
| `{$I-}` | Disable automatic runtime error on I/O failure |
| `{$I+}` | Re-enable it (put this back after every check) |
| `IOResult` | Returns the error code of the last I/O operation — **reading it also clears it**, so always save it to a variable right away |

> **Important:** even when you don't care about an error (e.g. after `Close`),
> you still need to call `IOResult` once to clear the flag, otherwise the
> next file operation will see a stale error.

---

## What the program does

| Step | Procedure | What happens |
|------|-----------|--------------|
| 1 | `WriteToFile` | Creates `privet.txt` and writes 5 lines |
| 2 | `ReadFromFile` | Opens the file and prints every line with its number |
| 3 | `AppendToFile` | Opens the same file and adds 2 more lines at the end |
| 4 | `ReadFromFile` | Reads again — proves the new lines are really there |
| 5 | `FileExists` | Checks whether a file exists (trick: try to open it) |
| 6 | `ShowErrorExample` | Deliberately opens a missing file — shows the program does NOT crash |

---

## Files created at runtime

| File | Description |
|------|-------------|
| `privet.txt` | Created and written by the program |

---

## How to compile and run

You need **Free Pascal Compiler (FPC)** installed.

```bash
# compile
fpc NoviceFileDemo.pas

# run
./NoviceFileDemo        # Linux / macOS
NoviceFileDemo.exe      # Windows
```

Install FPC on Ubuntu/Debian:

```bash
sudo apt install fpc
```

---

## Common IOResult error codes

| Code | Meaning |
|------|---------|
| `0` | No error |
| `2` | File not found |
| `3` | Path not found |
| `5` | Access denied |
| `100` | Disk read error |
| `101` | Disk write error / disk full |
| `103` | File not open |

---

## Key rules to remember

1. Always write `{$I-}` **before** the operation and `{$I+}` **after**.
2. Save `IOResult` into a variable **immediately** — the next line resets it.
3. Use `Assign` / `Close`, not `AssignFile` / `CloseFile` — the latter require `uses SysUtils`.
4. Do not put `{` inside `{ comments }` — FPC warns about nested comment levels.
