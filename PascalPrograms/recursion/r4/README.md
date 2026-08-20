# RecursiveListDemo

An interactive program demonstrating three classic recursive operations on a singly linked list — summing, freeing, and sorted insertion — based on section 2.11.4 ("Рекурсия при работе со списками").

## What it covers

- **The recursive nature of a list** — a singly linked list is either empty (`nil`), or a first element plus "the rest of the list" (which is itself a complete, smaller list). Every function here follows directly from that definition: handle the empty case (the base case), then handle the non-empty case in terms of the first element plus a recursive call on `p^.next`.
- **`ItemListSum(p): integer`** — the sum of an empty list is `0`; the sum of a non-empty list is its first element plus the sum of everything after it. This mirrors the mathematical definition of a sum almost exactly, and is noticeably shorter than the equivalent loop-based version (also shown in the source material) that manually tracks a running total and a traversal pointer.
- **`DisposeItemList(p)`** — freeing an empty list does nothing; freeing a non-empty list means freeing *the rest of the list first*, and only then disposing of the first element. The order matters: disposing of the first element before recursing into `p^.next` would destroy the pointer needed to reach the rest of the list, since `p^.next` lives inside the very memory `dispose(p)` would release.
- **`AddNumIntoSortedList(var p, n)`** — inserts `n` into an already-sorted (ascending) list, keeping it sorted, using three cases from the source material collapsed into two `if`/`else` branches: (1) the list is empty, or (2) its first element is already bigger than `n` — both handled identically by creating a new node and making it the new first element; or (3) the first element is smaller or equal, in which case the problem reduces to "insert `n` into the *rest* of the list," handled by a recursive call on `p^.next`. Because `p` is a `var`-parameter, this same recursive call works correctly whether `p` refers to the original list's head or to some inner node's `next` field — no separate pointer-to-pointer trick (as used in the iterative `sortedinsert.pas` version of the same problem) is needed here.
- **`PrintList(p)`** — an ordinary iterative traversal, included just to display the list's contents; not every list operation needs to be recursive, and a simple print loop is perfectly natural here.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc recursive_list.pas
./recursive_list
```

## Sample session

```
Сколько чисел ввести? 4
Число №1: 30
Число №2: 10
Число №3: 20
Число №4: 5

Список по возрастанию: 5, 10, 20, 30
Сумма элементов списка (рекурсивно): 65
Память списка полностью освобождена (рекурсивно)
```

## Notes

- **Recursion depth is bounded by list length.** As the source material warns, both `ItemListSum` and `DisposeItemList` make one recursive call per element, so a list with millions of elements could exhaust the call stack — a genuine practical limit, though (also per the source material) lists that large are unusual in the first place. This demo, driven by interactive input, is never going to approach that limit in practice.
- Compare `AddNumIntoSortedList` here to the iterative `pp: ^itemptr`-based version in `sortedinsert.pas` from earlier in this collection — both solve the identical problem and produce identical results, but the recursive version needs no explicit pointer-to-pointer bookkeeping at all, since each recursive call naturally operates on "a `var`-pointer to wherever the next node should be attached," letting Pascal's own parameter-passing machinery do the work that the iterative version had to do by hand.
