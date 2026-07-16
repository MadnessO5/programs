# ColorsDemo

A full-screen Pascal program demonstrating color control via the `crt` unit: it fills the screen with asterisks (`*`) showing every combination of the 16 text colors and 8 background colors, with alternating blinking.

## What it covers

- **`TextColor(color)`** — sets the color used for subsequently written text. Accepts any of the 16 named color constants (see table below).
- **`TextBackground(color)`** — sets the background color for subsequently written text. Only accepts the first 8 of the 16 constants (the ones usable as both foreground and background).
- **Color constants** — `Black`, `Blue`, `Green`, `Cyan`, `Red`, `Magenta`, `Brown`, `LightGray` (usable for both text and background), plus `DarkGray`, `LightBlue`, `LightGreen`, `LightCyan`, `LightRed`, `LightMagenta`, `Yellow`, `White` (text only).
- **`blink`** — added to a text color value (e.g. `TextColor(fgcolor + blink)`) to make that text blink. Adding it works because of how the color/blink bit is packed into the underlying byte, though a bitwise `or` would be the more "correct" operation.
- **`TextAttr`** — a global `integer` variable holding the current color/blink settings as a single packed value. Saving it before changing colors and restoring it afterward (`SaveTextAttr := TextAttr; ... ; TextAttr := SaveTextAttr;`) is the recommended way to leave the terminal in the state it was in before your program ran, since color settings otherwise persist after the program exits.
- **`AllColors`** — an array of all 16 color constants, indexed 1 to 16, used to cycle through every text color (by row) and background color (by column).
- **`MakeLine(line, fgcolor)`** — draws one full row: divides the screen width into `BGColCount` (8) equal column-bands, giving each band a different background color from `AllColors`; within the row, every character uses the same `fgcolor` for text, but even-numbered positions (`i mod 2 = 0`) also get the `blink` attribute.
- **`MakeScreen`** — clears the screen, then calls `MakeLine` once per row, cycling the text color for each row through `AllColors` using `i mod ColorCount + 1`.
- **Avoiding scrolling** — on the very last row (`line = ScreenHeight`), the loop draws one fewer character (`w := w - 1`) so the last cell of the screen is never written to; writing to the terminal's absolute bottom-right cell would otherwise force it to scroll, which `crt` has no way to prevent or reverse.
- **Pausing before exit** — the program waits for the user to press Enter (a plain `readln`, since a full `GetKey` felt like overkill just to pause) before restoring the original colors and clearing the screen.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- Run in a real terminal that supports ANSI colors.

## How to build and run

```bash
fpc colordemo.pas
./colordemo
```

The screen fills with a grid of colored, partly-blinking asterisks. Press Enter to restore your terminal's original colors and exit.

## Notes

- The exact widths of each background-color band depend on integer division (`ScreenWidth div BGColCount`); if the terminal is narrower than 8 columns this would divide to `0`, so the program guards against that (`if cw = 0 then cw := 1`).
- If your program (or terminal session) is interrupted before it reaches `TextAttr := SaveTextAttr; clrscr`, the terminal may be left with a non-default color scheme — this is exactly the limitation the source material describes, and running `reset` (or closing and reopening the terminal) fixes it.
- `crt`'s color support mirrors the original 16-color IBM PC text-mode palette; it does not provide access to full 24-bit "true color" terminal escape sequences, even though many modern terminal emulators support them.
