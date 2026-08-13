# BSTDemo

An interactive binary search tree for integers, illustrating the concepts from section 2.10.8 ("Обзор других динамических структур данных"). The source material at this point is a conceptual overview with no Pascal listing of its own — this program is a hands-on companion so the ideas it describes (search key, linear vs. logarithmic search time, tree height, balance) aren't purely abstract.

## What it covers

- **A tree node (`Node`)** — like a linked-list node, but with *two* pointers instead of one: `left` and `right`, pointing at the left and right subtrees (either of which may be `nil`, meaning "no subtree there").
- **The binary-search-tree ordering rule** — at every node, everything in its left subtree is smaller, everything in its right subtree is larger. This is what makes searching fast: at each step, comparing against the current node's value eliminates roughly half of the remaining possibilities.
- **`BSTInsert`** — uses the same pointer-to-pointer technique from §2.10.6/2.10.7 (`pp: ^NodePtr`) to walk down from the root, following `left` or `right` depending on the comparison, until it finds the `nil` spot where the new value belongs, then creates the node there. Duplicate values are silently ignored (the tree in this demo holds each distinct value at most once).
- **`BSTSearch`** — walks down from the root the same way, following `left`/`right` based on comparisons, until it either finds the value or falls off the tree (`nil`). It also counts and reports the number of comparisons made — directly illustrating the source material's central claim: search cost is proportional to the tree's *height*, not to how many values it holds overall.
- **`BSTHeight` / `BSTCount`** — small **recursive** functions (a node's height is `1 + max(height of left subtree, height of right subtree)`; its count is `1 + count of left + count of right`). The source material explicitly notes that tree operations are usually far simpler to write recursively than iteratively — these two functions are a first, gentle taste of that, ahead of the dedicated recursion chapter.
- **`BSTPrintInOrder`** — also recursive: print the left subtree, then the current node, then the right subtree. For a valid binary search tree, this always visits every value in ascending sorted order — for free, with no explicit sorting step.
- **`BSTFree`** — recursively frees every node (left subtree, then right subtree, then the node itself), the tree equivalent of walking and `dispose`-ing a linked list.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc bst_demo.pas
./bst_demo
```

You'll get a menu:

```
1 - Добавить число        4 - Высота дерева
2 - Найти число            5 - Количество узлов
3 - Показать по возрастанию 0 - Выход
Выбор:
```

## Sample session (abbreviated)

```
Выбор: 1
Число для добавления: 50
...
Выбор: 1
Число для добавления: 25
...
Выбор: 1
Число для добавления: 75
...
Выбор: 3
По возрастанию: 25 50 75

Выбор: 2
Число для поиска: 25
Найдено! Потребовалось сравнений: 2

Выбор: 4
Высота дерева: 2
```

## Notes

- **This tree is not self-balancing.** As the source material warns, inserting values in already-sorted order (e.g. `1, 2, 3, 4, 5, ...`) produces a completely degenerate tree — every node has only a right child, and it behaves exactly like a linked list (search cost proportional to the number of elements, not its logarithm). Try inserting numbers in increasing order and then searching for the last one to see the comparison count grow linearly instead of staying small.
- Insert values in a more "random" or already-balanced order (e.g. `50, 25, 75, 12, 37, 62, 87, ...`) to see the comparison count for `BSTSearch` stay low even as you add many more values — that's the practical payoff the source material is building toward.
- Duplicate values are silently dropped by `BSTInsert` (the `exit` in the middle of its loop) — inserting the same number twice has no visible effect on the tree.
- The source material mentions that fully-general balanced trees, tree rebalancing algorithms, and hash tables are more advanced topics; this demo only implements the basic (unbalanced) binary search tree operations it describes in detail, not the balancing algorithms it only mentions in passing.
