program NamedPointsDemo;                         { namedpoints.pas }

const
    filename = 'points.bin';

type
    NamedPoint = record
        latitude, longitude: real;
        name: string[15];
    end;

var
    f: file of NamedPoint;
    np: NamedPoint;
    count, i, idx: integer;

begin
    write('Сколько точек записать в файл? ');
    readln(count);

    assign(f, filename);
    rewrite(f);
    for i := 0 to count - 1 do
    begin
        writeln('Точка №', i, ':');
        write('  Название: ');
        readln(np.name);
        write('  Широта: ');
        readln(np.latitude);
        write('  Долгота: ');
        readln(np.longitude);
        write(f, np)
    end;
    close(f);

    writeln;
    writeln('Файл записан. Все точки по порядку:');
    reset(f);
    i := 0;
    while not eof(f) do
    begin
        read(f, np);
        writeln(i, ': ', np.name, ' (', np.latitude:0:5, ', ', np.longitude:0:5, ')');
        i := i + 1
    end;

    writeln;
    write('Введите номер точки для переименования (0..', count - 1, '): ');
    readln(idx);
    if (idx < 0) or (idx > count - 1) then
        writeln('Недопустимый номер точки')
    else
    begin
        seek(f, idx);
        read(f, np);
        write('Новое название для точки №', idx, ': ');
        readln(np.name);
        seek(f, idx);
        write(f, np);

        writeln;
        writeln('Файл после изменения:');
        reset(f);
        i := 0;
        while not eof(f) do
        begin
            read(f, np);
            writeln(i, ': ', np.name, ' (', np.latitude:0:5, ', ', np.longitude:0:5, ')');
            i := i + 1
        end
    end;

    close(f)
end.
