program HelloCrt;                                { hellocrt.pas }

uses crt;

const
  DelayDuration = 5000;                           { 5 seconds }

var
  Message: string;
  x, y: integer;
  wx, wy: integer;

begin
  write('Введите сообщение для показа по центру экрана: ');
  readln(Message);

  clrscr;
  x := (ScreenWidth - length(Message)) div 2;
  y := ScreenHeight div 2;
  GotoXY(x, y);
  write(Message);

  wx := WhereX;
  wy := WhereY;

  GotoXY(1, ScreenHeight);
  write('ScreenWidth=', ScreenWidth, ' ScreenHeight=', ScreenHeight,
        ' | вывод начат с (', x, ', ', y, ')',
        ' | курсор после вывода (', wx, ', ', wy, ')');

  delay(DelayDuration);
  clrscr
end.
