# TreeDemo

A binary search tree of `longint` values, driven by a simple command stream on standard input, based on section 2.11.5 ("Работа с двоичным деревом поиска"). This is the demo program the source material references (`treedemo.pas`) after developing `SearchTree`, `AddToTree`, and `IsInTree`.

## What it does

On startup, prints a short welcome banner explaining the command format, then reads lines from standard input, each starting with a single-character command followed by a number:

- **`+ n`** — add `n` to the tree. Prints `Successfully added`, or `Couldn't add!` if `n` is already present (this tree rejects duplicate keys).
- **`? n`** — check whether `n` is in the tree. Prints `Yes!` or `No.`.
- Anything else — prints `I don't know such command! Try "+" or "?"`.

```bash
echo '+ 50
+ 25
+ 75
? 25
? 99
+ 25' | ./treedemo
```
```
=== Двоичное дерево поиска ===
Вводите команды в формате: <команда> <число>
  + 5   -> добавить число 5 в дерево
  ? 5   -> проверить, есть ли число 5 в дереве
Для выхода нажмите Ctrl+D (Linux/macOS) или Ctrl+Z (Windows)

Successfully added
Successfully added
Successfully added
Yes!
No.
Couldn't add!
Работа завершена, до свидания!
```

## What it covers

- **`TreeNode` / `TreeNodePtr`** — a binary tree node: `data` plus `left`/`right` pointers to subtrees (either possibly `nil`, meaning "no subtree there").
- **Recursion is what makes tree code *possible*, not just nicer** — as the source material stresses, for linked lists recursion is a convenience; for trees, trying to avoid it (as the closing exercise notes) means manually tracking "how did I get to this node, and what's left to do here" for every node visited, which is genuinely difficult to get right without recursion doing that bookkeeping for you automatically.
- **`SearchTree(var p, val): TreeNodePos`** — the key unifying idea in this section. Instead of writing separate near-identical "search for where to insert" and "search for whether something exists" functions, `SearchTree` returns the *address of the pointer variable* that either already points at a node containing `val`, or is the `nil` pointer where such a node *would* go. Since `p` is a `var`-parameter, `@p` gives the address of whatever real variable the caller passed in — the top-level `root`, or (in a recursive call) a node's actual `left`/`right` field — letting one function serve both "does this exist" and "where should this be inserted" callers.
- **`TreeNodePos = ^TreeNodePtr`** — a pointer to a pointer, needed because `SearchTree`'s result must be able to represent "the address of a `TreeNodePtr` variable," and `TreeNodePtr` alone can only represent "the address of a `TreeNode`."
- **`AddToTree(var p, val): boolean`** — calls `SearchTree` once; if the returned position holds `nil` (`pos^ = nil`), no node with `val` exists yet, so a new one is created *directly at that position* (`new(pos^)`) — this single line does the work that inserting at the tree's root, or deep inside either subtree, would each otherwise require separate code for. If the position already holds a real node (`pos^ <> nil`), `val` is a duplicate, and the function reports failure by returning `false`.
- **`IsInTree(p, val): boolean`** — after factoring the search logic out into `SearchTree`, this becomes a one-liner: the value exists exactly when the position `SearchTree` finds is *not* `nil`.
- **`root: TreeNodePtr = nil;`** — a variable declaration with an **initial value**. Free Pascal allows giving a starting value directly in the `var` section for simple cases like this, so `root` is a valid empty tree from the moment the program starts, without needing a separate initialization statement.
- **`readln(c, n)`** — reads a single character into `c`, then continues reading on the same line for a `longint` into `n` — this is exactly the multi-value `read`/`readln` behavior discussed back in the standard-input chapters, just applied to a `char` followed by a number instead of several numbers.

## Debug printing

Following section 2.13.3 ("Отладочная печать"), this program includes debug output wrapped in `{$IFDEF DEBUG}` / `{$ENDIF}` conditional-compilation blocks — compiled in only when explicitly requested, adding zero overhead to a normal build:

```bash
fpc -dDEBUG treedemo.pas
```

With `-dDEBUG`, every call to `SearchTree` prints which node it's currently examining (or that it's reached an empty subtree), every successful/rejected `AddToTree` call announces what happened, and — following the source material's advice for dumping a complex data structure's current contents — a `DebugDumpTree` procedure prints the whole tree's contents in sorted order after every successful insertion, so you can watch it grow one value at a time:

```
$ fpc -dDEBUG treedemo.pas && echo '+ 50
+ 25
+ 75' | ./treedemo
...
DEBUG: SearchTree reached an empty subtree, val = 50
DEBUG: AddToTree inserted 50
DEBUG: tree contents, sorted: 50
Successfully added
DEBUG: SearchTree at node 50, looking for 25
DEBUG: SearchTree reached an empty subtree, val = 25
DEBUG: AddToTree inserted 25
DEBUG: tree contents, sorted: 25 50
Successfully added
...
```

Compiling `fpc treedemo.pas` without `-dDEBUG` produces the exact same program as before — no `DEBUG:` lines, and `DebugPrintTree`/`DebugDumpTree` aren't even compiled into the executable, exactly as the source material recommends for keeping debug-only code out of a release build without deleting it.

## Testing

`treedemo_test.sh` feeds fixed command sequences into the program and checks the resulting `Yes!`/`No.`/`Successfully added`/`Couldn't add!` transcript against hand-verified expected results (the program's welcome banner and goodbye line are stripped out first, since they never change):

```bash
fpc treedemo.pas
chmod +x treedemo_test.sh
./treedemo_test.sh
```

No output means every test passed. Note: this script uses GNU `head -n -1` (all but the last line), which isn't available on macOS's BSD `head` — it's written for Linux.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc treedemo.pas
./treedemo
```

Type commands directly (press Ctrl+D / Ctrl+Z to end input), or pipe/redirect a file of commands as shown above.

## Notes

- **This tree can become unbalanced**, exactly as warned about in §2.10.8 — inserting values in already-sorted order will degrade it toward a linked list, with search/insert cost proportional to the number of elements rather than the tree's (small) height in a balanced case. This program implements the tree described in this section, not a self-balancing variant; the source material explicitly points to Wirth, Cormen/Leiserson/Rivest, and Knuth for readers who want to pursue balancing algorithms further.
- **Duplicate keys are rejected outright** (`AddToTree` returns `false`, nothing is inserted). The source material notes this is one of several reasonable choices when keys collide (others being "count occurrences" or "silently ignore") — this program's tree simply treats each key as either present or absent, never present-with-a-count.
- The source material's own closing challenge — implementing tree traversal (needed for something like the earlier `SumTree` example) *without* recursion — is deliberately left unattempted here; it explicitly compares the difficulty to the iterative Towers of Hanoi solutions (`hanoi2.pas`/`hanoi3.pas` in this collection) and says the book will return to it later, in the context of C.
