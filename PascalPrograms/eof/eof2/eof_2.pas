program reads;
var
	c: char;
	n: integer;
begin
	n := 0;
	while not eof do
	begin
		read(c);
		if c = #10 then
		begin 
			writeln('In this string --- ', n, ' --- simbols');
			n := 0;
		end
		else
			n := n + 1
	end;
	writeln('Good bye');
end.
