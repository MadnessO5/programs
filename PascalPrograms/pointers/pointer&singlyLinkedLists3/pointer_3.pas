program Numbers1;                                { numbers1.pas }
type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;
var
    first, tmp: itemptr;
    n: integer;
begin
    first := nil;                { делаем список корректно пустым! }
    while not SeekEof do          { цикл чтения чисел }
    begin
        read(n);
        new(tmp);                 { создали }
        tmp^.data := n;           { заполняем }
        tmp^.next := first;
        first := tmp               { включаем в список }
    end;
    tmp := first;                 { проходим по списку с начала }
    while tmp <> nil do           { до конца }
    begin
        writeln(tmp^.data);
        tmp := tmp^.next           { переход к следующему эл-ту }
    end
end.
