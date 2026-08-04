program TaskManager;                             { taskmgr.pas }

{
  Консольный менеджер задач на односвязном списке.
  Задачи хранятся отсортированными по приоритету (1 - самый высокий).
  Поддерживает: добавление, список, отметку выполнения, удаление,
  поиск по подстроке, сохранение и загрузку из текстового файла.
}

type
    TaskPtr = ^Task;
    Task = record
        id: integer;
        priority: integer;
        done: boolean;
        title: string[80];
        next: TaskPtr;
    end;

var
    head: TaskPtr;
    nextId: integer;

function MyUpperCase(const s: string): string;
var
    i: integer;
    res: string;
begin
    res := s;
    for i := 1 to length(res) do
        if (res[i] >= 'a') and (res[i] <= 'z') then
            res[i] := chr(ord(res[i]) - ord('a') + ord('A'));
    MyUpperCase := res
end;

function ExtractField(var s: string): string;
var
    p: integer;
begin
    p := pos(';', s);
    if p = 0 then
    begin
        ExtractField := s;
        s := ''
    end
    else
    begin
        ExtractField := copy(s, 1, p - 1);
        delete(s, 1, p)
    end
end;

function ReadInt(const prompt: string): integer;
var
    line: string;
    value: integer;
    errCode: word;
begin
    repeat
        write(prompt);
        readln(line);
        val(line, value, errCode);
        if errCode <> 0 then
            writeln('Это не целое число, попробуйте ещё раз')
    until errCode = 0;
    ReadInt := value
end;

procedure TaskListInit(var h: TaskPtr);
begin
    h := nil
end;

function TaskListMaxId(h: TaskPtr): integer;
var
    tmp: TaskPtr;
    m: integer;
begin
    m := 0;
    tmp := h;
    while tmp <> nil do
    begin
        if tmp^.id > m then
            m := tmp^.id;
        tmp := tmp^.next
    end;
    TaskListMaxId := m
end;

procedure TaskListAddSorted(var h: TaskPtr; taskId, priority: integer;
                            const title: string; taskDone: boolean);
var
    pp: ^TaskPtr;
    tmp: TaskPtr;
begin
    pp := @h;
    while (pp^ <> nil) and (pp^^.priority <= priority) do
        pp := @(pp^^.next);

    new(tmp);
    tmp^.id := taskId;
    tmp^.priority := priority;
    tmp^.title := title;
    tmp^.done := taskDone;
    tmp^.next := pp^;
    pp^ := tmp
end;

procedure TaskListRemove(var h: TaskPtr; taskId: integer; var found: boolean);
var
    pp: ^TaskPtr;
    tmp: TaskPtr;
begin
    found := false;
    pp := @h;
    while (pp^ <> nil) and (not found) do
    begin
        if pp^^.id = taskId then
        begin
            tmp := pp^;
            pp^ := pp^^.next;
            dispose(tmp);
            found := true
        end
        else
            pp := @(pp^^.next)
    end
end;

procedure TaskListMarkDone(h: TaskPtr; taskId: integer; var found: boolean);
var
    tmp: TaskPtr;
begin
    found := false;
    tmp := h;
    while (tmp <> nil) and (not found) do
    begin
        if tmp^.id = taskId then
        begin
            tmp^.done := true;
            found := true
        end;
        tmp := tmp^.next
    end
end;

procedure TaskListPrint(h: TaskPtr);
var
    tmp: TaskPtr;
    mark: string;
begin
    if h = nil then
    begin
        writeln('Список задач пуст');
        exit
    end;
    writeln(' ID  Прио  Статус     Задача');
    writeln('---- ----  ---------  ----------------------------------');
    tmp := h;
    while tmp <> nil do
    begin
        if tmp^.done then
            mark := 'сделано'
        else
            mark := 'в работе';
        writeln(tmp^.id:4, tmp^.priority:6, '  ', mark:9, '  ', tmp^.title);
        tmp := tmp^.next
    end
end;

procedure TaskListSearch(h: TaskPtr; const keyword: string);
var
    tmp: TaskPtr;
    upKeyword, upTitle: string;
    matches: integer;
begin
    upKeyword := MyUpperCase(keyword);
    matches := 0;
    tmp := h;
    while tmp <> nil do
    begin
        upTitle := MyUpperCase(tmp^.title);
        if pos(upKeyword, upTitle) > 0 then
        begin
            if matches = 0 then
            begin
                writeln(' ID  Прио  Статус     Задача');
                writeln('---- ----  ---------  ----------------------------------')
            end;
            matches := matches + 1;
            if tmp^.done then
                writeln(tmp^.id:4, tmp^.priority:6, '  ', 'сделано':9, '  ', tmp^.title)
            else
                writeln(tmp^.id:4, tmp^.priority:6, '  ', 'в работе':9, '  ', tmp^.title)
        end;
        tmp := tmp^.next
    end;
    if matches = 0 then
        writeln('Ничего не найдено')
    else
        writeln('Найдено задач: ', matches)
