# BlockFileCopy

A Pascal program that copies one file to another in 4KB chunks, based on section 2.9.4 ("Блочный ввод-вывод").

## What it covers

- **Untyped/block files (`file`)** — declared as plain `file` with no `of T` part. Unlike a typed file, an untyped file variable can be associated with *any* file regardless of its actual content or structure — it's used for reading/writing raw bytes in bulk, in whatever chunk size makes sense.
- **`reset(src, 1)` / `rewrite(dest, 1)`** — the second argument to `reset`/`rewrite` for an untyped file is the **block size** in bytes; if omitted, it defaults to 128. Here it's set to `1` so that `BlockRead`/`BlockWrite`'s own size arguments (in bytes) map directly to byte counts, rather than "blocks of 128 bytes."
- **`BlockRead(f, buf, count, result)`** — reads up to `count` blocks from `f` into the variable `buf`, and reports in `result` how many blocks were *actually* read. This is the key difference from ordinary `read`: it doesn't fail or block waiting for more data — it just tells you honestly how much it got, which is essential for detecting a short read near the end of a file.
- **`BlockWrite(f, buf, count, result)`** — the write counterpart, with the same four-parameter shape.
- **Detecting end-of-file via `BlockRead`** — if `result` comes back as `0` after a `BlockRead` call, that specifically means "nothing left to read" (end of file), which is how the copy loop knows when to stop.
- **`filemode`** — set to `0` (read-only) before opening the source file, and `1` (write-only) before opening the destination — since the program only ever reads from `src` and only ever writes to `dest`, requesting only the access it actually needs, which also means the copy will succeed even if you only have read permission on the source or only have create/write permission on the destination.
- **`ErrOutput`** — the built-in `text`-typed variable for the diagnostic/error output stream (equivalent to `stderr`); all error messages here are written to it instead of standard output, so they can be told apart from normal output (e.g. by redirecting `1>` and `2>` separately in the shell).
- **`{$I-}` / `IOResult`** — the familiar error-checking pattern, applied here to `assign`+`reset`/`rewrite` for both the source and destination files.
- **The loop structure** — an intentionally "infinite" `while true do` loop that only exits via `break`, either on reaching end-of-file (the normal case) or on a write error (`WriteRes <> ReadRes`) partway through — breaking out of the middle of the loop body rather than checking a condition only at the top or bottom.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc block_cp.pas
./block_cp source.txt destination.txt
```

This copies `source.txt` to `destination.txt` byte-for-byte, regardless of the file's actual content or format (text, binary, images — anything).

If you don't provide both filenames:

```bash
./block_cp
```
```
Expected: source and dest. names
```

If the source file doesn't exist or destination path is invalid, a corresponding `Couldn't open ...` message appears — all such messages go to the error stream, so you can separate them from normal output if needed:

```bash
./block_cp missing.txt out.txt 2> errors.log
```

## Notes

- `BufSize = 4096` (4 KB) chunks strike a practical balance for this kind of program — large enough to avoid excessive read/write call overhead, small enough not to use much memory regardless of how large the files being copied are.
- The final `BlockRead` call on a file whose size isn't an exact multiple of `BufSize` will report fewer bytes read than requested (but still greater than `0`) — the loop handles this correctly, since it only stops when `ReadRes` is exactly `0`, not when it's merely less than `BufSize`.
- This program has no special handling for the source and destination being the same file, or the destination already existing with important contents — `rewrite` will silently overwrite an existing destination file, same as with any other file type.
