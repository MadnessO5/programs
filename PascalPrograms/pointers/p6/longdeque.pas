program LongDequeDemo;                           { longdeque.pas }

type
    LongItem2Ptr = ^LongItem2;
    LongItem2 = record
        data: longint;
        prev, next: LongItem2Ptr;
    end;

    LongDeque = record
        first, last: LongItem2Ptr;
    end;

procedure LongDequeInit(var deque: LongDeque);
begin
    deque.first := nil;
    deque.last := nil
end;

procedure LongDequePushFront(var deque: LongDeque; n: longint);
var
    tmp: LongItem2Ptr;
begin
    new(tmp);
    tmp^.data := n;
    tmp^.prev := nil;
    tmp^.next := deque.first;
    if deque.first = nil then
        deque.last := tmp
    else
        deque.first^.prev := tmp;
    deque.first := tmp
end;

procedure LongDequePushBack(var deque: LongDeque; n: longint);
var
    tmp: LongItem2Ptr;
begin
    new(tmp);
    tmp^.data := n;
    tmp^.next := nil;
    tmp^.prev := deque.last;
    if deque.last = nil then
        deque.first := tmp
    else
        deque.last^.next := tmp;
    deque.last := tmp
end;

procedure LongDequePopFront(var deque: LongDeque; var n: longint);
var
    tmp: LongItem2Ptr;
begin
    n := deque.first^.data;
    tmp := deque.first;
    deque.first := deque.first^.next;
    if deque.first = nil then
        deque.last := nil
    else
        deque.first^.prev := nil;
    dispose(tmp)
end;

procedure LongDequePopBack(var deque: LongDeque; var n: longint);
var
    tmp: LongItem2Ptr;
begin
    n := deque.last^.data;
    tmp := deque.last;
    deque.last := deque.last^.prev;
    if deque.last = nil then
        deque.first := nil
    else
        deque.last^.next := nil;
    dispose(tmp)
end;

function LongDequeIsEmpty(var deque: LongDeque): boolean;
begin
    LongDequeIsEmpty := deque.first = nil
end;

procedure LongDequePrint(var deque: LongDeque);
var
    tmp: LongItem2Ptr;
begin
    if LongDequeIsEmpty(deque) then
    begin
        writeln('(дека пуста)');
        exit
    end;
    write('front -> ');
    tmp := deque.first;
    while tmp <> nil do
    begin
        write(tmp^.data);
        if tmp^.next <> nil then
            write(', ');
        tmp := tmp^.next
    end;
    writeln(' <- back')
end;

function ReadInt(const prompt: string): longint;
var
    line: string;
    value: longint;
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

var
    d: LongDeque;
    choice: longint;
    n: longint;

begin
    LongDequeInit(d);

    repeat
        writeln;
        writeln('Текущая дека: ');
        LongDequePrint(d);
        writeln('1 - PushFront   2 - PushBack');
        writeln('3 - PopFront    4 - PopBack');
        writeln('0 - выход');
        choice := ReadInt('Выбор: ');

        case choice of
            1:
                begin
                    n := ReadInt('Число для PushFront: ');
                    LongDequePushFront(d, n)
                end;
            2:
                begin
                    n := ReadInt('Число для PushBack: ');
                    LongDequePushBack(d, n)
                end;
            3:
                if LongDequeIsEmpty(d) then
                    writeln('Дека пуста, PopFront невозможен')
                else
                begin
                    LongDequePopFront(d, n);
                    writeln('PopFront вернул: ', n)
                end;
            4:
                if LongDequeIsEmpty(d) then
                    writeln('Дека пуста, PopBack невозможен')
                else
                begin
                    LongDequePopBack(d, n);
                    writeln('PopBack вернул: ', n)
                end;
            0:
                writeln('Выход');
        else
            writeln('Неизвестный пункт меню')
        end
    until choice = 0;

    while not LongDequeIsEmpty(d) do
        LongDequePopFront(d, n)
end.
