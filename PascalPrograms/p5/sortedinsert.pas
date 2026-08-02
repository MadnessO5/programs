program SortedInsert;                            { sortedinsert.pas }
type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;
var
    first: itemptr;
    pp: ^itemptr;
    tmp: itemptr;
    n, count, i: integer;
begin
    first := nil;                          { делаем список корректно пустым! }

    write('Сколько чисел ввести? ');
    readln(count);

    for i := 1 to count do
    begin
        write('Число №', i, ': ');
        readln(n);

        pp := @first;                       { начинаем с адреса first }
        while (pp^ <> nil) and (pp^^.data < n) do
            pp := @(pp^^.next);             { ищем позицию для вставки }

        new(tmp);
        tmp^.next := pp^;                   { новый узел указывает туда же, куда и pp^ }
        tmp^.data := n;
        pp^ := tmp                          { pp^ теперь указывает на новый узел }
    end;

    writeln;
    writeln('Список по возрастанию:');
    tmp := first;
    while tmp <> nil do
    begin
        writeln(tmp^.data);
        tmp := tmp^.next
    end;

    while first <> nil do                   { освобождаем память }
    begin
        tmp := first^.next;
        dispose(first);
        first := tmp
    end
end.
