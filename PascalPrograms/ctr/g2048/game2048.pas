program Game2048;                                { game2048.pas }
uses crt;

const
    BoardSize = 4;
    CellWidth = 7;
    CellHeight = 3;
    FrameFG = LightGray;
    TitleFG = White;
    TileFG = White;
    BoxBG = Green;
    BoxFG = Black;
    TileBgColors: array [1..7] of word =
        (Blue, Green, Cyan, Magenta, Brown, Red, LightGray);

type
    TBoard = array [1..BoardSize, 1..BoardSize] of longint;
    TLine = array [1..BoardSize] of longint;

var
    board: TBoard;
    prevBoard: TBoard;
    prevScore: longint;
    hasPrevState: boolean;
    score: longint;
    hasWon: boolean;
    frameLeft, frameTop, frameWidth, frameHeight: integer;
    gridOriginX, gridOriginY: integer;
    titleRow, scoreRow, statusRow: integer;

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

function ColorIndexForValue(v: longint): integer;
var
    idx: integer;
begin
    idx := 0;
    while v > 1 do
    begin
        v := v div 2;
        idx := idx + 1
    end;
    ColorIndexForValue := idx
end;

function CountEmpty: integer;
var
    r, c, cnt: integer;
begin
    cnt := 0;
    for r := 1 to BoardSize do
        for c := 1 to BoardSize do
            if board[r, c] = 0 then
                cnt := cnt + 1;
    CountEmpty := cnt
end;

procedure SpawnRandomTile;
var
    emptyCount, target, r, c, idx, value: integer;
begin
    emptyCount := CountEmpty;
    if emptyCount = 0 then
        exit;
    target := random(emptyCount);
    idx := 0;
    for r := 1 to BoardSize do
        for c := 1 to BoardSize do
            if board[r, c] = 0 then
            begin
                if idx = target then
                begin
                    if random(10) = 0 then
                        value := 4
                    else
                        value := 2;
                    board[r, c] := value;
                    exit
                end;
                idx := idx + 1
            end
end;

function CanMove: boolean;
var
    r, c: integer;
begin
    if CountEmpty > 0 then
    begin
        CanMove := true;
        exit
    end;
    for r := 1 to BoardSize do
        for c := 1 to BoardSize - 1 do
            if board[r, c] = board[r, c + 1] then
            begin
                CanMove := true;
                exit
            end;
    for c := 1 to BoardSize do
        for r := 1 to BoardSize - 1 do
            if board[r, c] = board[r + 1, c] then
            begin
                CanMove := true;
                exit
            end;
    CanMove := false
end;

procedure InitBoard;
var
    r, c: integer;
begin
    for r := 1 to BoardSize do
        for c := 1 to BoardSize do
            board[r, c] := 0;
    score := 0;
    hasWon := false;
    hasPrevState := false;
    SpawnRandomTile;
    SpawnRandomTile
end;

function ProcessLine(var line: TLine): longint;
var
    i, j, writePos, gained: integer;
    temp: TLine;
begin
    gained := 0;

    writePos := 1;
    for i := 1 to BoardSize do
        if line[i] <> 0 then
        begin
            temp[writePos] := line[i];
            writePos := writePos + 1
        end;
    for i := writePos to BoardSize do
        temp[i] := 0;
    for i := 1 to BoardSize do
        line[i] := temp[i];

    for i := 1 to BoardSize - 1 do
        if (line[i] <> 0) and (line[i] = line[i + 1]) then
        begin
            line[i] := line[i] * 2;
            gained := gained + line[i];
            line[i + 1] := 0;
            for j := i + 1 to BoardSize - 1 do
                line[j] := line[j + 1];
            line[BoardSize] := 0
        end;

    ProcessLine := gained
end;

function MoveLeft: boolean;
var
    r, c, gained: integer;
    line, original: TLine;
    changed: boolean;
