program shit;
var
	a, b, t: integer;
begin
	writeln('Put a number');
	read(a);
	writeln('Put b number');
	read(b);
	if a > b then
	begin
		t := a;
		a := b;
		b := t;
	end;
	writeln('Alright a = ', a, ' and b = ', b);
end.
