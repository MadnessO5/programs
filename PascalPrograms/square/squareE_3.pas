program QuadraticSolver;

procedure quadratic(a, b, c: real;
                    var ok: boolean; var x1, x2: real);
var
    d: real;
begin
    ok := false;
    if a = 0 then
        exit;
    d := b*b - 4*a*c;
    if d < 0 then
        exit;
    d := sqrt(d);
    x1 := (-b - d) / (2*a);
    x2 := (-b + d) / (2*a);
    ok := true
end;

var
  a, b, c : real;
  x1, x2  : real;
  ok       : boolean;

begin
  WriteLn('ax^2 + bx + c = 0');
  Write('a = '); Read(a);
  Write('b = '); Read(b);
  Write('c = '); Read(c);

  quadratic(a, b, c, ok, x1, x2);

  if not ok then
  begin
    if a = 0 then
      WriteLn('Error: a = 0')
    else
      WriteLn('No real roots (D < 0)');
  end
  else
  begin
    WriteLn('x1 = ', x1:0:4);
    WriteLn('x2 = ', x2:0:4);
  end;
end.
