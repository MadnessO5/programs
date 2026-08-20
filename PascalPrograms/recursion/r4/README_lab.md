# RecursiveListLab

An interactive menu-driven "lab" for experimenting with recursive linked-list operations on your own terms — add items whenever you like, then freely try any recursive operation, in any order, as many times as you want. Based on section 2.11.4 ("Рекурсия при работе со списками"), extended with a couple of bonus operations in the same style.

## Menu

```
1 - Добавить число (рекурсивная вставка в отсортированный список)
2 - Показать список
3 - Сумма элементов (рекурсивно)
4 - Количество элементов (рекурсивно)
5 - Максимум в списке (рекурсивно)
6 - Очистить список (рекурсивное освобождение памяти)
0 - Выход
```

Unlike the earlier `recursive_list.pas` (which just ran through a fixed script once), this version keeps the list alive across menu choices, so you can add a few numbers, check the sum, add more, check it again, print the list, clear it, start over — in whatever order you want, as many times as you want, without recompiling or restarting.

## What it covers — straight from the source material

- **`AddNumIntoSortedList(var p, n)`** — recursive sorted insertion (menu option 1). Empty list or "first element is bigger" is the base case (insert here); otherwise, recurse into `p^.next`.
- **`ItemListSum(p): integer`** — recursive sum (option 3). Empty list sums to `0`; otherwise, first element plus the sum of the rest.
- **`DisposeItemList(p)`** — recursive memory release (option 6, wrapped so it also resets `first` to `nil` afterward, since `DisposeItemList` itself only takes `p` by value and can't reset the caller's variable). Frees the rest of the list *before* the current node, since the current node holds the only pointer to that rest.

## Bonus additions (same recursive style, not from the book)

- **`ItemListCount(p): integer`** (option 4) — empty list has `0` elements; otherwise, `1 +` the count of the rest. About as direct a translation of "how many things are in this list" into recursive terms as you can get.
- **`ItemListMax(p, hasValue, current): integer`** (option 5) — a slightly more advanced pattern: an *accumulator*-based recursive function. Instead of computing a value purely from the recursive call's result (like `ItemListSum` does), it carries a running "best answer so far" (`current`) and a flag (`hasValue`) indicating whether that running answer is real yet (needed so an all-negative list doesn't get compared against a bogus starting value like `0` and wrongly "lose" to it). Each step decides whether the current node beats the running maximum, then passes the (possibly updated) accumulator into the recursive call on the rest of the list. This same accumulator pattern generalizes to lots of other "reduce a list to one summary value" problems (minimum, product, concatenation, etc.).

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc recursive_list_lab.pas
./recursive_list_lab
```

## Sample session (abbreviated)

```
Выбор: 1
Число для добавления: 30

Выбор: 1
Число для добавления: 10

Выбор: 1
Число для добавления: 20

Выбор: 2
Список: 10, 20, 30

Выбор: 3
Сумма: 60

Выбор: 4
Количество элементов: 3

Выбор: 5
Максимум: 30

Выбор: 6
Список очищен, память освобождена

Выбор: 2
Список: (список пуст)
```

## Notes

- Try clearing the list (option 6) and then immediately checking the sum, count, or max (options 3–5) — all of them correctly report `0`/empty results on an empty list, since `nil` is exactly the base case every one of these recursive functions is built around.
- As with the earlier `recursive_list.pas`, recursion depth here is bounded by how many items you've added — for an interactively-built list (realistically dozens or hundreds of entries, not millions), this is nowhere near a concern for the call stack.
- On exit (`0`), the program disposes of whatever's left in the list one last time, so no memory is left allocated when the program ends, regardless of whether you remembered to clear it yourself first.
