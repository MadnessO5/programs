# DynamicVarsDemo

An interactive program demonstrating dynamic variables, `new`/`dispose`, shared pointers, and memory leaks in Pascal, based on section 2.10.3 ("Динамические переменные").

## What it covers

- **The heap** — a special memory area separate from ordinary program variables, used specifically for dynamic variables. Unlike ordinary variables, a dynamic variable isn't written into the program's source code — it's created (and destroyed) while the program is running.
- **`new(p)`** — allocates a chunk of memory from the heap sized for whatever type `p` points to (here, `string`), and stores that memory's address in `p`. Before this call, `p` doesn't point to any usable memory; after it, `p^` becomes a real, usable variable.
- **`p^`** — the dynamic variable itself, accessed only through the pointer's dereference — a dynamic variable has no name of its own, unlike an ordinary variable.
- **A dynamic variable isn't tied to one specific pointer** — `q := p` copies the *address*, not the data; afterward, `p^` and `q^` refer to the exact same memory, so writing through one is visible through the other. This program demonstrates that directly: changing the string via `q^` also changes what `p^` reads.
- **`dispose(q)`** — returns the memory back to the heap so it can be reused by a future `new`. Crucially, this does **not** change the *value* of the pointer `q` itself — it just marks that memory as free. After `dispose`, using `q^` (or `p^`, since they held the same address) is no longer valid; both pointers are now "dangling" (pointing at memory that's no longer reserved for them).
- **Memory leaks** — calling `new(p)` a second time (without disposing of what `p` pointed to first) makes the heap allocate a brand-new block and overwrite `p` with its address. The *previous* dynamic variable is still sitting in the heap, but there is now no pointer anywhere that holds its address — it can never be read, and (just as importantly) never be `dispose`d either. This wasted, permanently-unreachable memory is exactly what a memory leak is.
- **No garbage collection in Pascal** — unlike some other languages, Pascal never automatically detects and reclaims leaked memory; the source material stresses that this makes careful, deliberate `dispose`-ing the programmer's responsibility.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc dynamic_vars_demo.pas
./dynamic_vars_demo
```

## Sample session (abbreviated)

```
Введите строку для новой динамической переменной: hello
p^ = hello

Выполнили q := p. Теперь q^ = hello - это та же самая область памяти, что и p^

Изменим значение через q^. Введите новую строку: world
Теперь p^ тоже изменился и равен: "world"
(p и q - разные переменные-указатели, но обе хранят один и тот же адрес)

Выполнили dispose(q) - память вернулась в кучу.
...

Демонстрация утечки памяти:
Выделили память под p, записали: "первая строка"
Выделили ещё раз под тот же указатель p, записали: "вторая строка"
Адрес первой динамической переменной был затёрт - теперь её невозможно
ни прочитать, ни освободить. Это и есть утечка памяти (мусор в куче).

Освободили последнюю выделенную переменную через dispose(p).
Первую освободить уже нельзя - адрес был потерян навсегда.
```

## Notes

- This program deliberately avoids actually dereferencing `p^`/`q^` *after* the `dispose(q)` call — doing so would be undefined behavior (accessing memory that's no longer reserved for this variable), so the demo only *describes* what would go wrong rather than triggering it, to keep the program's own behavior well-defined throughout.
- The "leaked" first string in the memory-leak demonstration is not actually lost in a way you could observe from outside the program (the operating system reclaims *all* of a program's memory, leaked or not, once the program exits) — the leak only matters *while the program keeps running*, since that memory stays unusable by the program itself for the rest of its execution.
- This example only uses pointers to a simple type (`string`). The source material notes that pointers become genuinely essential (rather than just a teaching example) when building *linked dynamic data structures* — records that contain pointers to other records of the same type — which is the natural next topic once `new`/`dispose` themselves feel comfortable.
