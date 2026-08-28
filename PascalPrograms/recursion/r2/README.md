# Towers of Hanoi — Three Solutions

Three Pascal programs solving the Towers of Hanoi problem, based on section 2.11.2 ("Ханойские башни"), illustrating just how much simpler a recursive solution can be compared to two different non-recursive approaches.

## Files

- **`hanoi.pas`** — the recursive solution. A transcription of the program given in full in the source material.
- **`hanoi3.pas`** — a non-recursive solution using a dynamically-growing linked list of "tasks" (a small state machine per task: `StClearing` / `StLargest` / `StFinal`). Notably, `TaskState`, `ptask`, and `task` are declared **locally inside `solve`** rather than at the top level — since nothing outside `solve` ever needs to know about tasks, keeping the type declarations scoped to where they're used is good encapsulation (Pascal allows a `type` section inside a procedure, just like a `var` section).
- **`hanoi2.pas`** — a non-recursive solution using the "clever" cyclic-move algorithm the source material describes: odd moves shift the smallest disk in a fixed direction by formula; even moves are computed by figuring out which two rods don't currently hold the smallest disk, then moving between them. Each rod is represented as its own singly linked stack of disks (smallest disk at the head).

## What they cover

### `hanoi.pas` — recursion

- The classic recursive idea: to move `n` disks from `source` to `target` using `transit` as a spare, first move `n-1` disks from `source` to `transit` (using `target` as the spare for that sub-problem), then move the one remaining large disk directly, then move the `n-1` disks from `transit` to `target` (using `source` as the spare).
- **Base case**: `n = 0` — nothing to move, so `exit` immediately.
- The whole solving procedure is 8 lines long.
- `val(ParamStr(1), n, code)` — reads the disk count from the command line rather than interactively, exactly as the material recommends ("не будем... читать это число с клавиатуры; это неудобно и попросту глупо").

### `hanoi3.pas` — a list of pending tasks

