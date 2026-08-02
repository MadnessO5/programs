# LongDeque — a Doubly Linked Deque

A full implementation of the `LongDeque` stub from section 2.10.7 ("Двусвязные списки; деки"), plus an interactive menu-driven demo to exercise it. The book presents the type declarations and empty procedure bodies as an exercise for the reader ("Реализовать все эти процедуры и функции мы предложим читателю самостоятельно") — this file is that implementation.

## What a deque is

A deque ("double-ended queue") supports four operations: push/pop at the front, and push/pop at the back. Using only the front operations makes it behave like a stack; using push-front with pop-back (or push-back with pop-front) makes it behave like a queue — a deque is strictly more flexible than either.

## What it covers

- **`LongItem2`** — a doubly linked node: besides `data` and `next` (as in a singly linked list), it also has `prev`, pointing at the previous node. This is what lets the deque support operations at *both* ends efficiently.
- **`LongDeque`** — holds `first` and `last` pointers, same shape as the singly linked queue from `qol.pas`, but now built from doubly linked nodes.
- **`LongDequeInit`** — sets both `first` and `last` to `nil`, making the deque a valid empty one.
- **`LongDequePushFront` / `LongDequePushBack`** — insert a new node at the front or back respectively. Each handles the empty-deque case specially (when there's no existing `first`/`last` to link against, the new node becomes both `first` and `last`), following exactly the pattern spelled out in the source material for inserting at the head/tail of a doubly linked list.
- **`LongDequePopFront` / `LongDequePopBack`** — remove and return the value at the front or back. After removing the only remaining element, both `first` and `last` need to become `nil` again — handled here the same way `QOLGet` handled it for the singly linked queue, just now needing to fix up `prev` (or `next`) on the new front/back node when the deque *isn't* left empty.
- **`LongDequeIsEmpty`** — checks whether `first` is `nil`.
- **`LongDequePrint`** (an addition beyond the book's stub) — walks the deque from `first` to `last` via `next` pointers and prints its contents, front to back, for the demo to show what's currently in the deque.
- **`ReadInt`** — the same safe-integer-input helper used in earlier examples (parses via `val`, re-prompting instead of crashing on invalid input).

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc longdeque.pas
./longdeque
```

You'll get a small menu:

```
Текущая дека:
(дека пуста)
1 - PushFront   2 - PushBack
3 - PopFront    4 - PopBack
0 - выход
Выбор:
```

Enter `1`/`2` to push a number onto the front/back, `3`/`4` to pop from the front/back (only if the deque isn't empty), or `0` to quit.

## Sample session (abbreviated)

```
Выбор: 2
Число для PushBack: 10

Текущая дека:
front -> 10 <- back
...
Выбор: 2
Число для PushBack: 20

Текущая дека:
front -> 10, 20 <- back
...
Выбор: 1
Число для PushFront: 5

Текущая дека:
front -> 5, 10, 20 <- back
...
Выбор: 4
PopBack вернул: 20

Текущая дека:
front -> 5, 10 <- back
```

## Notes

- As the source material points out, none of `LongDeque`'s procedures check whether the deque is empty before popping — `LongDequePopFront`/`LongDequePopBack` will crash (dereferencing a `nil` pointer) if called on an empty deque. The convention here (matching the book's stated assumption) is that *callers* are responsible for checking `LongDequeIsEmpty` first — which is exactly what the demo's menu loop does before calling either pop procedure.
- Try using only options `1` and `3` (`PushFront`/`PopFront`) to see the deque behave like a stack (last pushed, first popped); try `2` and `3` (`PushBack`/`PopFront`) to see it behave like a queue (first pushed, first popped) — the source material specifically calls out both of these as special cases of full deque behavior.
- The program frees all remaining nodes with repeated `LongDequePopFront` calls right before exiting, so no memory is left allocated when you choose `0` to quit with items still in the deque.
