program delta;
var
	n, k, h, i: integer;
begin
	repeat
		write('Enter the delta''s width (positive odd): ');
		readln(h)
	until (h > 0) and (h mod 2 = 1);
	n := h div 2;

	for k := 1 to n + 1 do
	begin
		if k < n + 1 then
		begin
			for i := 1 to n + 1 - k do
				write(' ');
			write('*');
		end;
		if k < n + 1 then
			if k > 1 then
			begin
				for i := 1 to 2*k - 3 do
					write(' ');
				write('*');
			end;
		if k = n + 1 then
		begin
			for i := 1 to n*2 + 1 do 
				write('*');
			writeln
		end;
		if k < n + 1 then	
			writeln;	
	end;
end.
