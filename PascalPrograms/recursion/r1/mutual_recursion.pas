program MutualRecursionDemo;                     { mutual_recursion.pas }

function IsOdd(n: integer): boolean; forward;

function IsEven(n: integer): boolean;
begin
    if n = 0 then
        IsEven := true
    else
        IsEven := IsOdd(n - 1)
end;

function IsOdd(n: integer): boolean;
begin
    if n = 0 then
        IsOdd := false
    else
        IsOdd := IsEven(n - 1)
end;

var
    n: integer;

begin
    write('Введите неотрицательное целое число: ');
    readln(n);
    if n < 0 then
        writeln('Число должно быть неотрицательным')
    else
        if IsEven(n) then
            writeln(n, ' - чётное')
        else
            writeln(n, ' - нечётное')
end.
