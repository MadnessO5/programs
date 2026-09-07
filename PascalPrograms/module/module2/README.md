# Contact Book

**A modular address book, built entirely from this book's own rules.**

A genuinely useful console contact manager, split across proper units following every architectural rule covered so far: modules, prefixed identifiers, one-way call/data coupling, recursion, files, and testing/debug conventions.

## Architecture

### `contactunit.pp`
The base subsystem.
* **Exports:** `ContactRecord` (a sorted-by-name binary search tree of contacts).
* **Functions:** `ContactAdd`, `ContactFind`, `ContactRemove`.
* **Traversal & Persistence:** `ContactPrintAll` (recursive in-order traversal), `ContactSave`, `ContactLoad`.
* **Coupling:** Depends on nothing else.
* **Prefix:** `Contact`

---

### `searchunit.pp`
Wildcard name search (`*`/`?`) reusing recursive pattern-matching technique.
* **Details:** Interface only needs a `string` and a `ContactRecord` pointer type name.
* **Coupling:** Genuine **data coupling** to `ContactUnit` (unavoidable: search has to walk a `ContactRecord` tree), so `uses ContactUnit` sits in `SearchUnit`'s own `interface`.
* **Prefix:** `Search`

---

### `statsunit.pp`
Counts contacts and computes tree height.
* **Details:** Interface only exposes `longint`/`integer`.
* **Coupling:** **Call coupling only**, so `uses ContactUnit` is tucked into `implementation`, not `interface`.
* **Prefix:** `Stats`

---

### `contactbook.pas`
The menu-driven main program, tying the three together.
