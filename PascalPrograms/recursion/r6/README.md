# TreeBasics

An interactive companion to `treedemo.pas`, covering the code examples from §2.11.5 that come **before** `SearchTree` is introduced: `SumTree`, and the original ("naive," pre-unification) versions of `AddToTree` and `IsInTree`. Where `treedemo.pas` demonstrates the shorter, `SearchTree`-based rewrite, this program demonstrates the earlier versions the source material builds up to that point — useful for seeing exactly what `SearchTree` later manages to factor out.

## Menu

```
1 - Добавить число (AddToTree)
2 - Проверить наличие числа (IsInTree)
3 - Сумма всех узлов (SumTree)
4 - Показать дерево по возрастанию
0 - Выход
```

## What it covers

- **`SumTree(p): longint`** — the section's opening example, and the simplest possible illustration of the general pattern used throughout: an empty tree sums to `0`; a non-empty tree's sum is its left subtree's sum, plus its own value, plus its right subtree's sum.
- **`AddToTree(var p, val, var ok)`** — the *original* insertion procedure, written before `SearchTree` exists. Note how similar its structure is to `IsInTree` below — both recurse left when `val` is smaller, right when it's larger, and both need to explicitly repeat that same three-way comparison. This near-duplication is exactly what motivates factoring the comparison logic out into `SearchTree`, as `treedemo.pas` then does.
- **`IsInTree(p, val, var res)`** — the *original* membership-check procedure, deliberately written as a `procedure` with a `var res: boolean` output parameter rather than a `function`, even though (as the source material itself notes) a `function` would arguably be the more natural fit here, specifically to highlight the structural resemblance to `AddToTree` above.
- **`PrintInOrder`** / **`FreeTree`** — not from this particular section, but the same recursive in-order traversal and recursive tree-freeing patterns from `bst_demo.pas`, included here so you can actually see what's in the tree and clean up properly when you're done.

## How this compares to `treedemo.pas`

| | `tree_basics.pas` (this file) | `treedemo.pas` |
|---|---|---|
| Duplicate-key handling | `AddToTree` sets `ok := false` via an explicit third comparison branch | `AddToTree` checks `pos^ = nil` once, after a single `SearchTree` call |
| Shared logic between insert/lookup | Each repeats its own left/right/equal comparison independently | Factored into one `SearchTree` function, used by both |
| `IsInTree`'s shape | `procedure` with `var res: boolean` | `function ... : boolean` (a one-line body) |

Functionally, both programs' tree operations behave identically — same insertion rules, same rejection of duplicate keys, same lookup behavior — the difference is purely in how much of the logic is shared versus repeated.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc tree_basics.pas
./tree_basics
```

## Sample session (abbreviated)

```
Выбор: 1
Число для добавления: 50
Successfully added

Выбор: 1
Число для добавления: 25
Successfully added

Выбор: 1
Число для добавления: 75
Successfully added

Выбор: 1
Число для добавления: 25
Couldn't add!

Выбор: 2
Число для проверки: 75
Yes!

Выбор: 3
Сумма узлов дерева: 150

Выбор: 4
По возрастанию: 25 50 75
```

## Notes

- As with `bst_demo.pas` and `treedemo.pas`, this tree is **not self-balancing** — inserting already-sorted values will degrade it toward a linked list in terms of search/insert performance.
- `AddToTree` and `IsInTree` here are still fully recursive, exactly as the source material insists is necessary (as opposed to merely convenient, the way it is for lists) for tree operations to stay tractable.