begin
    changed := false;
    for r := 1 to BoardSize do
    begin
        for c := 1 to BoardSize do
        begin
            line[c] := board[r, c];
            original[c] := board[r, c]
        end;
        gained := ProcessLine(line);
        score := score + gained;
        for c := 1 to BoardSize do
        begin
            board[r, c] := line[c];
            if line[c] <> original[c] then
                changed := true
        end
    end;
    MoveLeft := changed
end;

function MoveRight: boolean;
var
    r, c, gained: integer;
    line, original: TLine;
    changed: boolean;
begin
    changed := false;
    for r := 1 to BoardSize do
    begin
        for c := 1 to BoardSize do
        begin
            line[c] := board[r, BoardSize - c + 1];
            original[c] := line[c]
        end;
        gained := ProcessLine(line);
        score := score + gained;
        for c := 1 to BoardSize do
        begin
            board[r, BoardSize - c + 1] := line[c];
            if line[c] <> original[c] then
                changed := true
        end
    end;
    MoveRight := changed
end;

function MoveUp: boolean;
var
    r, c, gained: integer;
    line, original: TLine;
    changed: boolean;
begin
    changed := false;
    for c := 1 to BoardSize do
    begin
        for r := 1 to BoardSize do
        begin
            line[r] := board[r, c];
            original[r] := line[r]
        end;
        gained := ProcessLine(line);
        score := score + gained;
        for r := 1 to BoardSize do
        begin
            board[r, c] := line[r];
            if line[r] <> original[r] then
                changed := true
        end
    end;
    MoveUp := changed
end;

function MoveDown: boolean;
var
    r, c, gained: integer;
    line, original: TLine;
    changed: boolean;
begin
    changed := false;
    for c := 1 to BoardSize do
    begin
        for r := 1 to BoardSize do
        begin
            line[r] := board[BoardSize - r + 1, c];
            original[r] := line[r]
        end;
        gained := ProcessLine(line);
        score := score + gained;
        for r := 1 to BoardSize do
        begin
            board[BoardSize - r + 1, c] := line[r];
            if line[r] <> original[r] then
                changed := true
        end
    end;
    MoveDown := changed
end;

procedure DrawFrameLine(y: integer; leftChar, midChar, rightChar: char);
var
    x: integer;
begin
    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(frameLeft, y);
    write(leftChar);
    for x := frameLeft + 1 to frameLeft + frameWidth - 2 do
        write(midChar);
    write(rightChar)
end;

procedure DrawFrame;
var
    y: integer;
begin
    DrawFrameLine(frameTop, '+', '-', '+');
    DrawFrameLine(frameTop + frameHeight - 1, '+', '-', '+');
    TextBackground(Black);
    TextColor(FrameFG);
    for y := frameTop + 1 to frameTop + frameHeight - 2 do
    begin
        GotoXY(frameLeft, y);
        write('|');
        GotoXY(frameLeft + frameWidth - 1, y);
        write('|')
    end
end;

procedure DrawCell(r, c: integer);
var
    value, ox, oy, x, y: integer;
    color: word;
    numStr: string;
begin
    value := board[r, c];
    ox := gridOriginX + (c - 1) * CellWidth;
    oy := gridOriginY + (r - 1) * CellHeight;

    if value = 0 then
        color := Black
    else
        color := TileBgColors[((ColorIndexForValue(value) - 1) mod 7) + 1];

    for y := 0 to CellHeight - 1 do
    begin
        GotoXY(ox + 1, oy + y + 1);
        TextBackground(color);
        for x := 1 to CellWidth do
            write(' ')
    end;

    if value <> 0 then
    begin
        str(value, numStr);
        GotoXY(ox + (CellWidth - VisualLength(numStr)) div 2 + 1, oy + CellHeight div 2 + 1);
        TextBackground(color);
        if color = LightGray then
            TextColor(Black)
        else
            TextColor(TileFG);
        write(numStr)
    end
end;

procedure DrawAll;
var
    r, c: integer;
    title, scoreStr: string;
