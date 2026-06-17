program Latter;
var
        ch: char;
        c: char;
const
	input = 'Enter Latin letter: ';
	output = 'Here is a Latin letter that you entered: ';

function IsLatinLatter(ch: char): boolean;
begin
        IsLatinLatter :=
                ((ch >= 'A') and (ch <= 'Z')) or
                ((ch >= 'a') and (ch <= 'z'))
end;
begin
	repeat
		write(input);
		readln(ch);
        until IsLatinLatter(ch);
	c := ch;
	write(output);
        writeln(c);	
end.
