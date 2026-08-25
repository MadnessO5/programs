program MazeGame;                                { maze.pas }
uses crt;

const
    MazeW = 15;
    MazeH = 9;
    CellCharWidth = 2;
    CarveDelay = 20;
    WallColor    = Blue;
    PassageColor = Black;
    StartColor   = Green;
    EndColor     = Red;
    PathColor    = Cyan;
    FrameFG = LightGray;
    TitleFG = White;

var
    grid: array [0..2 * MazeW, 0..2 * MazeH] of boolean;
    visited: array [0..MazeW - 1, 0..MazeH - 1] of boolean;
    onPath: array [0..MazeW - 1, 0..MazeH - 1] of boolean;
    frameLeft, frameTop, frameWidth, frameHeight: integer;
    boardOriginX, boardOriginY: integer;
    titleRow, statusRow: integer;

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

procedure DrawCellAt(gx, gy: integer; color: word);
begin
    GotoXY(boardOriginX + gx * CellCharWidth + 1, boardOriginY + gy + 1);
    TextBackground(color);
    write('':CellCharWidth)
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

procedure DrawAllWalls;
var
    gx, gy: integer;
begin
    for gy := 0 to 2 * MazeH do
        for gx := 0 to 2 * MazeW do
            DrawCellAt(gx, gy, WallColor)
end;

procedure ResetGrid;
var
    x, y: integer;
begin
    for x := 0 to 2 * MazeW do
        for y := 0 to 2 * MazeH do
            grid[x, y] := false
end;

procedure ResetVisited;
var
    x, y: integer;
begin
    for x := 0 to MazeW - 1 do
        for y := 0 to MazeH - 1 do
        begin
            visited[x, y] := false;
            onPath[x, y] := false
        end
end;

procedure Carve(cx, cy: integer);
var
    dirs: array [1..4] of integer;
    i, j, tmp, nx, ny, wx, wy: integer;
begin
    visited[cx, cy] := true;
    grid[2 * cx + 1, 2 * cy + 1] := true;
    DrawCellAt(2 * cx + 1, 2 * cy + 1, PassageColor);
    delay(CarveDelay);

    for i := 1 to 4 do
        dirs[i] := i;
    for i := 4 downto 2 do
    begin
        j := random(i) + 1;
        tmp := dirs[i];
        dirs[i] := dirs[j];
        dirs[j] := tmp
    end;

    for i := 1 to 4 do
    begin
        case dirs[i] of
            1: begin nx := cx;     ny := cy - 1 end;
            2: begin nx := cx + 1; ny := cy     end;
            3: begin nx := cx;     ny := cy + 1 end;
            4: begin nx := cx - 1; ny := cy     end
        end;

        if (nx >= 0) and (nx < MazeW) and (ny >= 0) and (ny < MazeH)
           and (not visited[nx, ny]) then
        begin
            wx := cx + nx + 1;
            wy := cy + ny + 1;
            grid[wx, wy] := true;
            DrawCellAt(wx, wy, PassageColor);
            delay(CarveDelay);
            Carve(nx, ny)
        end
    end
end;

function CanMove(cx, cy, nx, ny: integer): boolean;
begin
    CanMove := grid[cx + nx + 1, cy + ny + 1]
end;

function SolveMaze(cx, cy: integer): boolean;
var
    found: boolean;
begin
    visited[cx, cy] := true;

    if (cx = MazeW - 1) and (cy = MazeH - 1) then
    begin
        onPath[cx, cy] := true;
        SolveMaze := true;
        exit
    end;

    found := false;

    if (not found) and (cy > 0) and CanMove(cx, cy, cx, cy - 1)
       and (not visited[cx, cy - 1]) then
        found := SolveMaze(cx, cy - 1);

    if (not found) and (cx < MazeW - 1) and CanMove(cx, cy, cx + 1, cy)
       and (not visited[cx + 1, cy]) then
        found := SolveMaze(cx + 1, cy);

    if (not found) and (cy < MazeH - 1) and CanMove(cx, cy, cx, cy + 1)
       and (not visited[cx, cy + 1]) then
        found := SolveMaze(cx, cy + 1);

    if (not found) and (cx > 0) and CanMove(cx, cy, cx - 1, cy)
       and (not visited[cx - 1, cy]) then
        found := SolveMaze(cx - 1, cy);

    if found then
        onPath[cx, cy] := true;

    SolveMaze := found
end;

procedure DrawSolution;
var
    cx, cy: integer;
begin
    for cy := 0 to MazeH - 1 do
        for cx := 0 to MazeW - 1 do
            if onPath[cx, cy] then
            begin
                DrawCellAt(2 * cx + 1, 2 * cy + 1, PathColor);
                if (cx < MazeW - 1) and onPath[cx + 1, cy] then
                    DrawCellAt(2 * cx + 2, 2 * cy + 1, PathColor);
                if (cy < MazeH - 1) and onPath[cx, cy + 1] then
                    DrawCellAt(2 * cx + 1, 2 * cy + 2, PathColor)
            end;

    DrawCellAt(1, 1, StartColor);
    DrawCellAt(2 * (MazeW - 1) + 1, 2 * (MazeH - 1) + 1, EndColor)
end;

procedure DrawTitleAndStatus(const status: string);
var
    title: string;
begin
    TextBackground(Black);
    TextColor(TitleFG);
    title := 'MAZE';
    GotoXY((ScreenWidth - length(title)) div 2 + 1, titleRow);
    write(title);

    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(frameLeft, statusRow);
    write(status, '                                              ');
    GotoXY(1, 1)
end;

var
    key: integer;
    playAgain: boolean;

begin
    randomize;

    frameWidth := (2 * MazeW + 1) * CellCharWidth + 2;
    frameHeight := (2 * MazeH + 1) + 2;
    frameLeft := (ScreenWidth - frameWidth) div 2 + 1;
    frameTop := (ScreenHeight - frameHeight - 4) div 2 + 1;
    titleRow := frameTop - 2;
    boardOriginX := frameLeft + 1;
    boardOriginY := frameTop;
    statusRow := frameTop + frameHeight + 1;

    repeat
        ResetGrid;
        ResetVisited;
        clrscr;
        DrawFrame;
        DrawAllWalls;
        DrawTitleAndStatus('Generating maze...');

        Carve(0, 0);

        DrawTitleAndStatus('Solving maze...');
        delay(400);

        ResetVisited;
        SolveMaze(0, 0);
        DrawSolution;

        DrawTitleAndStatus('Solved! Press R for a new maze, any other key to exit');

        key := GetKey;
        playAgain := (key = 82) or (key = 114)
    until not playAgain;

    clrscr
end.
