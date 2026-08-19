program HanoiGame;                               { hanoi_game.pas }
uses crt;

const
    MaxDisks = 9;
    RodCount = 3;
    DiskColors: array [1..MaxDisks] of word =
        (Blue, Green, Cyan, Red, Magenta, Brown, LightGray, Blue, Green);
    FrameFG   = LightGray;
    TitleFG   = White;
    CursorFG  = Cyan;
    BaseColor = Brown;
    BoxBG     = Green;
    BoxFG     = Black;

type
    Rod = record
        disks: array [1..MaxDisks] of integer;   { disks[1] - низ, disks[count] - верх }
        count: integer;
    end;

var
    rods: array [1..RodCount] of Rod;
    numDisks: integer;
    moves: longint;
    minMoves: longint;
    cursorRod: integer;
    heldDisk: integer;                            { 0 - ничего не держим }
    cellWidth, pegHeight: integer;
    startX, startY: integer;
    titleRow, statusRow, msgRow, arrowRow: integer;
    quitGame: boolean;

function GetKey: integer;
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then
    begin
        c := ReadKey;
        GetKey := -ord(c)
    end
    else
        GetKey := ord(c)
end;

function ReadInt(const prompt: string): integer;
var
    line: string;
    value: integer;
    errCode: word;
begin
    repeat
        write(prompt);
        readln(line);
        val(line, value, errCode);
        if errCode <> 0 then
            writeln('Это не целое число, попробуйте ещё раз')
    until errCode = 0;
    ReadInt := value
end;

function VisualLength(s: string): integer;
var
    i, cnt: integer;
    b: byte;
begin
    cnt := 0;
    for i := 1 to length(s) do
    begin
        b := ord(s[i]);
        if (b and $C0) <> $80 then
            cnt := cnt + 1
    end;
    VisualLength := cnt
end;

procedure InitGame(n: integer);
var
    r, i: integer;
begin
    numDisks := n;
    for r := 1 to RodCount do
        rods[r].count := 0;
    for i := n downto 1 do
    begin
        rods[1].count := rods[1].count + 1;
        rods[1].disks[rods[1].count] := i
    end;

    moves := 0;
    minMoves := 1;
    for i := 1 to n do
        minMoves := minMoves * 2;
    minMoves := minMoves - 1;

    cursorRod := 1;
    heldDisk := 0;
    quitGame := false;

    cellWidth := 2 * numDisks + 6;
    pegHeight := numDisks + 2;
    startX := (ScreenWidth - RodCount * cellWidth) div 2 + 1;
    startY := (ScreenHeight - pegHeight - 7) div 2 + 1;
    titleRow := startY - 2;
    arrowRow := startY - 1;
    statusRow := startY + pegHeight + 2;
    msgRow := statusRow + 1
end;

procedure DrawDiskRow(rodIndex, row, size: integer);
var
    cellLeft, cx, blockWidth, leftPad, rightPad, x: integer;
    color: word;
begin
    cellLeft := startX + (rodIndex - 1) * cellWidth;
    cx := cellWidth div 2;

    if size = 0 then
    begin
        GotoXY(cellLeft + 1, row);
        TextBackground(Black);
        for x := 1 to cx - 1 do
            write(' ');
        TextColor(FrameFG);
        write('|');
        for x := cx + 1 to cellWidth do
            write(' ')
    end
    else
    begin
        blockWidth := 2 * size + 1;
        leftPad := cx - size;
        rightPad := cellWidth - leftPad - blockWidth;
        color := DiskColors[((size - 1) mod MaxDisks) + 1];

        GotoXY(cellLeft + 1, row);
        TextBackground(Black);
        for x := 1 to leftPad do
            write(' ');
        TextBackground(color);
        for x := 1 to blockWidth do
            write(' ');
        TextBackground(Black);
        for x := 1 to rightPad do
            write(' ')
    end
end;

procedure DrawRod(rodIndex: integer);
var
    row, level, size: integer;
begin
    for row := 0 to pegHeight - 1 do
    begin
        level := pegHeight - 1 - row;
        if level < rods[rodIndex].count then
            size := rods[rodIndex].disks[level + 1]
        else
            size := 0;
        DrawDiskRow(rodIndex, startY + row, size)
    end;

    if rodIndex = cursorRod then
        TextBackground(CursorFG)
    else
        TextBackground(BaseColor);
    GotoXY(startX + (rodIndex - 1) * cellWidth + 1, startY + pegHeight);
    write('':cellWidth)
end;

procedure DrawAll;
var
    r, cx: integer;
    title: string;
