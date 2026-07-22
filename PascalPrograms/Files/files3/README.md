# Typed File Demos

Two Pascal programs demonstrating typed files (`file of T`), based on section 2.9.3 ("Типизированные файлы").

## Files

- **`gennumbin.pas`** — a transcription of the book's example: generates a binary file (`numbers.bin`) of 100 `longint` values, the typed-file counterpart to the earlier `gennumtx.pas` text-file example (same numbers, different storage format).
- **`namedpoints.pas`** — an interactive program using `file of NamedPoint` (a record type with `latitude`, `longitude`, and `name` fields) to store a list of named geographic points, then demonstrates in-place record updates using `seek`.

## What they cover

- **`file of T`** — a typed file is a sequence of fixed-size records, all of the same type `T`. Unlike text files, records can be of (almost) any type — including, very commonly, a `record` type, as in `namedpoints.pas`.
- **`write(f, n)` / `read(f, np)`** — the same procedures used for text files, but for a typed file they read/write the type's exact in-memory (binary) representation rather than a human-readable textual form — e.g. a `longint` always takes exactly 4 bytes, regardless of how many digits it "looks like" it needs.
- **No `append` for typed files** — only `reset` (open existing) and `rewrite` (create/truncate) are available; typed files don't support opening in "append" mode the way text files do.
- **Typed files are positionable** — since every record has the same fixed size, the file's current position can be moved directly to any record with `seek(f, recordNumber)` (the first record is number `0`), unlike text files, which must be processed strictly start-to-finish.
- **Read-then-write-in-place pattern** — `namedpoints.pas`'s renaming step demonstrates the exact sequence from the source material: `seek(f, idx)` to jump to a record, `read(f, np)` to load it, modify the loaded copy, then `seek(f, idx)` *again* before `write(f, np)` — because after a `read`, the file's position has already advanced to the *next* record, so writing without re-seeking would overwrite the wrong one.
- **`filemode`** — mentioned in the source material as the global variable controlling whether `reset` opens a typed file for reading only (`filemode := 0`), or for reading and writing (the default, `filemode := 2`); useful if you only have read permission on a file and `reset` would otherwise fail trying to also request write access.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc gennumbin.pas
./gennumbin
```

Creates `numbers.bin` (100 × 4 = 400 bytes, since each `longint` is 4 bytes) — unlike `numbers.txt` from the text-file example, this file is binary and won't display sensibly with `cat`.

```bash
fpc namedpoints.pas
./namedpoints
```

Sample session (abbreviated):

```
Сколько точек записать в файл? 2
Точка №0:
  Название: Home
  Широта: 55.75
  Долгота: 37.61
Точка №1:
  Название: Office
  Широта: 55.76
  Долгота: 37.64

Файл записан. Все точки по порядку:
0: Home (55.75000, 37.61000)
1: Office (55.76000, 37.64000)

Введите номер точки для переименования (0..1): 1
Новое название для точки №1: Work

Файл после изменения:
0: Home (55.75000, 37.61000)
1: Work (55.76000, 37.64000)
```

## Notes

- `numbers.bin` and `points.bin` are binary files; opening them in a text editor will show garbled/non-printable characters — this is expected, since they store the exact in-memory representation of `longint`/`NamedPoint` values, not text.
- The `name` field uses `string[15]` (a bounded string, see the earlier `string_type_demo.pas` example) rather than plain `string`, specifically because a typed file's records must have a genuinely fixed size — an unconstrained `string` wouldn't work here.
- Both programs use `reset`/`rewrite`'s default behavior (open for both reading and writing, `filemode = 2`); neither demonstrates changing `filemode`, since neither needs read-only access to a file it doesn't have write permission for.
