# ReadLongintDemo — Safe integer input in Pascal

A beginner-friendly Pascal program that shows how to read an integer
from the console **without crashing** when the user types something wrong.

---

## The problem with standard `readln`

```pascal
var n: longint;
readln(n);   // user types "12a3" --> program crashes immediately
```

There is no way to recover. The program just stops.

---

## The solution — `ReadLongint`

```pascal
procedure ReadLongint(var success: boolean; var result: longint);
```

Reads one integer character by character and checks every symbol manually.
Instead of crashing it tells you exactly where the bad character was.

### Return values

The procedure has no return value (it is a `procedure`, not a `function`).
Instead it writes two results back through `var` parameters:

| Parameter | Type | Meaning |
|-----------|------|---------|
| `success` | `boolean` | `true` = number read OK, `false` = bad character found |
| `result` | `longint` | the number itself — only valid when `success = true` |

### How to call it

```pascal
var
  ok : boolean;
  n  : longint;
begin
  ReadLongint(ok, n);
  if ok then
    writeln('Got: ', n)
  else
    writeln('Input error.');
end;
```

---

## How the procedure works step by step

**Step 1 — skip leading spaces**

```pascal
repeat
  read(c);
  pos := pos + 1
until (c <> ' ') and (c <> #10);
```

Reads and discards characters until it finds something that is not a
space or a newline. This lets the user type `  42` with spaces and still
get `42`.

**Step 2 — read digits one by one**

```pascal
while (c <> ' ') and (c <> #10) do
begin
  if (c < '0') or (c > '9') then
  begin
    writeln('Unexpected ''', c, '''', ' in pos: ', pos);
    success := false;
    exit
  end;
  res := res * 10 + ord(c) - ord('0');
  read(c);
  pos := pos + 1
end;
```

Loops until a space or newline. On each character:
- **not a digit** → prints the bad character and its position, sets
  `success = false`, exits immediately
- **digit** → adds it to the running total with the formula
  `res * 10 + (c - '0')`. Example: reading `4` then `2` gives
  `0*10+4 = 4`, then `4*10+2 = 42`

`ord(c) - ord('0')` converts a digit character to its numeric value
(`'7'` has code 55, `'0'` has code 48, difference = 7).

**Step 3 — return the result**

```pascal
result  := res;
success := true
```

Reached only if every character was a valid digit. Writes the number
into `result` and sets `success = true`.

---

## What the demo program does

| Step | What happens |
|------|--------------|
| 1 | Asks for two numbers with a retry loop — bad input just asks again |
| 2 | Shows `+`, `-`, `*`, `div`, `mod` on the two numbers |
| 3 | Demonstrates a single call where the user can type a letter to see the error message |

Example session:

```
Enter first number : 12a3
Unexpected 'a' in pos: 3
  Please try again, digits only.
Enter first number : 42
Enter second number: 8

  a         = 42
  b         = 8
  a + b     = 50
  a - b     = 34
  a * b     = 336
  a div b   = 5
  a mod b   = 2
```

---

## How to compile and run

```bash
fpc ReadLongintDemo.pas
./ReadLongintDemo          # Linux / macOS
ReadLongintDemo.exe        # Windows
```

Install FPC on Ubuntu/Debian:

```bash
sudo apt install fpc
```

---

## Key concepts used

| Concept | Explanation |
|---------|-------------|
| `var` parameter | Passes a variable by reference so the procedure can write back to it |
| `procedure` vs `function` | A procedure returns nothing directly; results go through `var` parameters |
| `ord(c) - ord('0')` | Converts a digit character to its integer value without `uses` |
| `exit` | Leaves the procedure immediately, like `return` in other languages |
| `#10` | ASCII code 10 = newline character (end of line) |
