program TypeSystemDemo;

type
  MyNumber    = real;
  SimObjectId = integer;
  StudentMark = 1..10;

var
  x, y, z    : MyNumber;
  id          : SimObjectId;
  objName     : string;
  markInput   : integer;
  mark        : StudentMark;
  monthInput  : integer;
  month       : 1..12;
  radius      : MyNumber;
  choice      : integer;

procedure ShowCircleArea(r: MyNumber);
type
  AreaType = MyNumber;
var
  area: AreaType;
begin
  area := 3.14159 * r * r;
  writeln('Radius : ', r:10:4);
  writeln('Area   : ', area:10:4);
end;

procedure MenuNumbers;
begin
  write('x = '); readln(x);
  write('y = '); readln(y);
  z := x + y;
  writeln('x + y = ', z:10:4);
end;

procedure MenuObject;
begin
  write('ID     : '); readln(id);
  write('Name   : '); readln(objName);
  writeln('Object #', id, ' - ', objName);
end;

procedure MenuCircle;
begin
  write('Radius : '); readln(radius);
  ShowCircleArea(radius);
end;

procedure MenuMark;
begin
  write('Mark (1..10) : '); readln(markInput);
  if (markInput >= 1) and (markInput <= 10) then
  begin
    mark := markInput;
    writeln('Mark accepted: ', mark);
  end
  else
    writeln('Error: out of range 1..10');
end;

procedure MenuMonth;
begin
  write('Month (1..12) : '); readln(monthInput);
  if (monthInput >= 1) and (monthInput <= 12) then
  begin
    month := monthInput;
    writeln('Month accepted: ', month);
  end
  else
    writeln('Error: out of range 1..12');
end;

begin
  repeat
    writeln;
    writeln('1 - MyNumber = real        (sum two numbers)');
    writeln('2 - SimObjectId = integer  (enter object)');
    writeln('3 - AreaType = MyNumber    (circle area)');
    writeln('4 - StudentMark = 1..10   (enter mark)');
    writeln('5 - anonymous type 1..12  (enter month)');
    writeln('0 - exit');
    write('> '); readln(choice);
    writeln;

    case choice of
      1: MenuNumbers;
      2: MenuObject;
      3: MenuCircle;
      4: MenuMark;
      5: MenuMonth;
      0: ;
    else
      writeln('Unknown option');
    end;

  until choice = 0;
end.
