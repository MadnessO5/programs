# RandomStars

A full-screen Pascal program that gradually fills an initially empty screen with randomly colored, randomly positioned asterisks, using pseudo-random number generation from Free Pascal's standard library.

## What it covers

- **`randomize`** — seeds the pseudo-random number generator (fills the internal `randseed` variable) with an unpredictable value, typically based on the current system time. Must be called exactly once at the start of the program — calling it every time you need a random number would make numbers generated within the same second come out identical.
- **`random(n)`** — returns a random integer in the range `0..n-1`. Called here as `random(ScreenWidth)`, `random(ScreenHeight)`, and `random(ColorCount)` to pick a random column, row, and color index.
- **Side effects of `random`** — every call updates `randseed` internally so the next call returns a different number; this is the same kind of side effect discussed earlier for `ReadKey`.
- **`AllColors`** — the same array of all 16 `crt` color constants used in `colordemo.pas`, indexed here by a random number to pick the asterisk's color on each iteration.
- **Avoiding the bottom-right corner** — if `(x, y)` lands exactly on `(ScreenWidth, ScreenHeight)`, the loop skips that iteration with `continue`, since writing to the terminal's absolute last cell would force it to scroll (the same issue noted in `colordemo.pas`).
- **`while not keypressed do`** — the animation runs until any key is pressed (checked non-blockingly via `KeyPressed`, without needing the `GetKey` wrapper since no extended-key handling is required here).
- **`write(#27'[0m')`** — writes a raw ANSI escape sequence (`ESC [0m`) directly, which resets all text attributes (color, blink, etc.) to the terminal's default. This is a lower-level alternative to restoring `TextAttr` (as done in `colordemo.pas`) — sent as a literal escape code rather than through a `crt` procedure.
- **`delay(DelayDuration)`** — a short pause (`20` ms) between each star, controlling how quickly the screen fills up.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- Run in a real terminal.

## How to build and run

```bash
fpc randstars.pas
./randstars
```

Stars appear one at a time in random positions and random colors, gradually covering the screen. Press any key to stop and exit (the screen is cleared automatically).

## Notes

- Because positions are chosen fully at random rather than following a pattern, some screen cells may end up covered by multiple stars of different colors over time (overwriting the earlier one), while others may still be empty when you stop the program — this is expected for a uniform random distribution over a short run.
- `random(n)` (with an integer argument) always returns a `longint`; the parameter-less form `random` (no arguments) instead returns a `real` in `[0, 1)` — this program only uses the integer form.
- Lowering `DelayDuration` makes stars appear faster; raising it slows the animation down.
