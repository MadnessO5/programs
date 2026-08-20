program RecursiveListDemo;                       { recursive_list.pas }

type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;

function ItemListSum(p: itemptr) : integer;
begin
    if p = nil then
        ItemListSum := 0
    else
        ItemListSum := p^.data + ItemListSum(p^.next)
end;

procedure DisposeItemList(p: itemptr);
begin
    if p = nil then
        exit;
    DisposeItemList(p^.next);
    dispose(p)
end;

procedure AddNumIntoSortedList(var p: itemptr; n: integer);
var
    tmp: itemptr;
begin
    if (p = nil) or (p^.data > n) then
    begin
        new(tmp);
        tmp^.data := n;
        tmp^.next := p;
        p := tmp
    end
    else
        AddNumIntoSortedList(p^.next, n)
end;

procedure PrintList(p: itemptr);
begin
    while p <> nil do
    begin
        write(p^.data);
        if p^.next <> nil then
            write(', ');
        p := p^.next
    end;
    writeln
end;

var
    first: itemptr;
    n, count, i: integer;

begin
    first := nil;

    write('Сколько чисел ввести? ');
    readln(count);
    for i := 1 to count do
    begin
        write('Число №', i, ': ');
        readln(n);
        AddNumIntoSortedList(first, n)
    end;

    write('Список по возрастанию: ');
    PrintList(first);

    writeln('Сумма элементов списка (рекурсивно): ', ItemListSum(first));

    DisposeItemList(first);
    writeln('Память списка полностью освобождена (рекурсивно)')
end.
