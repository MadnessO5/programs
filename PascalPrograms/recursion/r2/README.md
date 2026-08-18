# Towers of Hanoi — Three Solutions

Three Pascal programs solving the Towers of Hanoi problem, based on section 2.11.2 ("Ханойские башни"), illustrating just how much simpler a recursive solution can be compared to two different non-recursive approaches.

## Files

- **`hanoi.pas`** — the recursive solution. A transcription of the program given in full in the source material.
- **`hanoi3.pas`** — a non-recursive solution using a dynamically-growing linked list of "tasks" (a small state machine per task: `StClearing` / `StLargest` / `StFinal`). Assembled from the complete code fragments given in the source material (types, the `IntermRod` helper, and the main processing loop), wrapped in a `solve` procedure and a command-line-argument-parsing main block mirroring `hanoi.pas`'s.
- **`hanoi2.pas`** — a non-recursive solution using the "clever" cyclic-move algorithm (odd moves shift the smallest disk in a fixed direction by formula; even moves are forced/computed by comparing the two rods not holding the smallest disk). **Important**: the source material explicitly says it omits this file's actual code "to save space," describing only the algorithm and its formulas in prose. This file is therefore a from-scratch **reconstruction** based on that description — not a transcription of the original — built using three singly linked lists (one per rod) as the material specifies, and verified independently (see Notes) to produce correct, valid move sequences for a range of disk counts.

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

- **Odd-numbered moves** always move the smallest disk, cycling through the rods in a fixed direction determined once by whether `n` is even or odd (`1→2→3→1→...` for even `n`, `1→3→2→1→...` for odd `n`), computed directly from the move formulas given in the source material — no comparison needed, since which rod the smallest disk starts on is always known from the previous move.
- **Even-numbered moves** never touch the smallest disk. Among the *other* two rods, the disk on top of whichever one is smaller (or, if one of the two is empty, that empty one) receives the move — implemented here with a **sentinel value** (`n + 1`, guaranteed larger than any real disk) representing "the top of an empty rod," which lets one comparison (`TopValue(rod[a]) < TopValue(rod[b])`) handle both the "compare two real disks" and "one rod is empty" cases uniformly, without separate branches.
- **Three linked lists as stacks** — `PushDisk`/`PopDisk` insert/remove at the head, exactly the head-insertion/removal pattern from `numbers1.pas`, used here to represent each rod as a stack of disk sizes (smallest on top, at the head).

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

## Notes on relative complexity

The source material's whole point in presenting three solutions is to make a concrete comparison:

| Program | Approach | Meaningful lines of the solving logic |
|---|---|---|
| `hanoi.pas` | recursion | 8 |
| `hanoi3.pas` | task-list state machine | ~70 (90 total, including boilerplate) |
| `hanoi2.pas` | cyclic small-disk moves | ~87 (111 total, per the source material's description of the *original* file) |

Both non-recursive versions are well over ten times longer than the recursive one for equivalent functionality — a striking, concrete illustration of why recursion is often reached for specifically *because* it can turn an otherwise intricate bookkeeping problem into something almost trivially short, not merely because it's "more elegant" in the abstract.

## Notes

- `hanoi2.pas`'s correctness (valid moves, correct final arrangement, exactly `2^n - 1` total moves) was checked independently with a short Python simulation of the same algorithm for disk counts 1 through 11, since the original Pascal file this section describes isn't reproduced in the source material to compare against directly.
- All three programs use `val` for parsing (rather than `read`/`readln`), matching the source material's footnote explanation for why: reading the disk count interactively from the keyboard would be inconvenient for a program you'd typically want to re-run many times with different disk counts from a script or the shell.
- None of the three programs impose an explicit upper limit on `n`; since the move count is `2^n - 1`, even moderately large values (say, `n = 30`) would take an impractically long time to finish printing all the moves — this is an inherent property of the problem itself, not a flaw specific to any one of these implementations.
