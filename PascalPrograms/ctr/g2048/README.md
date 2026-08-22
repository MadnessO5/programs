# Game2048

A full-screen, playable, color-coded implementation of 2048 for the terminal, built with the `crt` unit.

## Controls

- **Arrow keys** — slide all tiles up/down/left/right.
- **U** — undo the last move (one level of undo only).
- **R** — restart with a fresh board at any time.
- **Escape** — quit.

## How to build and run

```bash
fpc game2048.pas
./game2048
```

## What it covers

- **The board** — a `4×4` array of `longint` (`0` means empty). Represented directly as `TBoard = array[1..4,1..4] of longint`, no linked structures needed since the board size never changes.
- **`ProcessLine`** — the heart of the game: given one row or column (as a `TLine`, a 4-element array), it compresses non-zero values toward the front, then merges adjacent equal values left-to-right (each resulting tile merges at most once per move — sliding `2 2 2 2` gives `4 4`, not `8 0`), then returns the score gained from any merges. This one function is reused for all four directions.
- **Four directions from one function** — rather than writing separate compress/merge logic four times, `MoveLeft`/`MoveRight`/`MoveUp`/`MoveDown` each just extract a row or column into a `TLine` (in the appropriate order — reversed for right/down), call `ProcessLine`, and write the result back. `MoveRight`, for instance, reads `board[r, BoardSize-c+1]` into `line[c]` — reading the row back-to-front — so `ProcessLine`'s "compress toward the front of the array" logic naturally becomes "compress toward the right edge of the board" once written back.
- **Detecting whether a move actually did anything** — each `Move*` function compares the line before and after processing; if nothing in any row/column changed, the move is a no-op (e.g., pressing left when everything is already pushed left), and no new tile is spawned.
- **`SpawnRandomTile`** — after any move that changes the board, picks a uniformly random empty cell and places a `2` (90% chance) or `4` (10% chance) there, matching the probabilities in the original 2048 game.
- **`CanMove`** — the game-over check: a move is still possible if there's any empty cell, *or* if any two horizontally or vertically adjacent cells hold equal values (meaning some direction could still merge them), even with a completely full board.
- **Color-coded tiles** — `ColorIndexForValue` computes a tile's "power of two" (via repeated division by 2) and uses it to index into `TileBgColors`, a cycle of the 8 colors valid for `TextBackground` (see `colordemo.pas`), so each tile value gets a visually distinct background as the game progresses.
- **`VisualLength`** — the same UTF-8-aware centering helper used in `chess.pas`/`hanoi_game.pas`, applied here to center tile numbers within their cells and to center the win/game-over messages.
- **Undo (`U`)** — before attempting any directional move, the current `board` and `score` are copied into `prevBoard`/`prevScore`. If the move actually changed something, `hasPrevState` is set to `true`, marking that snapshot as a valid target to restore. Pressing `U` copies `prevBoard`/`prevScore` back into `board`/`score` and immediately clears `hasPrevState`, so only **one** move can be undone at a time — pressing `U` twice in a row does nothing the second time, since there's no snapshot-before-the-snapshot kept around. Since `TBoard` is a plain fixed-size array (a value type in Pascal), `prevBoard := board` and `board := prevBoard` are simple, complete copies — no pointers or special copying logic needed.
- **Win and game-over overlays** — `ShowMessageBox` draws a simple bordered box (same `+`/`-`/`|` frame style used throughout this collection's `crt` examples) reporting either "You reached 2048!" (after which play continues, matching the real game's behavior of not forcing you to stop at 2048) or "Game Over!" with your final score, then waits for any keypress.

## Notes

- Reaching the `2048` tile shows a one-time congratulatory message but does **not** end the game — you can keep playing (and keep scoring) afterward, exactly like the original browser game.
- The game only ends when `CanMove` returns `false`: the board is completely full *and* no two adjacent tiles (in any row or column) share the same value, meaning literally no move in any direction would change anything.
- Score is tracked as the sum of every merge's resulting value (merging two `4`s into an `8` adds `8` to the score, not `4`), matching the standard 2048 scoring rule.
- Undo only remembers the single most recent move — restarting the game (`R`) also clears the undo history, so you can't undo across a restart.
- The board is fixed at the classic `4×4` size; changing `BoardSize` would also need `frameWidth`/`frameHeight`/layout math to still fit comfortably in a typical terminal window, since a much larger board wouldn't scale automatically.