begin
    TextBackground(Black);
    TextColor(TitleFG);
    title := 'BASHNI HANOYA';
    GotoXY((ScreenWidth - VisualLength(title)) div 2 + 1, titleRow);
    write(title);

    for r := 1 to RodCount do
    begin
        cx := startX + (r - 1) * cellWidth + cellWidth div 2;
        GotoXY(cx, arrowRow);
        TextBackground(Black);
        if r = cursorRod then
        begin
            TextColor(CursorFG);
            write('v')
        end
        else
            write(' ')
    end;

    for r := 1 to RodCount do
        DrawRod(r);

    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(startX, statusRow);
    write('Дисков: ', numDisks:3, '   Ходов: ', moves:5,
          '   Минимум: ', minMoves:5, '      ');

    GotoXY(startX, msgRow);
    if heldDisk = 0 then
        write('Стрелки - выбрать стержень, Enter - взять диск, Esc - выход           ')
    else
        write('Диск №', heldDisk, ' в руке. Enter - положить сюда, Esc - выход              ');

    GotoXY(1, 1)
end;

procedure DrawBox(left, top, w, h: integer; bg, fg: word);
var
    x, y: integer;
begin
    TextBackground(bg);
    TextColor(fg);
    for y := top to top + h - 1 do
    begin
        GotoXY(left, y);
        if (y = top) or (y = top + h - 1) then
        begin
            write('+');
            for x := left + 1 to left + w - 2 do
                write('-');
            write('+')
        end
        else
        begin
            write('|');
            for x := left + 1 to left + w - 2 do
                write(' ');
            write('|')
        end
    end
end;

procedure ShowWinScreen;
var
    msg1, msg2, msg3, movesStr, minStr: string;
    boxWidth, boxHeight, boxLeft, boxTop: integer;
    dummy: char;
begin
    msg1 := 'Поздравляем! Все диски перенесены!';
    str(moves, movesStr);
    str(minMoves, minStr);
    if moves = minMoves then
        msg2 := 'Идеально! Ровно ' + movesStr + ' ходов - это минимум!'
    else
        msg2 := 'Ходов сделано: ' + movesStr + ' (минимум: ' + minStr + ')';
    msg3 := 'Нажмите любую клавишу для выхода';

    boxWidth := VisualLength(msg1);
    if VisualLength(msg2) > boxWidth then
        boxWidth := VisualLength(msg2);
    if VisualLength(msg3) > boxWidth then
        boxWidth := VisualLength(msg3);
    boxWidth := boxWidth + 4;
    boxHeight := 7;
    boxLeft := (ScreenWidth - boxWidth) div 2 + 1;
    boxTop := (ScreenHeight - boxHeight) div 2 + 1;

    DrawBox(boxLeft, boxTop, boxWidth, boxHeight, BoxBG, BoxFG);
    TextBackground(BoxBG);
    TextColor(BoxFG);
    GotoXY(boxLeft + (boxWidth - VisualLength(msg1)) div 2, boxTop + 1);
    write(msg1);
    GotoXY(boxLeft + (boxWidth - VisualLength(msg2)) div 2, boxTop + 3);
    write(msg2);
    GotoXY(boxLeft + (boxWidth - VisualLength(msg3)) div 2, boxTop + 5);
    write(msg3);
    GotoXY(1, 1);

    dummy := ReadKey;
    if dummy = #0 then
        dummy := ReadKey
end;

procedure PlayGame;
var
    code: integer;
begin
    clrscr;
    while not quitGame do
    begin
        DrawAll;

        if rods[3].count = numDisks then
        begin
            ShowWinScreen;
            quitGame := true
        end
        else
        begin
            code := GetKey;
            case code of
                -75: cursorRod := cursorRod - 1;
                -77: cursorRod := cursorRod + 1;
                27:  quitGame := true;
                13:
                    if heldDisk = 0 then
                    begin
                        if rods[cursorRod].count > 0 then
                        begin
                            heldDisk := rods[cursorRod].disks[rods[cursorRod].count];
                            rods[cursorRod].count := rods[cursorRod].count - 1
                        end
                    end
                    else
                        if (rods[cursorRod].count = 0) or
                           (rods[cursorRod].disks[rods[cursorRod].count] > heldDisk) then
                        begin
                            rods[cursorRod].count := rods[cursorRod].count + 1;
                            rods[cursorRod].disks[rods[cursorRod].count] := heldDisk;
                            heldDisk := 0;
                            moves := moves + 1
                        end
                        else
                            write(#7)
            end;

            if cursorRod < 1 then
                cursorRod := RodCount;
            if cursorRod > RodCount then
                cursorRod := 1
        end
    end
end;

var
    n: integer;
    again: string;

begin
    repeat
        clrscr;
        TextBackground(Black);
        TextColor(LightGray);
        n := ReadInt('Сколько дисков (1..9)? ');
        if n < 1 then
            n := 1;
        if n > MaxDisks then
            n := MaxDisks;

        InitGame(n);
        PlayGame;

        clrscr;
        TextBackground(Black);
        TextColor(LightGray);
        write('Сыграть ещё раз? (y/n): ');
        readln(again)
    until not ((length(again) > 0) and (upcase(again[1]) = 'Y'));

    clrscr
end.
