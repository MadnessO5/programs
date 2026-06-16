program you;
var
  a: integer;
  s: string;
begin
	writeln('Write your number');
	read(a);
	if a < 5 then
		writeln('Your number is smaller then 5')
	else 
		writeln('Your number is bigger or equal to 5');
end.
