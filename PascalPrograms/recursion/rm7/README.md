# UnitDemo + lngtree

A transcription of the book's own example from section 2.14.1 ("Модули в Паскале"): a binary search tree from §2.11.5, split into a proper Free Pascal unit (`lngtree.pp`) and a small program that uses it (`unitdemo.pas`).

## Files

- **`lngtree.pp`** — a unit exporting exactly two things: the tree node types (`TreeNodePtr`, `TreeNode`) and two subprograms (`AddToTree`, `IsInTree`). The helper function `SearchTree` and its return type `TreeNodePos` — the same "unify insertion and lookup" trick from `treedemo.pas` — are implementation details kept out of the interface, since the module's user never needs to know how the search itself works.
- **`unitdemo.pas`** — reads `"+ n"` / `"? n"` commands from standard input and calls into `lngtree` to add numbers to a tree or check whether they're present.

## What this demonstrates, from section 2.14.1

- **`interface` vs. `implementation`** — `lngtree.pp`'s `interface` section lists only `TreeNodePtr`, `TreeNode`, `AddToTree`'s header, and `IsInTree`'s header. `TreeNodePos` and `SearchTree` are declared *after* `implementation`, so `unitdemo.pas` has no way to reference them at all — not because of a convention, but because the compiler genuinely doesn't expose those names outside the unit.
- **Why hide `SearchTree`**: the book's own reasoning — "what if we want to change this implementation later?" `AddToTree`/`IsInTree` promise to keep working the same way; `SearchTree` is free to be rewritten, renamed, or removed entirely without breaking `unitdemo.pas` or any other program that uses `lngtree`.
- **`uses lngtree;`** — the single line in `unitdemo.pas` that pulls in everything `lngtree.pp`'s interface exports. No `{$I}`, no manual copying — the compiler locates `lngtree.pp` (or its already-compiled `lngtree.ppu`, if up to date) on its own.
- **One compiler invocation builds everything**:
  ```bash
  fpc unitdemo.pas
  ```
  Free Pascal compiles `lngtree.pp` automatically (producing `lngtree.ppu` and `lngtree.o`), only if it's missing or older than `lngtree.pp` itself, then links everything into the `unitdemo` executable.
- **`root: TreeNodePtr = nil;`** — a variable declared with an initial value directly in its `var` section (Free Pascal allows this for simple cases), so the tree starts out as a valid empty tree with no separate initialization statement needed.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.
- `lngtree.pp` must be in the same directory as `unitdemo.pas`.

## How to build and run

```bash
fpc unitdemo.pas
echo '+ 50
+ 25
+ 75
? 25
? 99' | ./unitdemo
```
```
Successfully added
Successfully added
Successfully added
Yes!
No.
```

You can also compile just the unit, to check it on its own:

```bash
fpc lngtree.pp
```

## Testing

```bash
chmod +x unitdemo_test.sh
./unitdemo_test.sh
```

No output means every test passed. Covers adding, looking up present/absent values, rejecting a duplicate insert, and an unrecognized command — `unitdemo.pas` (unlike `treedemo.pas`) prints no banner or goodbye line, so no output-stripping is needed before comparing.

## Debug printing

`lngtree.pp`'s `SearchTree` and `AddToTree` include `{$IFDEF DEBUG}`-guarded tracing, entirely inside the unit's `implementation` section — so turning debug output on or off never touches `unitdemo.pas` at all:

```bash
fpc -dDEBUG unitdemo.pas
echo '+ 50
+ 25' | ./unitdemo
```
```
DEBUG: SearchTree reached an empty subtree, val = 50
Successfully added
DEBUG: SearchTree at node 50, looking for 25
DEBUG: SearchTree reached an empty subtree, val = 25
Successfully added
```

## Notes

- **Rebuilding is incremental.** Run `fpc unitdemo.pas` once, then again without changing anything — the second run skips recompiling `lngtree.pp` (its `.ppu` is already current) and only rebuilds `unitdemo.pas`. Edit `lngtree.pp` and run again, and the unit gets rebuilt too, automatically, based on file modification times.
- `lngtree.pp` uses the `.pp` extension, exactly as the source material recommends for unit source files, as opposed to `.pas` for a main program.
- This tree, like every other one in this collection, is **not self-balancing** — the same caveat from `bst_demo.pas`/`treedemo.pas` applies: inserting already-sorted values will degrade it toward a linked list.
