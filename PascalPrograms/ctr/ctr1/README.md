# HelloCrt

An interactive full-screen console program demonstrating the `crt` unit's positioning tools: `clrscr`, `GotoXY`, `ScreenWidth`/`ScreenHeight`, `WhereX`/`WhereY`, and `delay`.

## What it covers

- **`uses crt;`** — the `crt` unit must be imported to access these procedures/functions/variables; unlike the string built-ins covered earlier, these are not available by default.
- **`clrscr`** — clears the screen and moves the cursor to the top-left corner, coordinates `(1, 1)`.
- **`GotoXY(x, y)`** — moves the cursor to an arbitrary screen position; `(1, 1)` is the top-left corner (not `(0, 0)`).
- **`ScreenWidth` / `ScreenHeight`** — global variables holding the terminal's current width/height in characters, filled in by the `crt` unit at startup.
- **`WhereX` / `WhereY`** — functions (no parameters) returning the cursor's *current* column/row — useful for finding out where output actually landed, e.g. right after a `write` call.
- **`delay(ms)`** — pauses execution for the given number of milliseconds (`5000` = 5 seconds here).
- Centering math: horizontal position is `(ScreenWidth - length(Message)) div 2`, vertical position is `ScreenHeight div 2` — using integer division (`div`), since screen coordinates must be whole numbers.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit available (standard on Linux/Windows/macOS Free Pascal installations).
- Run in an actual terminal window — `clrscr`/`GotoXY` need a real terminal to have a visible effect.

## How to build and run

```bash
fpc hellocrt.pas
./hellocrt
```

## What happens when you run it

1. The program asks for a message (before doing anything visual, since input still happens normally at that point).
2. It clears the screen and prints your message centered on it.
3. It prints one line of status information at the very bottom row of the screen: the detected `ScreenWidth`/`ScreenHeight`, the coordinates where your message started, and the coordinates `WhereX`/`WhereY` reported right after writing it (which should equal the start position plus the message's length, for the X coordinate).
4. It waits 5 seconds (`delay(DelayDuration)`).
5. It clears the screen again and exits.

## Notes

- If you resize your terminal window *while the program is running*, `ScreenWidth`/`ScreenHeight` will **not** update — the `crt` unit reads the terminal size once at startup, a limitation baked into how it was originally designed (back when terminal/screen sizes genuinely couldn't change during a session).
- Trying to `GotoXY` to a position outside the actual terminal window doesn't produce an error — the cursor may end up somewhere unexpected, since the request is silently accepted regardless of whether that position really exists on screen.
- `WhereX`/`WhereY` only make sense in combination with output done through the `crt`-aware output mechanism (i.e. ordinary `write`/`writeln` after `uses crt`) — they report where the cursor is *right now*, not where you last used `GotoXY`.
