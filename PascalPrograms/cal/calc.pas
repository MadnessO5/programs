program Calculator;

var
    c: integer;
    a, b: real;

begin
    writeln('Ya sup im calculator, wha ya whant?');
    writeln('1 +');
    writeln('2 -');
    writeln('3 *');
    writeln('4 /');
    write('Choose: ');
    readln(c);
    
    write('a: ');
    readln(a);
    write('b: ');
    readln(b);
    
    if c = 1 then writeln(a, ' + ', b, ' = ', a + b);
    if c = 2 then writeln(a, ' - ', b, ' = ', a - b);
    if c = 3 then writeln(a, ' * ', b, ' = ', a * b);
    if c = 4 then 
        if b = 0 then writeln('No')
        else writeln(a, ' / ', b, ' = ', a / b);
    
    readln;
end.
