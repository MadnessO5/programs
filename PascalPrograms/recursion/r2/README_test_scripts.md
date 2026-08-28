# Test Scripts

Three automated test harnesses, following the pattern from section 2.13.2 ("Тесты") — `frcancel_test.sh` — applied to programs from earlier in this collection.

## Files

- **`match_pt_test.sh`** — tests `match_pt.pas` (the `*`/`?` pattern matcher). Each test line is `<string> <pattern> <expected result>`; the script runs the program with those two arguments and compares its output to the expected `yes`/`no`.
- **`hanoi_test.sh`** — tests `hanoi.pas` (the recursive Towers of Hanoi solver) alone, checking a *property* of the output rather than its exact text: for `n` disks, the solution must always print exactly `2^n - 1` lines (one per move).
- **`hanoi_all_test.sh`** — tests `hanoi.pas`, `hanoi2.pas`, and `hanoi3.pas` together via **differential testing**: since all three solve the identical problem optimally, their move sequences for the same `n` must be exactly identical to each other, not merely the same length. The script checks each program's move count individually, then directly diffs `hanoi`'s output against `hanoi2`'s and `hanoi3`'s.

## Requirements

- `match_pt.pas` and `hanoi.pas` compiled (`fpc match_pt.pas`, `fpc hanoi.pas`) with the resulting executables (`match_pt`, `hanoi`) in the same directory as the test scripts.
- `zsh` (both scripts use `#!/bin/zsh`, matching your shell — the `while read ... do ... done <<END ... END` construct works the same way in `zsh` as in the `/bin/sh` used in the source material's own example).

## How to run

```bash
chmod +x match_pt_test.sh hanoi_test.sh
./match_pt_test.sh
./hanoi_test.sh
```

Following the source material's own convention: **no output means every test passed.** If a test fails, exactly that test prints a line explaining what was expected versus what actually happened, e.g.:

```
TEST abc a??c FAILED: expected no, got yes
```

## Why these two, and why this style

- Both scripts read one test per line via the shell's `read` builtin, feed test data through a `<<END ... END` "here document" (exactly as demonstrated for `frcancel_test.sh`), and only print something when a test disagrees with its expected result — so running the whole suite takes one command and produces no noise when everything's fine.
- `match_pt.pas` was chosen first because it fits the source material's four-values-per-line pattern almost exactly (two inputs, one expected output, all short single "words" with no embedded spaces — the same shape as the `frcancel` numerator/denominator example).
- `hanoi.pas` was chosen second specifically to show a *different* kind of test: its actual output is a whole list of moves, not a single value, so comparing it line-by-line against a hand-written expected transcript would be tedious to maintain and easy to get wrong when re-typing by hand. Checking the *move count* instead is quick to write, easy to verify by hand (`2^n - 1` is simple arithmetic), and would still catch most realistic bugs — e.g. an off-by-one in the recursion's base case, or a duplicated/dropped move.

## Notes

- Both test data sets are intentionally simple "words" with no embedded spaces, since the shell's `read` builtin splits each line on whitespace — the source material's own test format has the same limitation, and it's a reasonable one for this style of quick test harness.
- Per the source material's advice, these test files are meant to be **kept and re-run** after any change to `match_pt.pas` or `hanoi.pas`, not deleted once they pass — that's the entire point of having them in the first place.
- Feel free to add more lines before `END` in either script; each new line becomes a new test with zero additional code.
