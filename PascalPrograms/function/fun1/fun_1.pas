program Cube;
var
	x: real;
	resul: real;
function Cube(x: real): real;
begin
	Cube := x * x * x
end;
begin
	write('Put your number to make it cube: ');
	readln(x);
	resul := Cube(x);
	writeln('In cube = ', resul);
end.