- Instead of the call stack doing the bookkeeping (as in the recursive version), a linked list of `task` records explicitly tracks "what's left to do": how many disks, from where, to where, and which state that sub-problem is currently in.
- **`TaskState`** — an enumerated type with three values, each meaning "what to do next time we look at this task": `StClearing` (still need to move the smaller disks out of the way), `StLargest` (ready to move this task's largest disk), `StFinal` (this task is done — remove it).
- **`IntermRod(src, dst)`** — since only rod numbers 1, 2, 3 exist, the third (transit) rod is whichever one isn't `src` or `dst`.
- The main loop repeatedly looks at the *first* task in the list and acts according to its state — sometimes pushing a new task onto the front of the list (to be handled before returning to the current one), sometimes printing a move, sometimes removing a finished task.
- This directly mirrors the recursive structure, just with an explicit list standing in for the call stack that recursion would normally maintain automatically.

### `hanoi2.pas` — cyclic small-disk moves + computed remaining moves

- **`disk` / `pdisk`** — a node holding a disk's size (`k`) and a `next` pointer; each rod is a stack of these, smallest disk at the head (`rods[1]`, `rods[2]`, `rods[3]` are the three stack tops).
- **`MoveDiskItem(var RodFrom, RodTo: pdisk)`** — the actual move at the pointer level: detaches the top node of `RodFrom` and pushes it onto `RodTo`. Because `RodFrom`/`RodTo` are `var`-parameters, calling this with `rods[src]`, `rods[dst]` lets it modify those specific array elements directly — no need to pass the whole array or return values back manually.
- **`MoveDisk(var rods, src, dst)`** — prints the `<disk>: <src> -> <dst>` line (reading the disk size straight from the top of `rods[src]`), then calls `MoveDiskItem` to actually perform the move.
- **`MoveSmallest(var rods, turn, total)`** — implements the two odd-move formulas exactly as given in the source material, branching on whether `total` (the overall disk count `n`) is even or odd, to always move the smallest disk in the correct fixed cyclic direction.
- **`MoveLarger(var rods)`** — handles an even move. First, it figures out which rod currently holds the smallest disk on top (checking `rods[1]^.k = 1`, then `rods[2]^.k = 1`) and excludes that rod from the `{src, dst}` pair by reassigning whichever of `src`/`dst` initially pointed at it to `3` instead — leaving `{src, dst}` as exactly the two rods *not* holding the smallest disk. Then it checks whether the move as currently oriented is legal (source not empty, and — if the destination isn't empty — its top disk must be larger); if not, it swaps `src` and `dst`, which correctly covers both "one of the two rods is empty" and "the wrong one has the smaller top disk" in a single check.
- **`solve(n)`** — builds `rods[1]` by pushing disk sizes `n` downto `1` (ending with the smallest, `1`, on top), then loops — alternating `MoveSmallest` on odd turns and `MoveLarger` on even turns — until both `rods[1]` and `rods[2]` are empty (meaning every disk has made it onto rod 3).

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

All three take the number of disks as a single command-line argument:

```bash
fpc hanoi.pas   && ./hanoi 3
fpc hanoi3.pas  && ./hanoi3 3
fpc hanoi2.pas  && ./hanoi2 3
```

Each produces the same sequence of 7 moves (for `n = 3`) — the *order* of individual moves may look different in wording between the three programs' internal bookkeeping, but the actual sequence of `<disk>: <from> -> <to>` lines is the unique optimal solution and will match across all three (each was checked to reproduce the same valid move sequence).

Running any of them with no argument, or a non-numeric/zero/negative argument, reports an error to `ErrOutput` and exits with status 1:

```bash
./hanoi
```
```
No parameters given
```

## Testing

Two test scripts are provided:

- **`hanoi_test.sh`** — tests `hanoi.pas` alone, checking that solving `n` disks always produces exactly `2^n - 1` moves.
- **`hanoi_all_test.sh`** — tests all three programs (`hanoi.pas`, `hanoi2.pas`, `hanoi3.pas`) together, and goes a step further: since all three solve the identical problem optimally, their output for the same `n` isn't just the same *length*, it's **byte-for-byte identical**. The script checks the move count for each program individually, then directly compares `hanoi`'s output against `hanoi2`'s and against `hanoi3`'s. This kind of cross-checking independent implementations against each other (rather than against one hand-written "expected" transcript) is a useful technique in its own right — it was verified independently with a Python simulation of all three algorithms (for `n` = 1 through 8) before writing this script, confirming the sequences really do always match exactly.

```bash
fpc hanoi.pas
fpc hanoi2.pas
fpc hanoi3.pas
chmod +x hanoi_test.sh hanoi_all_test.sh
./hanoi_test.sh
./hanoi_all_test.sh
```

No output means every test passed. See `README_test_scripts.md` for more on how these harnesses work.

## Notes on relative complexity

The source material's whole point in presenting three solutions is to make a concrete comparison:

| Program | Approach | Meaningful lines of the solving logic |
|---|---|---|
| `hanoi.pas` | recursion | 8 |
| `hanoi3.pas` | task-list state machine | ~70 (90 total, including boilerplate) |
| `hanoi2.pas` | cyclic small-disk moves | ~87 (111 total, per the source material's description of the *original* file) |

Both non-recursive versions are well over ten times longer than the recursive one for equivalent functionality — a striking, concrete illustration of why recursion is often reached for specifically *because* it can turn an otherwise intricate bookkeeping problem into something almost trivially short, not merely because it's "more elegant" in the abstract.

## Notes

- `hanoi2.pas`'s correctness (valid moves, correct final arrangement, exactly `2^n - 1` total moves) was checked with a short Python simulation of the same algorithm for disk counts 1 through 12, since the logic (formula-driven odd moves, inferred-then-swapped even moves) is intricate enough to be worth verifying independently rather than trusting by inspection alone.
- All three programs use `val` for parsing (rather than `read`/`readln`), matching the source material's footnote explanation for why: reading the disk count interactively from the keyboard would be inconvenient for a program you'd typically want to re-run many times with different disk counts from a script or the shell.
- None of the three programs impose an explicit upper limit on `n`; since the move count is `2^n - 1`, even moderately large values (say, `n = 30`) would take an impractically long time to finish printing all the moves — this is an inherent property of the problem itself, not a flaw specific to any one of these implementations.
