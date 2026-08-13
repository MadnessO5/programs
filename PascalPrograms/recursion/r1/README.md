# MutualRecursionDemo

A minimal Pascal program demonstrating mutual recursion and the `forward` declaration, based on section 2.11.1 ("Взаимная рекурсия").

## What it covers

- **Mutual recursion** — two subprograms that call each other: `IsEven(n)` calls `IsOdd(n - 1)`, and `IsOdd(n)` calls `IsEven(n - 1)`. Each keeps peeling one off `n` and handing off to the other, until reaching `0` (which is even by definition), at which point the chain of calls unwinds back through both functions.
- **The ordering problem `forward` solves** — Pascal compiles top to bottom, and by the time it reaches `IsEven`'s body (which calls `IsOdd`), `IsOdd` hasn't been described yet — so without some way to tell the compiler "trust me, `IsOdd` is coming later, here's its signature," calling it would be a compile error. Exactly one of the two functions has to be described first in the file, and it needs to call the other one before that other one has technically been declared.
- **`forward`** — a declaration containing only a subprogram's header (name, parameters, and — for a function — its return type) followed by the keyword `forward` and a semicolon, with no body at all:
  ```pascal
  function IsOdd(n: integer): boolean; forward;
  ```
  This gives the compiler everything it needs to check and compile a *call* to `IsOdd` (its parameter types and return type), without yet needing the actual implementation.
- **The required order**: (1) the `forward` declaration of the first function, (2) the full body of the second function (which can now freely call the first, since its `forward` declaration already told the compiler about it), (3) the full body of the first function (which can now call the second, since the second is now fully described). Both real function bodies end up able to see and call each other correctly.
- **A `forward`-declared subprogram must eventually be fully described later in the same file** — leaving out the real implementation entirely, after promising it with `forward`, is a compile-time error.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc mutual_recursion.pas
./mutual_recursion
```

## Sample session

```
Введите неотрицательное целое число: 7
7 - нечётное
```

```
Введите неотрицательное целое число: 4
4 - чётное
```

## Notes

- This `IsEven`/`IsOdd` pair is a classic (if deliberately impractical) teaching example for mutual recursion — checking whether a number is even or odd obviously doesn't *need* recursion at all (`n mod 2 = 0` does the job in one step); the point here is to illustrate the `forward` mechanism itself with the simplest possible pair of functions, not to suggest this is how you'd actually check parity in real code.
- The source material's own example signatures (`TraverseTree`, `CountValues`) hint at where this technique becomes genuinely useful: operations on trees (like the `BSTDemo` example from the previous section) very often naturally split into mutually recursive pieces once you go beyond the simplest cases — a topic the source material says it will return to later.
- Negative input is explicitly rejected here (`if n < 0 then ...`) rather than being passed into the recursion, since both functions only know how to count down toward `0` and would recurse forever (well, until running out of stack space and crashing) on a negative starting value.
