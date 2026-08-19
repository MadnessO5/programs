# MatchPattern

A recursive glob-style pattern matcher (`*` and `?` wildcards), based on section 2.11.3 ("Сопоставление с образцом").

## What it does

```bash
./match_pt <string> <pattern>
```

Checks whether `<string>` matches `<pattern>` **in its entirety**, where in the pattern:
- `?` matches exactly one arbitrary character,
- `*` matches an arbitrary substring (including an empty one),
- any other character matches only itself.

Prints `yes` or `no`.

## What it covers

- **`MatchIdx(var str, pat: string; idxs, idxp: integer): boolean`** — the real recursive engine. Instead of slicing the strings down with `copy` at every step (which would mean constantly allocating new, shorter strings), it keeps the *original* strings untouched and instead tracks two index variables, `idxs`/`idxp`, marking "how far into `str`/`pat` we've already successfully matched." The "remaining part of the string" is simply everything from that index onward.
- **`var` parameters for the strings** — `string` values are relatively large (256 bytes for the source material's `string` — see the earlier discussion in `string_type_demo.pas`), and this function calls itself recursively, potentially many times per top-level call. Passing `str`/`pat` as `var`-parameters avoids copying them on every one of those recursive calls, exactly per the size/performance discussion the source material references from §2.6.7 (passing large values, "user_types_params_demo.pas" in this collection covers the same idea).
- **Base case — pattern exhausted**: if `idxp` has moved past the end of `pat`, the match succeeds exactly when `str` has *also* been fully consumed (`idxs > length(str)`) — an empty pattern can only match an empty remaining string.
- **The `*` case**: tries matching the rest of the pattern (`idxp + 1`) against every possible "how much of the remaining string does `*` swallow" — from `0` characters up to the entire rest of `str` — via a `for` loop making one recursive call per candidate length. As soon as any candidate succeeds, the function returns `true` immediately (short-circuiting the rest of the loop via `exit`); if none work, it returns `false`.
- **The ordinary-character/`?` case**: fails immediately if `str` has already run out, or if the current pattern character isn't `?` and doesn't match the current string character exactly. Otherwise, both indices advance by one and the (implicit, via the enclosing `while true`) loop continues — this is written as a loop rather than a tail-recursive call specifically to avoid piling up a new stack frame for every single matched character.
- **`Match(str, pat: string): boolean`** — the public entry point, taking the strings as ordinary **value** parameters (not `var`) deliberately: since `Match` is only ever called once per top-level match attempt (no recursion at this level), the copying cost doesn't matter, and using value parameters means `Match` can be called with string literals or `ParamStr(...)` results directly — something a `var`-parameter could **not** accept, since a `var`-parameter requires an actual variable to bind to, not an arbitrary expression.
- **The value/`var` split as a deliberate design choice**: `Match` makes its own private copies of both strings once, then hands those copies into `MatchIdx`, which is free to use `var`-parameters from that point on because it's only ever called with `Match`'s own local variables (real variables, not arbitrary expressions) as arguments.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc match_pt.pas
./match_pt 'abc' 'a?c'
```
```
yes
```

```bash
./match_pt 'abc' 'a??c'
```
```
no
```

```bash
./match_pt 'abc' '***a***c***'
```
```
yes
```

## Notes

- **Always quote `*` and `?` on the command line** (single quotes, as in the examples above). Without quoting, the shell itself tries to expand `*`/`?` as filename wildcards *before* your program ever sees them (see the source material's own §1.2.7 reference) — quoting prevents that, and the quote characters themselves are stripped by the shell before `ParamStr` ever sees the arguments, so they won't show up as part of the string.
- This matcher checks for a match of the **entire** string against the **entire** pattern — there's no concept of "search within" the way `filegrep.pas`'s substring search works; `Match('xabc', 'abc')` would be `no`, since the pattern doesn't account for the leading `x`.
- The `*` case's recursive fan-out (trying every possible length) is what makes this algorithm potentially slow on pathological inputs (many `*`s against a long string with no early matches) — each `*` can trigger up to `length(str) + 1` recursive attempts, and those attempts can themselves contain further `*`s. For the string lengths a command-line tool like this realistically deals with, this is a non-issue in practice.
