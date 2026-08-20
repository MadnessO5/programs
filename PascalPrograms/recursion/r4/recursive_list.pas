program RecursiveListLab;                        { recursive_list_lab.pas }

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

function ItemListCount(p: itemptr) : integer;
begin
    if p = nil then
        ItemListCount := 0
    else
        ItemListCount := 1 + ItemListCount(p^.next)
end;

function ItemListMax(p: itemptr; hasValue: boolean; current: integer) : integer;
begin
    if p = nil then
        ItemListMax := current
    else
        if (not hasValue) or (p^.data > current) then
            ItemListMax := ItemListMax(p^.next, true, p^.data)
        else
            ItemListMax := ItemListMax(p^.next, true, current)
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
    if p = nil then
    begin
        writeln('(список пуст)');
        exit
    end;
    while p <> nil do
    begin
        write(p^.data);
        if p^.next <> nil then
            write(', ');
        p := p^.next
    end;
    writeln
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

procedure PrintMenu;
begin
    writeln;
    writeln('1 - Добавить число (рекурсивная вставка в отсортированный список)');
    writeln('2 - Показать список');
    writeln('3 - Сумма элементов (рекурсивно)');
    writeln('4 - Количество элементов (рекурсивно)');
    writeln('5 - Максимум в списке (рекурсивно)');
    writeln('6 - Очистить список (рекурсивное освобождение памяти)');
    writeln('0 - Выход');
end;

var
    first: itemptr;
    choice, n: integer;

begin
    first := nil;

    repeat
        PrintMenu;
        choice := ReadInt('Выбор: ');

        case choice of
            1:
                begin
                    n := ReadInt('Число для добавления: ');
                    AddNumIntoSortedList(first, n)
                end;

            2:
                begin
                    write('Список: ');
                    PrintList(first)
                end;

            3:
                writeln('Сумма: ', ItemListSum(first));

            4:
                writeln('Количество элементов: ', ItemListCount(first));

            5:
                if first = nil then
                    writeln('Список пуст, максимума нет')
                else
                    writeln('Максимум: ', ItemListMax(first, false, 0));

            6:
                begin
                    DisposeItemList(first);
                    first := nil;
                    writeln('Список очищен, память освобождена')
                end;

            0:
                writeln('Выход');
        else
            writeln('Неизвестный пункт меню')
        end
    until choice = 0;

    DisposeItemList(first)
end.
