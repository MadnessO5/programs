# Pointer-to-Pointer List Techniques

Two Pascal programs demonstrating the "pointer to a pointer" technique for singly linked lists, based on sections 2.10.6 and 2.10.7 (removing elements and inserting into a sorted list).

## Files

- **`removeneg.pas`** — builds a linked list from integers read on standard input, then removes every negative number from it, using a single unified loop (no special-casing the first element).
- **`sortedinsert.pas`** — interactively reads a chosen number of integers and inserts each one directly into its correct position in an always-sorted list, again using the same technique, then prints the final sorted list.

## The core idea: a pointer to a pointer

Both programs use:

```pascal
var
    pp: ^itemptr;
```

`pp` doesn't point at a *node* — it points at **wherever an `itemptr` value currently lives**, which could be:
- the variable `first` itself (`pp := @first`), or
- the `next` field of some node further into the list (`pp := @(tmp^.next)`).

This is exactly the trick the source material introduces to avoid treating "the first element" as a special case. Removing or inserting *before* the first element normally requires different code than removing/inserting elsewhere (since there's no "previous node" to redirect for the very first element) — but by working with the *address of the pointer that currently points at the element in question* (whether that pointer is `first` or some node's `next` field), both cases become identical code.

## `removeneg.pas` — deletion, unified

```pascal
pp := @first;
while pp^ <> nil do
begin
    if pp^^.data < 0 then
    begin
        tmp := pp^;
        pp^ := pp^^.next;
        dispose(tmp)
    end
    else
        pp := @(pp^^.next)
end;
```

- **`pp^`** — the pointer that `pp` points at (initially `first`, later some node's `next` field) — in other words, "the address of the current node".
- **`pp^^`** — dereferencing that once more gets you the current node itself, so `pp^^.data` is its payload.
- **Deleting**: `pp^ := pp^^.next` redirects whatever pointer `pp` points at (be it `first` or a `next` field) to skip over the current node — after which the node can be safely `dispose`d, since nothing points at it anymore. Crucially, `pp` itself does **not** need to move forward in this branch: the *next* node has now slid into the position `pp^` points at, so re-checking `pp^` on the next loop iteration naturally examines that next node.
- **Keeping**: `pp := @(pp^^.next)` — move `pp` to point at the current node's `next` field, so the next iteration examines the following node.
- **Loop condition (`pp^ <> nil`)** — stops when the pointer `pp` points at is `nil`, correctly covering both "the list is empty" (`first` itself is `nil`) and "we've reached the end of the list" (some node's `next` is `nil`) with the same check.

## `sortedinsert.pas` — insertion, unified

```pascal
pp := @first;
while (pp^ <> nil) and (pp^^.data < n) do
    pp := @(pp^^.next);

new(tmp);
tmp^.next := pp^;
tmp^.data := n;
pp^ := tmp
```

- The `while` loop advances `pp` past every node whose value is smaller than `n`, stopping as soon as it finds the right spot (or reaches the end of the list).
- **Short-circuit evaluation matters here**: Free Pascal evaluates `and`/`or` lazily by default, so `pp^^.data < n` is never evaluated when `pp^ = nil` — avoiding a crash from dereferencing a `nil` pointer. (Free Pascal *can* be told to always evaluate both sides via `{$B+}`, in which case this exact loop would need rewriting — the default lazy behavior, `{$B-}`, is what makes the concise version above safe.)
- **Insertion**: the new node's `next` is set to whatever `pp` currently points at (`pp^` — the node that should come *after* the new one, or `nil` if inserting at the end), and then `pp^` itself is redirected to the new node. This inserts the new node exactly where it belongs — at the very front, in the middle, or at the very end — without any special-casing.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc removeneg.pas
echo "5 -3 10 -7 2" | ./removeneg
```
```
2
10
5
```
The list is built via head-insertion (like `numbers1.pas`), so right after reading it's `2, -7, 10, -3, 5` (reverse input order). After removing the two negative numbers (`-7` and `-3`), what's left — `2, 10, 5` — is printed in that same (already-reversed) order.

```bash
fpc sortedinsert.pas
./sortedinsert
```
```
Сколько чисел ввести? 4
Число №1: 30
Число №2: 10
Число №3: 20
Число №4: 5

Список по возрастанию:
5
10
20
30
```

## Notes

- Both programs properly free their list's memory with `dispose` before exiting (following the pattern from `numbers2.pas`), even though — as noted for `numbers1.pas` — it wouldn't strictly matter for such short-lived programs.
- This pointer-to-pointer technique generalizes well beyond these two examples: any operation that needs to "act on the pointer that currently references a node, regardless of whether that pointer is `first` or some other node's `next` field" can be unified the same way.
- The source material's next topic after this technique is the **doubly linked list** (each node also has a pointer back to its predecessor, avoiding the need for this pointer-to-pointer trick when moving backward through the list) — not implemented here, since it's a distinct data structure with its own trade-offs rather than a refinement of this technique.
