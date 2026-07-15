# GtKey

A small Pascal program that builds on `ReadKey`, encoding both regular keys and special (two-key-sequence) keys into a single signed integer.

## What it covers

- **The two-key-sequence problem** — as noted in the `RdKey` example, special keys (arrow keys, function keys, etc.) are reported by `ReadKey` as a first call returning `#0`, followed by a second call returning the actual key code. `GtKey` handles this properly instead of ignoring it.
- **`GetKey(var code: integer)`** — a procedure with a `var`-parameter that encodes the result of one logical keypress as a single integer:
  - If the key was an ordinary character, `code` is set to its positive `ord` value.
  - If the key was a special two-key sequence, `code` is set to the **negative** of the second key's `ord` value — so a negative number unambiguously signals "this was a special key", while still preserving which one via its magnitude.
- **`until i = ord(' ')`** — the main loop keeps reading and printing key codes until the spacebar (code `32`) is pressed.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler with the `crt` unit.
- Run in a real terminal — `ReadKey` needs actual terminal input.

## How to build and run

```bash
fpc getkey.pas
./getkey
```

Press keys one at a time. Regular keys print their positive character code; special keys (like arrow keys) print a negative code. Press the spacebar to exit.

## Sample session

```
65
97
-72
-80
32
```

(`65` = `A`, `97` = `a`, `-72` and `-80` are two different arrow keys — the exact codes depend on your terminal/OS — and `32` is the spacebar that ends the loop.)

## Notes

- The specific numeric codes returned for special keys after the leading `#0` (arrow keys, F-keys, Home/End, etc.) are platform- and terminal-dependent; don't assume the same key always gives the same negative code across different systems.
- Since `code`'s sign alone distinguishes "special key" from "ordinary key," this scheme only works correctly as long as no ordinary printable character has an `ord` value that could be confused with a negated special-key code — which holds here since `code` is always compared as a whole signed number, not just checked for a specific value.
