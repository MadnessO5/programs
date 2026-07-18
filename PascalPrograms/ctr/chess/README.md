# ChessBoard

A full-screen, two-player, keyboard-controlled chess game for the terminal, with real chess piece glyphs, check/checkmate/stalemate detection, and a layout that scales to make good use of large (e.g. 2K-monitor) terminal windows.

## What it covers

- **Unicode chess glyphs** — `PieceGlyph(c)` maps each stored letter to its real chess symbol (`♔♕♖♗♘♙` for white, `♚♛♜♝♞♟` for black), so the board looks like an actual chess set rather than an algebraic-notation grid.
- **A calm, minimal color scheme** — dark squares are `Blue`, light squares `LightGray`; the cursor highlight is `Cyan` and the selection highlight is `Green`; the frame, title, coordinate labels, and status line are all a muted `LightGray` on `Black`, so color only appears where it's meaningful (the board itself and the two highlights) instead of competing everywhere at once. All of these are from the 8 colors valid for `TextBackground` (see the color table discussed in `colordemo.pas`) — no text-only colors are used as a background, which was an actual bug in an earlier version of this file.
- **Frame, coordinates, and title** — the board sits inside a simple `+`/`-`/`|` frame, with rank numbers (1–8) on the left, file letters (a–h) on the bottom, and a centered `♔ CHESS ♚` title above.
- **Screen-size-aware layout** — cell size is computed from `ScreenWidth` at startup, so a large terminal window (e.g. maximized on a 2K/1440p display) gets a correspondingly large, easy-to-read board.
- **Full check/checkmate/stalemate detection** — this is the main upgrade over the earlier version:
  - `IsSquareAttacked(board, row, col, attackerIsWhite)` scans every piece of one color and checks whether any of them could reach a given square, using each piece's real movement rules (pawns attack diagonally, knights jump in an L, sliding pieces need a clear path via `PathClearOnBoard`, kings check adjacency).
  - `InCheck(board, whiteKing)` finds that side's king and asks whether the opponent attacks its square.
  - `MoveLeavesKingInCheck` simulates a candidate move on a **copy** of the board (Pascal arrays copy by value, so `temp := board` is a real independent copy) and checks whether the mover's own king would be in check afterward.
  - `LegalMove` combines the piece's movement pattern (`ValidMove`, as before) with the check-safety test above — so you can no longer move a pinned piece or walk your own king into check.
  - `HasAnyLegalMove(isWhite)` tries every possible from-square/to-square combination for a color and returns whether at least one fully legal move exists.
  - After every move, the game checks whether the *opponent* has any legal move left. If not: **checkmate** (opponent's king is in check) ends the game with a win message for the side that just moved, or **stalemate** (opponent's king is safe but has no legal move) ends it as a draw.
- **A centered "game over" box** pops up with the result (`Мат! Победили белые`, `Мат! Победили чёрные`, or `Пат! Ничья`) and waits for Escape to quit — the game genuinely ends now, instead of continuing to accept moves indefinitely.
- **Check indicator** — while the game is still in progress, the status line appends `Шах!` whenever the side to move is currently in check.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- A real terminal window (not piped/redirected input).
- A terminal font that includes the Unicode "Chess Symbols" block (`U+2654`–`U+265F`) — virtually all modern terminal emulators and default monospace fonts support this.

## How to build and run

```bash
fpc chess.pas
./chess
```

## Controls

- **Arrow keys** — move the cursor around the board.
- **Enter** — select a piece / attempt a move to the cursor's current square / deselect.
- **Escape** — quit (also used to close the game-over box once the game has ended).

## What this program deliberately does *not* implement

Kept intentionally out of scope, in the spirit of a single-file `crt` demo:

- **No castling, en passant, or manual promotion choice** — pawns reaching the last rank always auto-promote to a queen.
- **No move history, undo, or draw-by-repetition/50-move-rule detection** — only checkmate and stalemate end the game.
- **No AI opponent** — this is a local two-player "pass the keyboard" game.

## Notes

- The color scheme uses the same 16-color palette discussed in `colordemo.pas`. If colors still look wrong or overly intense in your terminal despite this more muted scheme, that's very likely the `TERM`/terminfo mismatch discussed for kitty in that example's troubleshooting notes, rather than anything in this program — try `TERM=xterm-256color ./chess` to check.
- The chess glyphs are written directly as UTF-8 text in the source file; if your terminal or locale isn't configured for UTF-8 output, they may show up as boxes or garbled bytes instead — almost all modern terminals default to UTF-8, so this is unlikely to be an issue.
- Legality checking (`HasAnyLegalMove`) tries up to 4096 from/to combinations per call, each involving a board copy and a full check scan — this is computationally trivial for a turn-based game and completes effectively instantly, but it's why the code favors clarity (straightforward nested loops) over performance tricks a real chess engine would use.
