program GotoCase2;

{ Случай 2: очистка ресурсов перед выходом из подпрограммы (cleanup) }

procedure ProcessFile;
label cleanup;
var
  f        : Text;
  line     : string;
  filename : string;
begin
  Write('Введи имя файла: ');
  Read(filename);

  WriteLn('Открываем файл: ', filename);
  Assign(f, filename);

  {$I-}
  Reset(f);
  {$I+}

  if IOResult <> 0 then
  begin
    WriteLn('Ошибка: файл не найден!');
    goto cleanup;
  end;

  ReadLn(f, line);
  if line = '' then
  begin
    WriteLn('Ошибка: файл пустой!');
    goto cleanup;
  end;

  WriteLn('Содержимое: ', line);

cleanup:
  WriteLn('Закрываем файл (очистка).');
  Close(f);
end;

begin
  ProcessFile;
end.
