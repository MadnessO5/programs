program R2345;
var
	a, b, c, d, x: real;
procedure powers(x: real; var quad, cube, fourth, fifth: real);
begin
	quad := x * x;
	cube := x * x * x;
	fourth := x * x * x * x;
	fifth := x * x * x * x * x;
end;
begin
	write('Put here num: ');
	readln(x);
	powers(x, a, b, c, d);
	writeln('This is a quad - ', a,', cube - ', b,', fourth - ', c,', fifth - ', d, ' of your num');
end.

