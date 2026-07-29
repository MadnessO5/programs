# Singly Linked List Demos

Two Pascal programs demonstrating singly linked lists, based on section 2.10.4 ("Односвязные списки") and its two suggested exercises.

## Files

- **`numbers1.pas`** — a transcription of the book's example: reads integers from standard input until end-of-file, building a linked list by inserting each new number at the **head** of the list, then prints the whole list — which comes out in **reverse** order of input, since each new number ends up in front of everything read before it.
- **`numbers2.pas`** — a solution to the book's second exercise: reads integers the same way, but appends each one to the **tail** of the list (keeping both a `first` and a `last` pointer), so the list preserves the original input order; then prints the entire list **twice**, and finally frees every node properly with `dispose`.

## What they cover

- **The forward-pointer-type trick** — Pascal won't let you write `next: ^item` directly inside the declaration of `item` itself (the name `item` doesn't exist yet at that point). The workaround: declare a separate pointer type name first (`itemptr = ^item`), which Pascal *does* allow even though `item` isn't defined yet, then declare `item` itself using `itemptr` for its `next` field.
- **A node (`item`)** — a record with two fields: `data` (the payload — here, an integer) and `next` (a pointer to the next node, or `nil` if this is the last one).
- **Building the list is a three-step dance** (spelled out in detail in the source material): create a new node with `new`, fill in its fields, then hook it into the list by adjusting the appropriate pointer.
- **Insert-at-head (`numbers1.pas`)**: `tmp^.next := first; first := tmp` — the new node points at whatever used to be first, then becomes first itself. Reverses the input order as a side effect, since the most recently read number always ends up at the front.
- **Append-at-tail (`numbers2.pas`)**: requires tracking *two* pointers, `first` (the list's start) and `last` (its end), because extending the list means writing into `last^.next`. The empty-list case is genuinely special here (unlike insert-at-head, where the empty and non-empty cases turn out identical) — there is no `last^` to extend when the list doesn't have a last element yet, so the very first insertion has to create `first` directly instead.
- **`first := nil` before anything else** — absolutely essential in both programs: this is what makes an empty list a *valid*, well-defined list (rather than an uninitialized pointer pointing at garbage), and both the head-insertion and tail-appending logic depend on being able to check `first = nil`/`tmp <> nil` reliably.
- **Traversing the list** — `tmp := first; while tmp <> nil do begin ... ; tmp := tmp^.next end` is the standard "walk to the end" pattern, used here both for printing and (in `numbers2.pas`) for freeing memory.
- **Freeing a list safely** — you cannot `dispose(first)` and *then* read `first^.next`, because by then the memory has already been returned to the heap. The correct order is: save `first^.next` into a temporary variable *first*, only *then* `dispose(first)`, and finally move `first` to point at the saved next node. `numbers2.pas` uses exactly this pattern to release every node once it's done with them.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

Both programs read integers from standard input until end-of-file, so you'll typically redirect a file or pipe values in:

```bash
fpc numbers1.pas
echo "10 20 30" | ./numbers1
```
```
30
20
10
```
(reversed, since each new number is inserted at the front)

```bash
fpc numbers2.pas
echo "10 20 30" | ./numbers2
```
```
10
20
30
10
20
30
```
(original order, printed twice)

## Notes

- Both programs use `SeekEof` (with no file argument, meaning "the standard input stream") to detect when there's no more data to read — the same technique discussed back in §2.5.4 and reused throughout the file-handling examples.
- `numbers1.pas` deliberately does **not** call `dispose` anywhere — as the source material points out, this is fine here specifically because the program ends immediately after printing the list, so the operating system reclaims all of the program's memory (leaked or not) the moment it exits. This is *not* a general excuse to skip `dispose`; it only holds for a short-lived, one-shot program like this one.
- `numbers2.pas` does clean up properly with `dispose`, both to demonstrate the correct technique and as good practice for any program that might build and discard multiple lists over its lifetime (where skipping `dispose` really would leak memory).
