# BitwiseViz

A simple Pascal program that visualizes 8-bit bitwise operations.

## Requirements

* Free Pascal Compiler (FPC)

```bash
sudo apt install fpc
```

## Build & Run

```bash
fpc bitwiseviz.pas
./bitwiseviz
```

## Usage

Enter two numbers from `0` to `255`:

```text
Enter A (0..255): 170
Enter B (0..255): 204
```

The program shows their binary representations and the results of:

```text
A AND B
A OR B
A XOR B
NOT A
NOT B
```

Bits are displayed using colors:

* Green = `1`
* Blue = `0`

## Batch Mode

You can also pass two numbers as command-line arguments:

```bash
./bitwiseviz 170 204
```

Output:

```text
A = 170
B = 204
A AND B = 136
A OR B = 238
A XOR B = 102
NOT A = 85
NOT B = 51
```

## How It Works

* `AND` → bit is `1` when both bits are `1`
* `OR` → bit is `1` when at least one bit is `1`
* `XOR` → bit is `1` when the bits are different
* `NOT` → inverts all 8 bits
* Values are limited to 8 bits (`0..255`)
