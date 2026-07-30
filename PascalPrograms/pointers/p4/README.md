# Stack and Queue on a Singly Linked List

Two small Pascal programs implementing the two classic abstract data types on top of a singly linked list: a stack (`sol.pas`, "Stack Of Longints") and a queue (`qol.pas`, "Queue Of Longints"). Both read integers from standard input until end-of-file, then drain the structure and print everything back out — the difference in output order is exactly what makes a stack and a queue different.

## Files

- **`sol.pas`** — a stack (LIFO — last in, first out), represented as a single pointer to the top node.
- **`qol.pas`** — a queue (FIFO — first in, first out), represented as a record holding two pointers: to the first and last nodes.

## What they cover

### Stack (`sol.pas`)

- **`StackOfLongints = LongItemPtr`** — the whole stack is just a pointer to its top element; an empty stack is simply `nil`.
- **`SOLInit`** — sets the stack to `nil`, making it a valid empty stack (the same "don't skip this" step emphasized for lists in general).
- **`SOLPush`** — inserts a new node at the head: create it, fill in `data`, point its `next` at the current top, then make it the new top. This is the same insert-at-head pattern from `numbers1.pas`.
- **`SOLPop`** — reads the top node's value first, *then* unlinks and `dispose`s it — reading before freeing is essential, since reading from freed memory would be invalid.
- **`SOLIsEmpty`** — just checks whether the stack pointer is `nil`.
- **Why the output is reversed** — since every `SOLPush` puts its number at the front, the *last* number read ends up on top and is the *first* one popped — the defining behavior of a stack.

### Queue (`qol.pas`)

- **`QueueOfLongints = record first, last: LongItemPtr end`** — a queue needs *two* pointers (unlike a stack), because new elements are appended at the tail while removal happens at the head.
- **`QOLInit`** — sets both `first` and `last` to `nil`.
- **`QOLPut`** — appends at the tail, with the empty-queue case handled separately from the general case (there's no `last^` to extend yet when the queue has nothing in it) — the same append-at-tail pattern from `numbers2.pas`.
- **`QOLGet`** — reads `first^.data`, unlinks the first node, advances `first` to the next node, `dispose`s the old first node — and additionally resets `last` to `nil` if the queue has just become empty. This last check matters: without it, after removing the only remaining element, `last` would still point at the now-`dispose`d node, leaving the queue in a broken, inconsistent state.
- **`QOLIsEmpty`** — checks whether `first` is `nil`.
- **Why the output preserves input order** — numbers leave the queue in the same order they entered it, the defining behavior of a queue.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc sol.pas
echo "10 20 30" | ./sol
```
```
30
20
10
```

```bash
fpc qol.pas
echo "10 20 30" | ./qol
```
```
10
20
30
```

Feeding the exact same input to both programs side by side is a good way to see the stack/queue distinction directly — reversed vs. preserved order.

## Notes

- Both `SOLIsEmpty` and `QOLIsEmpty` take their parameter as `var stack`/`var queue` even though they only read from it and never modify it — passing by `var` here avoids copying the (potentially large, for `QueueOfLongints`) structure on every call, at the cost of technically allowing the function to modify its argument even though it doesn't. Using `const` instead of `var` would express the same "read-only, don't copy" intent while also preventing accidental modification — a reasonable refinement to consider.
- Neither program handles calling `SOLPop`/`QOLGet` on an already-empty stack/queue — doing so would dereference a `nil` pointer (`stack^.data` or `queue.first^.data` when the value is `nil`), which is a runtime error. Both main programs avoid this by only ever popping/getting as many times as `SOLIsEmpty`/`QOLIsEmpty` say is safe, but the procedures themselves don't guard against misuse if called directly with an empty structure.
- Since both structures are built from `LongItemPtr`/`LongItem` (holding a `longint`), they only work for one specific data type; making a truly generic (works-for-any-type) stack or queue in classic Pascal would require either duplicating this code per type or moving to a language feature Pascal doesn't have out of the box (generics), which is outside the scope of this chapter.
