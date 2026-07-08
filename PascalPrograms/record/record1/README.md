# CheckPointDemo

An interactive console program demonstrating the Pascal record type, using an orienteering checkpoint as an example.

## What it covers

- Defining a record type (CheckPoint) with fields of different types: integer, real, and boolean.
- Declaring a variable of a record type (cp: CheckPoint).
- Accessing and assigning individual fields via dot notation (cp.n, cp.latitude, cp.longitude, cp.hidden, cp.penalty).
- Reading field values interactively with readln.

## Record fields

| Field       | Type      | Meaning                                              |
|-------------|-----------|-------------------------------------------------------|
| n         | integer | Checkpoint number                                     |
| latitude  | real    | Latitude in degrees (negative = southern hemisphere)  |
| longitude | real    | Longitude in degrees (negative = western hemisphere)  |
| hidden    | boolean | Whether the checkpoint is hidden (not shown on maps)  |
| penalty   | integer | Penalty in minutes for missing the checkpoint         |

## Requirements

- Free Pascal (fpc) or any compatible Pascal compiler.

## How to build and run

fpc checkpoint_demo.pas
./checkpoint_demo
The program will prompt you for each field one by one, then print a summary of the checkpoint you entered.

## Sample session

Введите номер контрольного пункта: 70
Введите широту: 54.83843
Введите долготу: 37.59556
Пункт скрытый? (y/n): n
Введите штраф за невзятие пункта (мин): 30

Данные контрольного пункта:
Номер: 70
Широта: 54.83843
Долгота: 37.59556
Скрытый: нет
Штраф: 30 мин
Большой штраф, лучше не пропускать этот пункт
## Notes

- Enter y or Y when asked if the checkpoint is hidden; anything else is treated as "no".
- If the penalty is greater than 30 minutes, the program prints an extra warning — feel free to change this threshold or add similar rules to practice working with record fields.
