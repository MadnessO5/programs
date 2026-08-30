# ExprEval

A recursive-descent arithmetic expression evaluator (`+`, `-`, `*`, `/`, parentheses, standard precedence) — and a hands-on exercise for section 2.13.4 ("Отладчик gdb"). This program has a real bug in it. The point of this file isn't just to show you the bug's location; it's to walk through finding it with `gdb`, the way you actually would with unfamiliar code.

## Building with debug info

```bash
fpc -g expreval.pas
```

The `-g` flag is essential — without it, `gdb` has no idea what your variables or source lines are called (see the source material's explanation of why debug info is opt-in).

## First: run the tests

```bash
chmod +x expreval_test.sh
./expreval_test.sh
```

Two tests fail:

```
TEST FAILED: "2 * 3 * 4" expected 24, got 6
TEST FAILED: "6 / 2 / 3" expected 1, got 3
```

Notice both failing cases have **spaces around the operators**, and both involve **two or more chained `*`/`/` operators**. `"2*3*4"` (no spaces) passes. That pattern is your first real clue — but let's confirm it properly with `gdb` instead of just guessing from the symptom.

## A guided gdb session

Start the debugger on the failing case:

```bash
gdb --args ./expreval "2 * 3 * 4"
```

Set a breakpoint on the function most likely responsible — multiplication happens in `ParseTerm`:

```
(gdb) break PARSETERM
(gdb) run
```

(Remember: Pascal identifiers become **upper case** in the debug info, per the source material's note — `break ParseTerm` won't be recognized, `break PARSETERM` will.)

The program stops as soon as `ParseTerm` is entered. Step through it one line at a time with `next` (repeat by just pressing Enter):

```
(gdb) next
(gdb) next
...
```

Watch the value of `pos` and the character at that position after each `next`. A convenient way to check both at once:

```
(gdb) inspect pos
(gdb) inspect expr[pos]
```

Keep pressing `next` through the first loop iteration (the first `*`). You'll see `value` become `6` (correct so far — `2 * 3`). Now watch very closely as execution reaches the closing `end` of the `while` loop's body, right before it loops back to re-check the condition. Compare this program's actual behavior against what you'd expect: right after applying an operator, shouldn't there be a call to `SkipSpaces` before the loop condition is checked again, exactly like `ParseExpr`'s version of this same loop has? Use `list` to look at the surrounding source and compare `ParseTerm`'s loop body to `ParseExpr`'s loop body side by side.

Once you suspect where the missing call should be, confirm it with `bt`:

```
(gdb) bt
```

You'll see something like:

```
#0  PARSETERM (...) at expreval.pas:52
#1  0x08048... in PARSEEXPR (...) at expreval.pas:78
#2  0x08048... in main () at expreval.pas:91
```

— directly mirroring the source material's own `hanoi2.pas` example (`MoveLarger` called from `Solve` called from `main`), just with `ParseTerm`/`ParseExpr`/`main` instead.

## What you should find

`ParseTerm`'s multiplication/division loop never calls `SkipSpaces` after applying an operator, before checking whether another `*`/`/` follows — unlike `ParseExpr`'s addition/subtraction loop, which does call `SkipSpaces` at the end of its loop body. So if there's a space between the result of one multiplication and the next `*`, the loop's condition check sees a space (not `*` or `/`) and exits early, silently dropping the rest of the expression.

## Requirements

- Free Pascal (`fpc`) with `gdb` installed.
- `zsh` for the test script.

## Notes

- This bug is a great demonstration of why `-g` and a debugger earn their keep over debug-printing alone for this *kind* of bug: the failure depends on the exact character at a specific position in a specific recursive call, several frames deep — reproducing that clearly with `writeln` calls would mean either scattering prints everywhere in advance or guessing right about where to add one, whereas `gdb` lets you stop exactly where the confusion is and look around freely, after the fact.
- This program also includes `{$IFDEF DEBUG}`-guarded debug printing (`fpc -dDEBUG expreval.pas`), showing `pos` and the accumulated `value` at each step — try it too, and compare how quickly each approach (print statements vs. stepping in `gdb`) gets you to the same conclusion.
- Once you've found and fixed the bug (adding the missing `SkipSpaces` call), re-run `expreval_test.sh` — all nine tests should pass.
- A corrected version is also provided as `expreval_fixed.pas`, with a matching `expreval_fixed_test.sh` (all cases pass, no known-failing tests) — use it to check your own fix against, or just to see the one-line difference (`SkipSpaces;` added at the end of `ParseTerm`'s loop body).
