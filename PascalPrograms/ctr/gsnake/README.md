# SnakeGame

A real-time, full-screen Snake game for the terminal, built with the `crt` unit. Simple rules, growing speed, and a persistent high score that survives between runs — the classic recipe for "just one more try."

## Controls

- **Arrow keys** — change direction (you can't reverse directly into yourself).
- **Escape** — quit at any time.
- **R** — on the game-over screen, play again.

## How to build and run

```bash
fpc snake.pas
./snake
```

## What it covers

- **Real-time movement without blocking on input** — the same `KeyPressed` + `delay` pattern from `movingstar.pas`: the game keeps ticking forward on its own timer, and only reads a key when one is actually waiting, rather than pausing to wait for keyboard input every frame.
- **The snake as an array, not a linked list** — `snake: array[1..MaxLength] of TPoint`, with `snake[1]` as the head. Growing and moving are unified into one operation: shifting every segment one slot toward the tail (`for i := snakeLen downto 2 do snake[i] := snake[i-1]`), then writing the new head into `snake[1]`. Growth is handled by simply incrementing `snakeLen` *before* that shift — the shift then naturally duplicates the old tail position into the newly available slot, which is exactly the visual effect of the tail "staying put for one tick" while the snake gets longer.
- **Queued direction changes** — pressing a key updates `nextDirX`/`nextDirY`, which is only copied into the actual `dirX`/`dirY` used for movement at the start of the *next* tick. This, combined with checking the new direction against the *current* direction (not the just-changed one) when deciding whether a turn is a disallowed 180° reversal, avoids a classic Snake bug where two quick keypresses in the same tick could let the snake reverse directly into its own neck.
- **Self-collision with the classic tail exception** — when checking whether the new head hits the snake's own body, the current tail segment is excused from the check *if the snake isn't growing this tick* (`if (i = snakeLen) and (not growing) then continue`), since the tail is about to move out of that cell in the same tick anyway — matching how the original Snake game actually behaves, rather than the slightly more restrictive (and less satisfying) rule of never allowing the head near the tail at all.
- **Persistent high score** — `LoadHighScore`/`SaveHighScore` read and write a single number to `snake_highscore.txt` using ordinary text-file I/O (`assign`/`reset`/`rewrite`/`readln`/`writeln`, with `{$I-}`/`IOResult` guarding against the file not existing yet on a fresh run). The high score is loaded once at startup and saved immediately whenever it's beaten, so it survives quitting and relaunching the game.
- **Increasing difficulty** — `delayMs` (the tick interval) decreases by `SpeedStep` each time food is eaten, down to a floor of `MinDelay`, so the game gradually speeds up as your score grows — a simple but effective way to keep raising the stakes the longer a run goes on.
- **`ShowMessageBoxKey`** — the same bordered-box overlay style used in `game2048.pas`/`hanoi_game.pas`, but returns the key that was pressed (via the `GetKey` wrapper) instead of just consuming it, so the game-over screen can distinguish `R` (play again) from any other key (exit).

## Notes

- The board is a fixed `30×16` cells (each cell drawn `2` characters wide for a roughly square look, since terminal character cells are taller than they are wide) — a typical terminal window comfortably fits this, but a very narrow or short window may clip the layout.
- `snake_highscore.txt` is created automatically in whatever directory you run the game from; deleting it just resets your high score back to `0` on the next run.
- Difficulty only ever increases within a single run (speed never resets except by starting a new game), so longer runs become progressively more demanding — part of what makes each run feel like it's building toward something, rather than staying static.
