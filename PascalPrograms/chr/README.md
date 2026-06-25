```markdown
# ASCII Table Printer

A simple Pascal program that prints an ASCII table showing characters from code 32 to 127.

## Description

This program displays a formatted ASCII table with hexadecimal indexing. It prints characters in a grid format where rows are numbered 2 through 7 (representing the first hexadecimal digit), columns are numbered 0 through F (representing the second hexadecimal digit), and each cell contains the ASCII character corresponding to the code (row * 16 + column).

## How It Works

The program generates characters with ASCII codes from 32 to 127. Row i (from 2 to 7) combined with column j (from 0 to 15) gives character code = i * 16 + j. Codes 32-127 cover all printable ASCII characters from space through delete.

## Output Format

```
  |  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
  |------------------------------------------------
2.|  ! " # $ % & ' ( ) * + , - . /
3.| 0 1 2 3 4 5 6 7 8 9 : ; < = > ?
4.| @ A B C D E F G H I J K L M N O
5.| P Q R S T U V W X Y Z [ \ ] ^ _
6.| ` a b c d e f g h i j k l m n o
7.| p q r s t u v w x y z { | } ~ 
```

## Requirements

Any Pascal compiler (Free Pascal, Turbo Pascal, GNU Pascal, etc.)

## How to Run

Using Free Pascal:
```
fpc print_ascii.pas
./print_ascii
```

Using Turbo Pascal:
```
tpc print_ascii.pas
print_ascii.exe
```

## Code Structure

The program consists of header rows displaying hexadecimal column labels (0-9, A-F), a separator row using dashes, and data rows showing 6 rows (2-7) × 16 columns = 96 printable characters.

## Key Functions Used

chr() - Converts an integer ASCII code to its character representation
write() / writeln() - Output functions for displaying text

## Notes

The program prints characters with codes 32-127 (printable ASCII range). Characters are displayed with a single space between them for readability. The table uses a clean, monospace-friendly format.

## License

Feel free to use, modify, and distribute this code for any purpose.
```
