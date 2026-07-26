# PointersDemo

An interactive program demonstrating typed pointers, the address-of operator, and the dereference operator in Pascal, based on section 2.10 ("Адреса, указатели и динамическая память").

## What it covers

- **Typed pointers** — `p: ^integer` and `pr: ^real` are variables that hold an *address*, and additionally carry the compile-time guarantee that whatever they point to is a variable of that specific type (`integer`, `real`, etc.).
- **`@` — the address-of operator** — `p := @a` stores the address of variable `a` in `p`. Afterward, "`p` points to `a`" and "`p` contains the address of `a`" mean exactly the same thing.
- **`^` — the dereference operator** — written *after* a pointer, `p^` means "the variable that `p` points to". Reading `p^` reads that variable's value; assigning to `p^` (e.g. `readln(p^)`) writes to that variable directly, which is why changing `p^` in this demo also changes `a` — they're the same memory, just accessed through two different names.
- **Taking the address of *any* variable, not just named ones** — `@arr[3]` and `@pt.x` show that `@` works on array elements and record fields too, not only on variables declared with a plain identifier.
- **`nil`** — the built-in constant meaning "this pointer currently points nowhere" (technically, an address guaranteed not to belong to any real variable). Assigning `p := nil` and then checking `if p = nil` is the standard way to represent "no target" for a pointer.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc pointers_demo.pas
./pointers_demo
```

The program will:

1. Ask for an integer, store its address in `p`, and show that `p^` reads the same value as `a` directly.
2. Ask for a new number via `readln(p^)` — writing through the pointer — and show that `a` changed too, since `p^` and `a` are the same memory.
3. Repeat a similar demonstration with a `real` variable and its pointer.
4. Take the address of an array element (`@arr[3]`) and a record field (`@pt.x`), showing `@` isn't limited to simply-named variables.
5. Set `p := nil` and confirm the comparison `p = nil` works as expected.

## Sample session (abbreviated)

```
Введите целое число (для a): 10
p указывает на a. p^ = 10
a напрямую = 10
Изменим значение через p^. Введите новое число: 42
Теперь a = 42 (изменилось само по себе, ведь p указывает именно на a)

Введите вещественное число (для r): 3.14
pr^ = 3.140

Введите значение для третьего элемента массива arr: 7
Адрес взят у элемента массива: pa^ = 7

Введите значение для поля x записи pt: 5
Адрес взят у поля записи: pp^ = 5

Теперь p ни на что не указывает (p = nil)
```

## Notes

- This demo only uses typed pointers pointing at *existing* variables (`a`, `r`, `arr[3]`, `pt.x`) — it doesn't cover dynamically allocated memory (`new`/`dispose`), which is the next natural step once pointers themselves make sense and is what the "динамическая память" part of this chapter's title refers to.
- The untyped `pointer` type mentioned in the source material (which can hold an address of *any* type, with no compile-time type checking) is intentionally not used here — the material itself recommends avoiding it until genuinely necessary, since mixing up what type of data actually lives at such an address is a common source of hard-to-find bugs.
- `@` by default produces an untyped address in standard Free Pascal mode; the `{$T+}` directive (mentioned in the source material) changes this so `@` produces a properly typed pointer instead. This program relies on Free Pascal's usual behavior and doesn't need `{$T+}` explicitly, since assigning `@a` directly to a compatibly-typed pointer variable works either way.
