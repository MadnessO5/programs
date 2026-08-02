program RemoveNegative;                          { removeneg.pas }
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
    n: integer;
begin
    first := nil;                     { делаем список корректно пустым! }
    while not SeekEof do               { читаем числа, строим список }
    begin
        read(n);
        new(tmp);
        tmp^.data := n;
        tmp^.next := first;
        first := tmp
    end;

    pp := @first;                      { рабочий указатель на указатель }
    while pp^ <> nil do
    begin
        if pp^^.data < 0 then
        begin
            tmp := pp^;                 { запоминаем удаляемое звено }
            pp^ := pp^^.next;           { исключаем его из списка }
            dispose(tmp)                { освобождаем память }
        end
        else
            pp := @(pp^^.next)          { переходим к следующему звену }
    end;

    tmp := first;                      { печатаем то, что осталось }
    while tmp <> nil do
    begin
        writeln(tmp^.data);
        tmp := tmp^.next
    end
end.
