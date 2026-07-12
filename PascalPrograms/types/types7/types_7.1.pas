program CaseStyleDemo;

type
  Command = (cmdOpen, cmdSave, cmdClose, cmdPrint, cmdExit);

var
  choice: integer;
  cmd: Command;

begin
  writeln('Плохой стиль — case по магическим числам (не делайте так):');
  writeln('1 - Open, 2 - Save, 3 - Close, 4 - Print, 5 - Exit');
  write('Введите номер команды (1..5): ');
  readln(choice);

  case choice of
    1: writeln('Открываем файл');
    2: writeln('Сохраняем файл');
    3: writeln('Закрываем файл');
    4: writeln('Печатаем документ');
    5: writeln('Выходим из программы');
  else
    writeln('Неизвестная команда');
  end;

  writeln;
  writeln('Хороший стиль — case по перечислимому типу с осмысленными именами:');
  cmd := Command(choice - 1);
  case cmd of
    cmdOpen: writeln('Открываем файл');
    cmdSave: writeln('Сохраняем файл');
    cmdClose: writeln('Закрываем файл');
    cmdPrint: writeln('Печатаем документ');
    cmdExit: writeln('Выходим из программы');
  else
    writeln('Неизвестная команда');
  end;
end.
