# MovingStar

A full-screen Pascal program that shows an asterisk (`*`) moving continuously across the screen, changing direction with the arrow keys, stopping with spacebar, and exiting with Escape. Demonstrates dynamic (single-keypress) input with `KeyPressed`, combined with an animated screen object represented as a `record`.

## What it covers

- **`KeyPressed`** — a parameterless function returning `true` if the user has pressed a key that hasn't been read yet, `false` if nothing is waiting. This lets the program keep animating the star instead of blocking on `ReadKey` every iteration.
- **`GetKey(var code: integer)`** — the same wrapper used in the earlier `getkey.pas`/`movehello.pas` examples: isolates the quirky `ReadKey` double-call logic for extended key codes (arrow keys) into one place, returning ordinary key codes as positive numbers and extended codes as negated numbers.
- **The `star` record type** — bundles everything describing the moving object's current state: position (`CurX`, `CurY`) and direction (`dx`, `dy`), passed around as a single `var`-parameter instead of four separate parameters.
- **`ShowStar` / `HideStar`** — draw/erase the star at its current position (same idea as `ShowMessage`/`HideMessage` in `movehello.pas`, just for a single character instead of a string).
- **`MoveStar`** — hides the star, updates its position by `(dx, dy)`, wraps it around to the opposite edge if it goes off-screen (`if s.CurX > ScreenWidth then s.CurX := 1`, and similarly for the other three edges), then shows it again — this wraparound logic is exactly the improvement the source material calls out as missing from the earlier `movehello.pas` example.
- **`SetDirection`** — a small helper that just updates a `star`'s `dx`/`dy` fields, used both for the arrow keys and for stopping the star (`dx = dy = 0`) on spacebar.
- **`continue`** — unlike `break`, `continue` ends only the current loop iteration, not the whole loop; used here to skip key-handling and jump straight back to animating when no key is waiting.
- **Main loop structure** — if no key is waiting, move the star and wait `DelayDuration` (`100` ms = 1/10 second) before checking again; if a key *is* waiting, read it and either change direction, stop, or exit (`Escape`, code `27`).

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- Run in a real terminal.

## How to build and run

```bash
fpc movingstar.pas
./movingstar
```

The star starts motionless in the center of the screen. Press an arrow key to start it moving in that direction; it will keep moving (wrapping around the edges) until you press another arrow key, the spacebar (stop), or Escape (exit).

## Notes

- This program fixes the boundary bug mentioned in the source material for the earlier `movehello.pas` example: instead of letting the object leave the visible screen, `MoveStar` wraps it around to the opposite edge.
- The animation speed is controlled by `DelayDuration`; lowering it makes the star move faster, raising it makes it move slower.
- As with the earlier examples, arrow-key codes (`72`/`75`/`77`/`80`) come from the historical PC/DOS extended-key scan code scheme that Free Pascal's `crt` unit still uses; results may vary slightly by platform/terminal.
