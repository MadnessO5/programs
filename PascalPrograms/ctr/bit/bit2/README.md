# DTrigger

A simple Pascal program that simulates a D flip-flop (D-trigger) in the console.

## Requirements

* Free Pascal Compiler (FPC)

```bash
sudo apt install fpc
```

## Build & Run

```bash
fpc dtrigger.pas
./dtrigger
```

## Usage

Use the following keys:

```text
1 - Toggle D
2 - Pulse clock
0 - Exit
```

The output shows:

* `D` — input
* `Q` — output
* `Q'` — inverted output
* History of the last 10 steps

## How It Works

* Press `1` → changes the `D` input
* Press `2` → sends a clock pulse and `Q` takes the current value of `D`
* Changing `D` without a clock pulse does **not** change `Q`
* `Q'` is always the opposite of `Q`

## Batch Mode

You can also provide `D CLK` pairs through standard input:

```bash
printf "1 0\n1 1\n0 0\n0 1\n" | ./dtrigger
```

Output:

```text
0
1
1
0
```
