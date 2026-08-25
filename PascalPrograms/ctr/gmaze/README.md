# MazeGame

An animated maze generator and solver for the terminal, built with `crt`. Watch a random perfect maze carve itself out cell by cell, then watch the solution path light up from entrance to exit — a visual, satisfying demonstration of recursion applied to something other than lists or trees.

## How to build and run

```bash
fpc maze.pas
./maze
```

No controls needed during generation or solving — just watch. When the solved maze appears, press **R** to generate a new one, or any other key to exit.

## What it covers

- **Maze representation** — the maze is stored as a grid of booleans twice the size of the actual `MazeW × MazeH` cell grid in each dimension (`grid: array[0..2*MazeW, 0..2*MazeH] of boolean`). Cell `(cx, cy)`'s own space sits at grid position `(2*cx+1, 2*cy+1)`; the potential wall *between* two adjacent cells sits at the midpoint between their two positions. This is a standard, simple way to represent "cells plus the walls between them" in one uniform grid, and it's what makes rendering straightforward — every grid position is either a passage (`true`) or a wall (`false`), nothing more.
- **Recursive backtracking generation (`Carve`)** — starting from cell `(0,0)`, the algorithm marks the current cell visited, opens it up on screen, then tries its four neighboring cells in a **randomly shuffled order** (a small hand-written Fisher-Yates shuffle on an array of 4 direction codes). For each unvisited neighbor, it knocks down the wall between the current cell and that neighbor, then **recurses into that neighbor** — extending the maze outward — before returning to try the current cell's remaining directions. Because every cell is visited exactly once and walls are only ever opened toward *unvisited* cells, the result is guaranteed to be a "perfect maze": every cell reachable from every other cell by exactly one path, with no loops.
- **Animated generation** — each time `Carve` opens a cell or a wall, it immediately draws that single character block and pauses briefly (`delay(CarveDelay)`) before continuing, so the maze visibly grows outward on screen as the recursion proceeds, rather than appearing all at once.
- **Recursive solving (`SolveMaze`)** — a classic depth-first search: from the current cell, try each of the four directions (in a fixed order this time) that lead through an open passage to an unvisited cell, recursing into whichever one is tried; if a recursive call reports success, mark the current cell as being on the path and report success upward too; if all four directions fail, report failure and let the caller try a different direction (backtracking). Since a perfect maze is a tree (exactly one path between any two cells, no cycles), this search is guaranteed to eventually find the unique path from start to finish.
- **Reusing `visited` for two different jobs** — the same `visited` array is used first during generation (marking which cells `Carve` has already carved out) and then, after being explicitly reset, again during solving (marking which cells `SolveMaze` has already explored) — the grid describing the maze's actual walls (`grid`) is a completely separate array and is never reset between these two phases, which is exactly the bug this file's first draft ran into and had to be corrected.
- **Reconstructing a visible path from a boolean grid** — `onPath` only records *which cells* are on the solution, not the order they were visited in. `DrawSolution` recovers a visually continuous path after the fact: for every path cell, it also colors the connecting wall segment toward any right/below neighbor that's *also* on the path — since those wall segments must be open passages (the path could only have moved through them), this correctly draws an unbroken corridor without needing to separately track the path's actual sequence.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- A real terminal window, reasonably sized (the maze itself renders at roughly 64×21 characters, plus a few rows for the title and status text).

## Notes

- `MazeW`/`MazeH` (cells, not characters) control the maze's size; increasing them means a bigger rendered maze, which needs a correspondingly larger terminal window to display without clipping.
- `CarveDelay` (milliseconds) controls how fast the generation animation plays — lower it for a near-instant maze, raise it to watch the carving more slowly.
- The solving phase itself is not animated (it happens instantly, then the whole solution is drawn at once) — animating the search's backtracking the way `Carve` animates generation would be a natural extension, following the same `delay`-per-step pattern already used for generation.
- The start (green) and end (red) cells are always the top-left and bottom-right cells of the maze; since a perfect maze connects every cell to every other cell, any two cells could serve as valid start/end points, not just these two corners.
