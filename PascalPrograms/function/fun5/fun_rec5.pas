program FibonacciRecursion;

function Fib(n: Integer): Integer;
begin
	if n <= 1 then
		Fib := n                
	else
		Fib := Fib(n - 1) + Fib(n - 2);
end;

var
	i: Integer;
begin
	writeln('Первые 10 чисел Фибоначчи:');
	for i := 0 to 9 do
		write(Fib(i), ' ');
	writeln;
end.
