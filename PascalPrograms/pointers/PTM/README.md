# TaskManager

A genuinely useful console to-do list manager, built on a singly linked list, with file persistence. Combines nearly everything covered in the files/pointers/linked-lists material into one practical tool: records, a sorted linked list, pointer-to-pointer insertion/removal, string parsing, and saving/loading a text file.

## Features

- **Add** a task with a title and priority (lower number = higher priority) — inserted directly into the correct sorted position.
- **List** all tasks in priority order, with ID, priority, and status (done / in progress).
- **Mark done** a task by its ID.
- **Remove** a task by its ID.
- **Search** tasks by a keyword (case-insensitive substring match).
- **Save** the whole list to a text file.
- **Load** a list back from a text file (replacing whatever's currently in memory).

## What it demonstrates

- **A sorted singly linked list** (`Task` records linked via `next`) — `TaskListAddSorted` uses the pointer-to-pointer technique from §2.10.6/2.10.7 to insert a new task directly into its correct position by priority, without special-casing an empty list or an insertion at the very front.
- **Pointer-to-pointer removal** — `TaskListRemove` uses the same unified technique to find and unlink a task by ID anywhere in the list (start, middle, or end) with a single loop.
- **Safe traversal without modification** — `TaskListMarkDone`, `TaskListPrint`, and `TaskListSearch` walk the list read-only (or, for `MarkDone`, modify a field of the node they find, without needing to touch any links), so they take the list head by value rather than by `var`.
- **Freeing a whole list** — `TaskListFreeAll` walks the list, saving each node's `next` before `dispose`-ing it, the same safe-deletion order used in `numbers2.pas`.
- **A simple hand-rolled file format** — each task is saved as one line: `id;priority;done;title`, e.g. `3;1;0;Buy groceries`. `ExtractField` (built from `pos`/`copy`/`delete`) parses one semicolon-separated field at a time out of a line, mutating the line as it goes — a small, reusable string-parsing utility.
- **Round-tripping a boolean through text** — `ord(tmp^.done)` writes a `boolean` as `0`/`1` when saving, and `doneVal <> 0` converts it back when loading.
- **`{$I-}`/`IOResult`** — both `TaskListSave` and `TaskListLoad` report a clear error message (and simply return without crashing) if the file can't be created/opened.
- **A safe integer-input helper** (`ReadInt`) — parses input via `val` and re-prompts on invalid input, rather than crashing on bad input (as in earlier examples like `movingstar.pas`'s cousin demos).
- **A hand-written `MyUpperCase`** — used for case-insensitive search, without depending on the `SysUtils` unit.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## How to build and run

```bash
fpc taskmgr.pas
./taskmgr
```

You'll get a menu:

```
1 - Добавить задачу        5 - Поиск по слову
2 - Показать все задачи    6 - Сохранить в файл
3 - Отметить выполненной   7 - Загрузить из файла
4 - Удалить задачу         0 - Выход
Выбор:
```

## Sample session (abbreviated)

```
Выбор: 1
Название задачи: Buy groceries
Приоритет (1 - высокий, чем больше число, тем ниже): 2
Задача добавлена с номером 1

Выбор: 1
Название задачи: Fix critical bug
Приоритет (1 - высокий, чем больше число, тем ниже): 1
Задача добавлена с номером 2

Выбор: 2
 ID  Прио  Статус     Задача
---- ----  ---------  ----------------------------------
   2     1    в работе  Fix critical bug
   1     2    в работе  Buy groceries

Выбор: 3
...
Номер задачи для отметки выполненной: 1
Задача №1 отмечена как выполненная

Выбор: 6
Имя файла для сохранения: tasks.txt
Сохранено задач: 2 в файл tasks.txt
```

The saved `tasks.txt` would contain:
```
2;1;0;Fix critical bug
1;2;1;Buy groceries
```

## Notes

- **Column alignment with Cyrillic status text**: `writeln(... , mark:9, ...)` uses a fixed-width field specifier, but Free Pascal computes that width in **bytes**, not visible characters — and Cyrillic letters take 2 bytes each in UTF-8 (the same caveat discussed for `chess.pas`'s title centering). This means the status column won't align quite as precisely as it would for pure-ASCII text; it's a cosmetic quirk, not a functional bug.
- **IDs are never reused**: removing a task doesn't reclaim its ID for a future task; `nextId` only ever increases (and after loading a file, jumps past the highest ID found in it, via `TaskListMaxId`), so IDs stay unique for as long as the program runs.
- **Loading replaces the current list entirely** (`TaskListFreeAll` is called first) rather than merging with what's already in memory — save your current list first if you don't want to lose it before loading a different file.
- The file format is deliberately simple (semicolon-separated fields, one task per line) and doesn't escape semicolons that might appear inside a task's title — a title containing `;` would be parsed as if it had extra fields. Handling that properly (e.g. with quoting or escaping) would be a reasonable next improvement.
