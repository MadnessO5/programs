# ComplexDataDemo

An interactive console program demonstrating how to build complex data structures in Pascal: an array of records and a two-dimensional array.

## What it covers

- Array of records — CheckPointArray = array [1..MaxCheckPoint] of CheckPoint, representing all checkpoints on an orienteering course (track). Each element is a full CheckPoint record, and its fields are accessed as track[i].latitude, track[i].hidden, etc.
- Multi-dimensional array — matrix5x5 = array [1..5, 1..5] of real, a 5×5 matrix accessed with m[i, j], illustrating how Pascal lets you write multiple index types in one declaration instead of nesting arrays.

## Record fields (CheckPoint)

| Field       | Type      | Meaning                                              |
|-------------|-----------|-------------------------------------------------------|
| n         | integer | Checkpoint number (set automatically to its position) |
| latitude  | real    | Latitude in degrees                                   |
| longitude | real    | Longitude in degrees                                  |
| hidden    | boolean | Whether the checkpoint is hidden (not shown on maps)  |
| penalty   | integer | Penalty in minutes for missing the checkpoint         |

## Requirements

- Free Pascal (fpc) or any compatible Pascal compiler.

## How to build and run

fpc complex_data_demo.pas
./complex_data_demo
The program will ask:

1. How many checkpoints to enter (up to MaxCheckPoint = 75).
2. For each checkpoint: latitude, longitude, hidden (y/n), and penalty.
3. Then it prints a summary of all entered checkpoints.
4. Finally, it asks for 25 values (5×5) to fill a matrix, and prints it as a table.

## Sample session (abbreviated)

Сколько контрольных пунктов на дистанции? (не более 75): 2
Пункт №1:
  Широта: 54.83843
  Долгота: 37.59556
  Скрытый? (y/n): n
  Штраф (мин): 30
Пункт №2:
  Широта: 54.90000
  Долгота: 37.61000
  Скрытый? (y/n): y
  Штраф (мин): 45

Сводка по дистанции:
track[1]: широта=54.83843 долгота=37.59556 скрытый=FALSE штраф=30
track[2]: широта=54.90000 долгота=37.61000 скрытый=TRUE штраф=45

Теперь заполним матрицу 5x5:
m[1,1] = 1
...
## Notes

- count must not exceed MaxCheckPoint (75); the program does not currently validate this — try adding a range check as an exercise.
- Enter y or Y for a hidden checkpoint; anything else is treated as "no".
- The matrix section is a separate demo of multi-dimensional arrays and is independent of the checkpoint track.
