# MovingHello

A full-screen Pascal program that shows a message on screen and lets you move it around with the arrow keys, using `crt` and the extended-key handling from `GetKey` (see the earlier `getkey.pas` example).

## What it covers

- **`GetKey(var code: integer)`** — reads one keypress and returns its code: a positive `ord` value for an ordinary key, or a negative value (`-ord(c)`) for the second byte of an extended/special key sequence (like an arrow key).
- **`ShowMessage(x, y, msg)`** — moves the cursor to `(x, y)` and writes `msg`, then returns the cursor to `(1, 1)` so the next `GetKey` call doesn't visually disturb the screen.
- **`HideMessage(x, y, msg)`** — "erases" a previously shown message by overwriting its exact position with spaces (`length(msg)` of them), since there's no direct way to erase text other than overwriting it.
- **`MoveMessage(var x, y, msg, dx, dy)`** — hides the message at its current position, updates the coordinates by `(dx, dy)`, wraps it around to the opposite edge if it goes off-screen, and shows it again at the new position. This hide/update/wrap/show sequence is what makes the message appear to move and loop around the screen rather than leave a trail or disappear off the edge.
- **Screen wraparound** — unlike a naive version that just adds `dx`/`dy` with no bounds checking, this one accounts for the message's full width: if the message's right edge (`x + length(msg) - 1`) goes past `ScreenWidth`, it reappears flush against the left edge (`x := 1`); if its left edge (`x`) goes below `1`, it reappears flush against the right edge, positioned so the *entire* message fits (`x := ScreenWidth - length(msg) + 1`). Vertically, going past `ScreenHeight` wraps to row `1`, and going below row `1` wraps to `ScreenHeight` — the same idea used for the single-character star in `movingstar.pas`, just adjusted for a multi-character string.
- **Arrow key codes** — on a typical PC keyboard/terminal setup, arrow keys generate a two-byte sequence starting with `#0`; the second byte's codes are `72` (up), `75` (left), `77` (right), `80` (down). Since `GetKey` negates these, the `case` statement matches `-72`, `-75`, `-77`, `-80`.
- **Exit condition** — any ordinary (non-extended, positive-code) keypress breaks out of the `while true do` loop and ends the program.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- Run in a real terminal (not through redirected/piped input) — arrow keys need genuine terminal input to be read via `ReadKey`.

## How to build and run

```bash
fpc movehello.pas
./movehello
```

`"Hello, world!"` appears centered on the screen. Use the arrow keys to move it one character at a time in any direction. Press any other key (e.g. Enter, Escape, a letter) to clear the screen and exit.

## Notes

- The arrow-key codes (`72`, `75`, `77`, `80`) are specific to the "standard" IBM PC extended-key scan codes historically used by Turbo Pascal/DOS-era `crt` implementations; behavior can vary depending on your terminal emulator and how Free Pascal's `crt` unit maps keys on your platform.
- Because `ScreenWidth`/`ScreenHeight` are only read once at startup (see the earlier `hellocrt.pas` example's notes), resizing the terminal while the program is running won't be reflected, and the wraparound math will be based on whatever size was detected at launch.
- Moving the message far enough in any direction will make it wrap around to the opposite edge of the screen instead of disappearing — try holding an arrow key down (or pressing it repeatedly) to see it loop continuously.
