# File Operations: Erase and Rename

Two small Pascal programs demonstrating whole-file operations, based on section 2.9.5 ("Операции над файлом как целым").

## Files

- **`erase_f.pas`** — deletes a file from disk, given its name as a command-line argument.
- **`renamefile.pas`** — renames (or moves) a file, given its old and new names as command-line arguments.

## What they cover

- **`erase(f)`** — deletes the file that `f` is currently associated with. Takes a file variable of *any* file type (`file`, `text`, or a typed file) — here `file` (untyped) is used since the program never actually reads or writes the file's contents, only deletes it.
- **`rename(f, newName)`** — renames the file `f` is associated with to `newName`. Same idea: works with any file type.
- **The critical precondition for both**: the file variable must have a filename assigned via `assign`, but the file must **not** currently be open. That means: call `assign`, then call `erase`/`rename` directly — do *not* call `reset`, `rewrite`, or `append` first (or if you did open it for some other reason, `close` it before erasing/renaming).
- **`{$I-}` / `IOResult`** — the same error-checking pattern as always, applied here to `erase`/`rename` themselves rather than to opening a file, since these operations can fail too (e.g. the file doesn't exist, or you lack permission to delete/rename it).
- **`ParamCount` / `ParamStr`** — both programs take their filename(s) from the command line, checking first that enough arguments were actually provided.
- **`ErrOutput`** — as in the earlier `block_cp.pas` example, all error messages go to the diagnostic/error stream rather than standard output.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc erase_f.pas
./erase_f unwanted.txt
```

Deletes `unwanted.txt`. If no filename is given, or the file can't be erased (doesn't exist, no permission), an error message goes to `ErrOutput` and the program exits with status 1.

```bash
fpc renamefile.pas
./renamefile old_name.txt new_name.txt
```

Renames `old_name.txt` to `new_name.txt`. If fewer than two arguments are given, or the rename fails, an error message goes to `ErrOutput` and the program exits with status 1.

## Notes

- **This is permanent.** `erase` does not move a file to a trash/recycle bin — it deletes it directly, the same way the `rm` command does on Linux/macOS. There's no built-in undo.
- `rename` can also be used to *move* a file to a different directory (not just change its name in place), as long as the new path is on the same filesystem — this follows the same rules as the operating system's own rename/move operation.
- Both programs use the untyped `file` type purely as a "handle" to name a file — neither ever calls `reset`/`rewrite` on it, since `erase`/`rename` require the file variable to stay unopened.