end;

procedure TaskListFreeAll(var h: TaskPtr);
var
    tmp: TaskPtr;
begin
    while h <> nil do
    begin
        tmp := h^.next;
        dispose(h);
        h := tmp
    end
end;

procedure TaskListSave(h: TaskPtr; const filename: string);
var
    f: text;
    tmp: TaskPtr;
    count: integer;
begin
    {$I-}
    assign(f, filename);
    rewrite(f);
    if IOResult <> 0 then
    begin
        writeln('Не удалось создать файл ', filename);
        exit
    end;

    count := 0;
    tmp := h;
    while tmp <> nil do
    begin
        writeln(f, tmp^.id, ';', tmp^.priority, ';', ord(tmp^.done), ';', tmp^.title);
        count := count + 1;
        tmp := tmp^.next
    end;

    close(f);
    writeln('Сохранено задач: ', count, ' в файл ', filename)
end;

procedure TaskListLoad(var h: TaskPtr; const filename: string);
var
    f: text;
    line, idStr, prioStr, doneStr, title: string;
    taskId, priority: integer;
    doneVal: integer;
    errCode: word;
    count: integer;
begin
    {$I-}
    assign(f, filename);
    reset(f);
    if IOResult <> 0 then
    begin
        writeln('Не удалось открыть файл ', filename);
        exit
    end;

    TaskListFreeAll(h);
    count := 0;

    while not eof(f) do
    begin
        readln(f, line);
        if length(line) > 0 then
        begin
            idStr := ExtractField(line);
            prioStr := ExtractField(line);
            doneStr := ExtractField(line);
            title := line;

            val(idStr, taskId, errCode);
            val(prioStr, priority, errCode);
            val(doneStr, doneVal, errCode);

            TaskListAddSorted(h, taskId, priority, title, doneVal <> 0);
            count := count + 1
        end
    end;

    close(f);
    nextId := TaskListMaxId(h) + 1;
    writeln('Загружено задач: ', count, ' из файла ', filename)
end;

procedure PrintMenu;
begin
    writeln;
    writeln('1 - Добавить задачу        5 - Поиск по слову');
    writeln('2 - Показать все задачи    6 - Сохранить в файл');
    writeln('3 - Отметить выполненной   7 - Загрузить из файла');
    writeln('4 - Удалить задачу         0 - Выход');
end;

var
    choice: integer;
    title, keyword, filename: string;
    priority, taskId: integer;
    found: boolean;

begin
    TaskListInit(head);
    nextId := 1;

    repeat
        PrintMenu;
        choice := ReadInt('Выбор: ');

        case choice of
            1:
                begin
                    write('Название задачи: ');
                    readln(title);
                    priority := ReadInt('Приоритет (1 - высокий, чем больше число, тем ниже): ');
                    TaskListAddSorted(head, nextId, priority, title, false);
                    writeln('Задача добавлена с номером ', nextId);
                    nextId := nextId + 1
                end;

            2:
                TaskListPrint(head);

            3:
                begin
                    TaskListPrint(head);
                    taskId := ReadInt('Номер задачи для отметки выполненной: ');
                    TaskListMarkDone(head, taskId, found);
                    if found then
                        writeln('Задача №', taskId, ' отмечена как выполненная')
                    else
                        writeln('Задача с таким номером не найдена')
                end;

            4:
                begin
                    TaskListPrint(head);
                    taskId := ReadInt('Номер задачи для удаления: ');
                    TaskListRemove(head, taskId, found);
                    if found then
                        writeln('Задача №', taskId, ' удалена')
                    else
                        writeln('Задача с таким номером не найдена')
                end;

            5:
                begin
                    write('Слово для поиска: ');
                    readln(keyword);
                    TaskListSearch(head, keyword)
                end;

            6:
                begin
                    write('Имя файла для сохранения: ');
                    readln(filename);
                    TaskListSave(head, filename)
                end;

            7:
                begin
                    write('Имя файла для загрузки: ');
                    readln(filename);
                    TaskListLoad(head, filename)
                end;

            0:
                writeln('Выход из программы');
        else
            writeln('Неизвестный пункт меню')
        end
    until choice = 0;

    TaskListFreeAll(head)
end.
