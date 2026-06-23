# Guess The Number

A number guessing game written in Pascal. The computer picks a number from 1 to 100 — you try to guess it.

## Requirements

- Free Pascal Compiler (FPC)

```bash
sudo apt install fpc
```

## Build & Run

```bash
fpc guess_number.pas
./guess_number
```

## How to Play

1. The computer picks a secret number between 1 and 100
2. You enter your guess
3. The program tells you if the number is higher or lower
4. The range `[low - high]` updates after each attempt
5. Guess until you get it right!

## Example

```
  Attempt 1 [1-100]: 50
  Too low!  (range: 51 - 100)

  Attempt 2 [51-100]: 75
  Too high! (range: 51 - 74)

  Attempt 3 [51-74]: 60
  CORRECT!!!

  You got it in 3 attempts!
  Rating: Excellent! Are you a psychic?
```

## Rating System

| Attempts | Rating |
|----------|--------|
| 1 — 5   | Excellent! Are you a psychic? |
| 6 — 8   | Good job! |
| 9 — 12  | Not bad, keep practicing. |
| 13+     | That was rough... try again! |

## Tip

If you always guess the middle of the range, you can find any number in **7 attempts or less**. That's called binary search.

## Features

- Range narrows after each guess
- Rejects guesses outside the known range
- Tracks games played, wins, and best result
- Play multiple rounds in one session
