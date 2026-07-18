# HelloFile

A minimal Pascal program demonstrating text-file output: writing `"Hello, world!"` to a file on disk, based on section 2.9 ("Файлы").

## What it covers

- **File variables** — `f: text` is a *file variable*, a special kind of variable whose only valid values are "whatever is currently stored in this file variable" (see the source material's discussion of why this is different from ordinary variables). A file variable can only be passed to subprograms as a `var`-parameter.
- **`assign(f, filename)`** — associates a file variable with a filename on disk. This call alone does *not* open the file or check whether it exists; it just links the name to the variable. Filenames starting with `/` are absolute; anything else is relative to the current directory (a Unix convention, not a Pascal one).
- **`rewrite(f)`** — opens the file for writing. If it doesn't exist, it's created; if it does exist, its previous contents are discarded and writing starts from scratch. (The alternative, `reset`, opens an *existing* file for reading; `append` opens a text file for writing at its end.)
- **`writeln(f, message)`** — writes to the file instead of standard output, simply by passing the file variable as the first argument — this works the same way for `write`/`writeln`/`read`/`readln` on text files.
- **`close(f)`** — closes the file once done with it. The file variable can then be reused for a different file (or the same one again) via another `assign`.
- **`{$I-}` and `IOResult`** — the same I/O-error-checking technique from the earlier `OlympiadCounter` example, applied here to `assign`/`rewrite`/`write` operations. File operations can fail for all sorts of reasons outside a program's control (permissions, missing directories, a full disk), so checking `IOResult` after `rewrite` and after `writeln` lets the program report a specific, useful error message instead of crashing or silently doing nothing.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc hellofile.pas
./hellofile
```

After running, a file `hello.txt` appears in the current directory:

```bash
ls -l hello.txt
cat hello.txt
```

```
Hello, world!
```

(14 bytes: 13 characters of the message plus a trailing newline.)

## Notes

- Running the program again simply overwrites `hello.txt` from scratch, since `rewrite` always starts fresh — this is different from `append`, which would add to the end of an existing file instead.
- The two error messages aren't equally important in practice: failing to *open* a file (bad path, no permissions, disk full) is common and worth handling explicitly; failing to *write* to an already-successfully-opened file is much rarer (though still possible, e.g. if the disk fills up mid-write), which is why the source material calls out the first check as the more critical of the two.
- This program only demonstrates writing. Reading a file back (with `reset` instead of `rewrite`) follows the same `assign`/open/`read`or`readln`/`close` pattern, just with the read procedures instead of write ones.
