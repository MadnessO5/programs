program Numbers2;                                { numbers2.pas }
type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;
var
    first, last, tmp: itemptr;
    n: integer;
    pass: integer;
begin
    first := nil;                { делаем список корректно пустым! }
    last := nil;

    while not SeekEof do          { цикл чтения чисел }
    begin
        read(n);
        if first = nil then
        begin
            new(first);           { первый элемент - особый случай }
            last := first
        end
        else
        begin
            new(last^.next);      { добавляем в конец через last }
            last := last^.next
        end;
        last^.data := n;
        last^.next := nil
    end;

    for pass := 1 to 2 do          { печатаем весь список ДВАЖДЫ }
    begin
        tmp := first;
        while tmp <> nil do
        begin
            writeln(tmp^.data);
            tmp := tmp^.next
        end
    end;

    while first <> nil do          { освобождаем память по всем правилам }
    begin
        tmp := first^.next;         { запоминаем адрес следующего }
        dispose(first);             { уничтожаем первый элемент }
        first := tmp                { список теперь начинается со следующего }
    end
end.
