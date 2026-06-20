program PrintCharsRecursion;

procedure PrintChars(ch: char; count: integer);
begin
	if count > 0 then
	begin
		write(ch);
		PrintChars(ch, count - 1)
	end
end;

var
	symbol: char;
	number: integer;
begin
	writeln('=== Печать символов с помощью рекурсии ===');
	writeln;
    
	write('Введите символ: ');
	readln(symbol);
    
	write('Сколько раз напечатать? ');
	readln(number);
    
	writeln;
	writeln('Результат:');
	PrintChars(symbol, number);
	writeln; 
end.
