# MazeExplorer

A playable version of the maze from `maze.pas` — instead of watching the computer solve it, **you** navigate through a freshly generated maze yourself, with a move counter and a comparison to the shortest possible solution once you escape.

## Controls

- **Arrow keys** — move up/down/left/right through open passages.
- **Escape** — quit at any time.
- **R** — after escaping, generate a new maze and play again.

## How to build and run

```bash
fpc maze_explorer.pas
./maze_explorer
```

You start on the green cell (top-left); the red cell (bottom-right) is the exit. Walking into a wall doesn't move you — it just rings the terminal bell (`#7`) as feedback that the way is blocked.

## What it covers

- **Maze generation** — identical to `maze.pas`: recursive backtracking (`Carve`) carves a random "perfect maze" (exactly one path between any two cells, no loops), animated cell by cell as it's built. This was verified independently: a Python port of the exact same algorithm was run for 20 random mazes at this program's size, and every single one came out fully connected (all 135 cells reachable from the start) with exactly 134 open passages between cells (one fewer than the cell count — the signature of a tree with no cycles, meaning exactly one route exists between any two cells).
- **Walls and passages are distinguished by character, not just color** — walls are drawn as `#`, open passages as blank space, the start as `S`, the exit as `E`, and the player as `@`. An earlier version of this file relied on background color alone (blue walls vs. black passages) to show the maze's structure — if a terminal renders colors unreliably (see the `TERM`/terminfo notes from `colordemo.pas`/`chess.pas`), a color-only maze can become genuinely illegible, which is exactly what made the maze hard to navigate. Giving every cell type its own distinct character means the maze stays fully readable even in a terminal with broken or monochrome color rendering.
- **Movement through the maze, not around it** — `TryMove` checks `CanMove` (the same wall-lookup function from `maze.pas`) before allowing the player to step in a direction; a move is only accepted if there's an actual open passage there, otherwise nothing happens except the bell sound.
- **The player as a moving highlight, not a separate data structure** — the player's position is just two integers (`playerX`, `playerY`); each move redraws the cell being *left* back to its normal appearance (`DrawDefaultCell`, which knows the start and end cells have their own permanent look) and draws the new cell as `@`, so only two character blocks ever need repainting per move rather than the whole maze.
- **Computing the optimal solution length without spoiling it** — right after generation (before the player takes a single step), the same recursive `SolveMaze` depth-first search from `maze.pas` runs silently in the background to find the shortest path, and `CountPathCells - 1` converts "how many cells are on the path" into "how many moves that path takes." This number is kept in memory and only revealed in the victory box after you actually escape — the solution itself is never drawn on screen, so it can't give anything away while you're playing.
- **Win detection** — checked once per move, right after `TryMove`: if the player's new position matches the exit cell's coordinates, the game ends and shows a summary comparing your move count to the optimal one.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- A real terminal window, reasonably sized (same footprint as `maze.pas`: roughly 64×21 characters for the maze itself, plus a few rows for title/status text).

## Notes

- **No terminal bell.** An earlier version of this file rang the terminal bell (`#7`) when you walked into a wall. Some terminals (kitty among them) treat repeated bell characters as a cue for a *visual* bell — flashing or shaking the whole window — which, if you bump into a wall a few times in a row, can look exactly like "everything breaking." Blocked moves now show a plain on-screen message ("Blocked - there is a wall that way!") instead, using nothing but ordinary text — no control characters that a given terminal might interpret unpredictably.
- **Legend**: `#` = wall, blank = open passage, `S` = start, `E` = exit, `@` = you.
- Because the maze is a "perfect maze" (a spanning tree with no loops), there is always **exactly one route** from start to exit — there's no way to get permanently stuck or lock yourself out of solving it, though plenty of dead-end branches to wander into along the way.
- Your move count will almost always come out higher than the shown optimal — that's expected and part of the fun; matching the optimal exactly on a first attempt at a maze you've never seen means you got lucky (or you're very good at this).
- `MazeW`/`MazeH`/`CarveDelay` can be adjusted exactly as described in `maze.pas`'s README, to make bigger or smaller mazes, and faster or slower generation animation.
- There's no in-game hint system (revealing part of the solution mid-attempt) — the shortest path is computed silently up front purely for the post-game comparison, and adding a "reveal a hint" key would be a natural extension, following the same drawing techniques already used elsewhere in this program.
- If colors still look strange in your terminal despite the character-based legend now making the maze fully legible either way, that's very likely the same `TERM`/terminfo mismatch discussed in `colordemo.pas`'s and `chess.pas`'s notes, rather than anything in this program.
