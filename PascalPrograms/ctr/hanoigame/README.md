# HanoiGame

A full-screen, playable, color-coded Towers of Hanoi game for the terminal, built with the `crt` unit. Pick up and place disks yourself with the keyboard, race against the theoretical minimum move count, and see a win screen when you solve it.

## Controls

- **Left / Right arrows** — move the cursor between the three rods.
- **Enter** — pick up the top disk from the cursor's rod (if nothing is currently held), or place the held disk onto the cursor's rod (if something is held and the move is legal).
- **Escape** — quit the current game.

An illegal placement attempt (putting a larger disk onto a smaller one) doesn't crash or silently fail — it rings the terminal bell (`#7`) so you get immediate audible feedback that the move isn't allowed.

## What it covers

- **Rods as arrays, not linked lists** — each `Rod` is a fixed-size array of disk sizes plus a `count` (how many are currently stacked), with `disks[1]` at the bottom and `disks[count]` on top. Unlike the singly-linked-list rods in `hanoi2.pas`, direct indexing here makes it easy to draw every disk's position in one pass without walking a chain of pointers — a reasonable trade-off since the number of disks is capped (`MaxDisks = 9`) for a game meant to fit on screen.
- **Color-coded disks** — `DiskColors` cycles through the 8 colors valid for `TextBackground` (see `colordemo.pas`'s color table), so each disk size gets a consistent, distinct color, closer to how a real wooden Tower-of-Hanoi toy looks (colored rings of increasing width) than to a text-labeled diagram.
- **Screen-size-aware layout** — `cellWidth`/`pegHeight`/`startX`/`startY` are computed from `numDisks` and `ScreenWidth`/`ScreenHeight` at the start of each game, the same centering approach used in `chess.pas` and `hanoi_game.pas`'s other full-screen predecessors in this collection.
- **Two visible cursor indicators** — a small `v` arrow appears right above the pegs on the currently selected rod, *and* that rod's base platform is drawn in a distinct color (`CursorFG`, cyan) instead of the normal wood-brown. An earlier version of this file only tried the second of these by setting `TextColor` on a row that only ever contained spaces — which is invisible, since a space has no glyph for a foreground color to apply to. Painting the platform's *background* color instead (which does affect every cell regardless of what character is printed) is what actually makes the selected rod visibly stand out.
- **`GetKey`** — the same extended-key-handling wrapper used throughout this chapter's `crt` examples, isolating `ReadKey`'s two-call arrow-key logic into one function.
- **The "held disk" model** — picking up a disk actually removes it from its rod's array (`count` decreases) and remembers its size in `heldDisk`; placing it re-adds it to the target rod. This means a rod with a disk "in your hand" visually shows one fewer disk until you place it somewhere — including back on the same rod, which is a valid (if pointless) way to "cancel" a pickup.
- **Move counting vs. the theoretical minimum** — `minMoves` is computed once at game start as `2^n - 1` (see the discussion in `hanoi.pas`'s README), and the status line shows both your current move count and this minimum throughout, so you can see in real time whether you're still on pace to match the optimal solution.
- **`VisualLength`** — the same UTF-8-aware character-counting helper from `chess.pas`, used here to correctly center Cyrillic win-screen messages (`length()` counts bytes, and Cyrillic letters are 2 bytes each in UTF-8 — using raw `length()` for centering would visibly misplace the text).
- **The win screen (`ShowWinScreen`)** — a bordered box (via `DrawBox`, the same simple `+`/`-`/`|` frame style as `chess.pas`) reporting whether you matched the optimal move count exactly, or how many moves you took versus the minimum, then waits for any keypress (including properly consuming both bytes of an extended key, so nothing is left dangling in the input buffer) before returning to the "play again?" prompt.
- **Replay loop** — after each game (win or Escape-quit), the program asks `Сыграть ещё раз? (y/n)` and only continues if the answer starts with `y`/`Y`; an empty answer (just pressing Enter) is treated as "no."

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- A real terminal window (not piped/redirected input), ideally sized generously — see the Notes below about disk count vs. screen width.
- A terminal capable of an audible bell (most are) for the illegal-move feedback; if yours is silent, illegal moves will still simply be rejected (the board state doesn't change), just without the sound cue.

## How to build and run

```bash
fpc hanoi_game.pas
./hanoi_game
```

You'll be asked how many disks to play with (1–9), then dropped straight into the game.

## Notes

- **Screen width limits how many disks comfortably fit.** Each rod's cell is `2 × numDisks + 6` characters wide, times 3 rods — for 9 disks that's 72 columns minimum, plus margins. On a narrow terminal window, high disk counts may not fit properly (the layout math can go negative, which `crt` generally clips rather than crashes on, but it won't look right). Widen your terminal for larger disk counts, especially on a high-resolution display where you'd want to take advantage of the extra space anyway.
- **9 disks means 511 moves minimum** (`2^9 - 1`) — a genuinely substantial game to solve by hand; starting with 3–4 disks is a much gentler way to get a feel for the controls before attempting a larger puzzle.
- The color scheme reuses the same "keep it calm, don't overload with clashing bright colors" philosophy discussed for `chess.pas` — if colors render oddly in your terminal despite that, it's most likely the `TERM`/terminfo issue discussed in that example's notes, not something specific to this program.
- There's no undo beyond "pick the disk back up and put it wherever you want" — the game doesn't track move history, so there's no way to step backward through your own moves other than manually reversing them yourself.
