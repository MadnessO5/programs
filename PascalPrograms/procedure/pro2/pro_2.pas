program PrintDigitsRecursion;

procedure PrintDigitsOfNumber(n: integer);
begin
    if n > 0 then
    begin
        PrintDigitsOfNumber(n div 10);   
        write(n mod 10, ' ');           
    end
end;

var
    number: integer;
begin
    writeln('=== Печать цифр числа с помощью рекурсии ===');
    writeln;
    
    write('Введите целое число: ');
    readln(number);
    
    if number = 0 then
        writeln('Цифры числа: 0')
    else if number < 0 then
    begin
        write('Цифры числа: -');
        PrintDigitsOfNumber(-number);
        writeln;
    end
    else
    begin
        write('Цифры числа: ');
        PrintDigitsOfNumber(number);
        writeln;
    end;
end.