begin
    TextBackground(Black);
    TextColor(TitleFG);
    title := '2048';
    GotoXY((ScreenWidth - VisualLength(title)) div 2 + 1, titleRow);
    write(title);

    TextBackground(Black);
    TextColor(FrameFG);
    str(score, scoreStr);
    GotoXY(frameLeft, scoreRow);
    write('Score: ', scoreStr, '        ');

    DrawFrame;

    for r := 1 to BoardSize do
        for c := 1 to BoardSize do
            DrawCell(r, c);

    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(frameLeft, statusRow);
    write('Arrows to move, U to undo, R to restart, Esc to quit           ');

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

procedure ShowMessageBox(const line1, line2, line3: string);
var
    boxWidth, boxHeight, boxLeft, boxTop: integer;
    dummy: char;
begin
    boxWidth := VisualLength(line1);
    if VisualLength(line2) > boxWidth then
        boxWidth := VisualLength(line2);
    if VisualLength(line3) > boxWidth then
        boxWidth := VisualLength(line3);
    boxWidth := boxWidth + 4;
    boxHeight := 7;
    boxLeft := (ScreenWidth - boxWidth) div 2 + 1;
    boxTop := (ScreenHeight - boxHeight) div 2 + 1;

    DrawBox(boxLeft, boxTop, boxWidth, boxHeight, BoxBG, BoxFG);
    TextBackground(BoxBG);
    TextColor(BoxFG);
    GotoXY(boxLeft + (boxWidth - VisualLength(line1)) div 2, boxTop + 1);
    write(line1);
    GotoXY(boxLeft + (boxWidth - VisualLength(line2)) div 2, boxTop + 3);
    write(line2);
    GotoXY(boxLeft + (boxWidth - VisualLength(line3)) div 2, boxTop + 5);
    write(line3);
    GotoXY(1, 1);

    dummy := ReadKey;
    if dummy = #0 then
        dummy := ReadKey
end;

var
    code: integer;
    changed, quitGame: boolean;
    r, c: integer;
    scoreStr: string;

begin
    randomize;

    frameWidth := BoardSize * CellWidth + 2;
    frameHeight := BoardSize * CellHeight + 2;
    frameLeft := (ScreenWidth - frameWidth) div 2 + 1;
    frameTop := (ScreenHeight - frameHeight - 6) div 2 + 1;
    titleRow := frameTop - 2;
    scoreRow := frameTop - 1;
    gridOriginX := frameLeft + 1;
    gridOriginY := frameTop + 1;
    statusRow := frameTop + frameHeight + 1;

    InitBoard;
    quitGame := false;
    clrscr;

    while not quitGame do
    begin
        DrawAll;

        if not hasWon then
        begin
            for r := 1 to BoardSize do
                for c := 1 to BoardSize do
                    if board[r, c] = 2048 then
                        hasWon := true
        end;

        if hasWon then
        begin
            str(score, scoreStr);
            ShowMessageBox('You reached 2048!', 'Score: ' + scoreStr,
                            'Press any key to keep playing');
            hasWon := false
        end
        else
            if not CanMove then
            begin
                str(score, scoreStr);
                ShowMessageBox('Game Over!', 'Final score: ' + scoreStr,
                                'Press any key to exit');
                quitGame := true
            end
            else
            begin
                code := GetKey;
                changed := false;

                if (code = -72) or (code = -80) or (code = -75) or (code = -77) then
                begin
                    prevBoard := board;
                    prevScore := score
                end;

                case code of
                    -72: changed := MoveUp;
                    -80: changed := MoveDown;
                    -75: changed := MoveLeft;
                    -77: changed := MoveRight;
                    27:  quitGame := true;
                    82, 114:
                        begin
                            InitBoard;
                            changed := false
                        end;
                    85, 117:
                        if hasPrevState then
                        begin
                            board := prevBoard;
                            score := prevScore;
                            hasPrevState := false
                        end
                end;

                if changed then
                begin
                    hasPrevState := true;
                    SpawnRandomTile
                end
            end
    end;

    clrscr
end.
