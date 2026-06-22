# 🐣 programms

> Some good & bad programs on Pascal.

A collection of Pascal programs — some work perfectly, some are held together with duct tape. All written with love (and occasional suffering).

## Requirements

- Free Pascal Compiler (FPC)
- Possibly `sox` for the audio programs

```bash
sudo apt install fpc sox
```

## Programs

| File | Description |
|------|-------------|
| `guitar.pas` | 6-string guitar simulator. Play notes with your keyboard. Requires sox. |
| `seven_nation_army.pas` | Plays Seven Nation Army by The White Stripes. Automatically. |
| `morse_help.pas` | Transmits HELP in Morse code. For emergencies. |
| `morse_encoder.pas` | Type any word — it gets transmitted in Morse code. Green interface. |
| `quadratic.pas` | Solves quadratic equations. ax² + bx + c = 0. |
| `halt_exit.pas` | Demonstrates the difference between `halt` and `exit`. |
| `...` | Many more. Some good. Some questionable. |

## How to run any program

```bash
fpc program_name.pas
./program_name
```

## FAQ

**Q: Why Pascal?**
A: Because we can.

**Q: Are all programs good?**
A: The title says "some good & bad". You've been warned.

**Q: Do I need sox?**
A: Only for programs that make noise. Which is several of them.

---

*Written in Pascal. Tested on Linux. Good luck.*
