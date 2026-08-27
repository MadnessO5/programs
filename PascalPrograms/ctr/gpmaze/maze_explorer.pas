program MazeExplorer;                            { maze_explorer.pas }
uses crt;

const
    MazeW = 15;
    MazeH = 9;
    CellCharWidth = 2;
    CarveDelay = 15;
    WallColor    = Blue;
    PassageColor = Black;
    StartColor   = Green;
    EndColor     = Red;
    PlayerColor  = Magenta;
    FrameFG = LightGray;
    TitleFG = White;
    BoxBG = Green;
    BoxFG = Black;

var
    grid: array [0..2 * MazeW, 0..2 * MazeH] of boolean;
    visited: array [0..MazeW - 1, 0..MazeH - 1] of boolean;
    onPath: array [0..MazeW - 1, 0..MazeH - 1] of boolean;
    frameLeft, frameTop, frameWidth, frameHeight: integer;
    boardOriginX, boardOriginY: integer;
    titleRow, statusRow: integer;
    playerX, playerY: integer;
    moveCount: longint;

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

{ Draws one grid position, filled with a repeated character, in the
  given background/foreground colors. Using a distinct CHARACTER for
  walls versus passages (not just a different color) means the maze
  stays readable even if the terminal renders colors poorly. }
procedure DrawCellAt(gx, gy: integer; ch: char; bg, fg: word);
var
    x: integer;
begin
    GotoXY(boardOriginX + gx * CellCharWidth + 1, boardOriginY + gy + 1);
    TextBackground(bg);
    TextColor(fg);
    for x := 1 to CellCharWidth do
        write(ch)
end;

{ Draws a cell's normal (non-player) appearance: the start cell shows
  'S', the exit cell shows 'E', every other open cell is blank. }
procedure DrawDefaultCell(cx, cy: integer);
begin
    if (cx = 0) and (cy = 0) then
        DrawCellAt(2 * cx + 1, 2 * cy + 1, 'S', StartColor, White)
    else
        if (cx = MazeW - 1) and (cy = MazeH - 1) then
            DrawCellAt(2 * cx + 1, 2 * cy + 1, 'E', EndColor, White)
        else
            DrawCellAt(2 * cx + 1, 2 * cy + 1, ' ', PassageColor, Black)
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
            DrawCellAt(gx, gy, '#', WallColor, White)
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
    DrawDefaultCell(cx, cy);
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
            DrawCellAt(wx, wy, ' ', PassageColor, Black);
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

function CountPathCells: integer;
var
    cx, cy, cnt: integer;
begin
    cnt := 0;
    for cy := 0 to MazeH - 1 do
        for cx := 0 to MazeW - 1 do
            if onPath[cx, cy] then
                cnt := cnt + 1;
    CountPathCells := cnt
end;

procedure DrawTitleAndStatus(const status: string);
var
    title: string;
begin
    TextBackground(Black);
    TextColor(TitleFG);
    title := 'MAZE EXPLORER';
    GotoXY((ScreenWidth - length(title)) div 2 + 1, titleRow);
    write(title);

    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(frameLeft, statusRow);
    write(status, '                                                        ');
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

function ShowMessageBoxKey(const line1, line2, line3: string): integer;
var
    boxWidth, boxHeight, boxLeft, boxTop: integer;
begin
    boxWidth := length(line1);
    if length(line2) > boxWidth then
        boxWidth := length(line2);
    if length(line3) > boxWidth then
        boxWidth := length(line3);
    boxWidth := boxWidth + 4;
    boxHeight := 7;
    boxLeft := (ScreenWidth - boxWidth) div 2 + 1;
    boxTop := (ScreenHeight - boxHeight) div 2 + 1;

    DrawBox(boxLeft, boxTop, boxWidth, boxHeight, BoxBG, BoxFG);
    TextBackground(BoxBG);
    TextColor(BoxFG);
    GotoXY(boxLeft + (boxWidth - length(line1)) div 2, boxTop + 1);
    write(line1);
    GotoXY(boxLeft + (boxWidth - length(line2)) div 2, boxTop + 3);
    write(line2);
    GotoXY(boxLeft + (boxWidth - length(line3)) div 2, boxTop + 5);
    write(line3);
    GotoXY(1, 1);

    ShowMessageBoxKey := GetKey
end;

procedure TryMove(dx, dy: integer);
var
    nx, ny: integer;
begin
    nx := playerX + dx;
    ny := playerY + dy;
    if (nx < 0) or (nx >= MazeW) or (ny < 0) or (ny >= MazeH) then
    begin
        DrawTitleAndStatus('Blocked - there is a wall that way!');
        exit
    end;
    if not CanMove(playerX, playerY, nx, ny) then
    begin
        DrawTitleAndStatus('Blocked - there is a wall that way!');
        exit
    end;

    DrawDefaultCell(playerX, playerY);
    playerX := nx;
    playerY := ny;
    moveCount := moveCount + 1;
    DrawCellAt(2 * playerX + 1, 2 * playerY + 1, '@', PlayerColor, White);
    DrawTitleAndStatus('Arrows to move ("@"), reach the "E" exit, Esc to quit')
end;

var
    key: integer;
    playAgain, won, quitRequested: boolean;
    optimalMoves: integer;
    moveStr, optimalStr: string;

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

        ResetVisited;
        SolveMaze(0, 0);
        optimalMoves := CountPathCells - 1;
        ResetVisited;

        playerX := 0;
        playerY := 0;
        moveCount := 0;
        DrawCellAt(2 * playerX + 1, 2 * playerY + 1, '@', PlayerColor, White);
        DrawTitleAndStatus('Arrows to move ("@"), reach the "E" exit, Esc to quit');

        won := false;
        quitRequested := false;
        while (not won) and (not quitRequested) do
        begin
            key := GetKey;
            case key of
                -72: TryMove(0, -1);
                -80: TryMove(0, 1);
                -75: TryMove(-1, 0);
                -77: TryMove(1, 0);
                27:  quitRequested := true
            end;
            if (playerX = MazeW - 1) and (playerY = MazeH - 1) then
                won := true
        end;

        playAgain := false;
        if won then
        begin
            str(moveCount, moveStr);
            str(optimalMoves, optimalStr);
            key := ShowMessageBoxKey('You escaped the maze!',
                                      'Your moves: ' + moveStr + '   Shortest possible: ' + optimalStr,
                                      'R to play again, any other key to exit');
            if (key = 82) or (key = 114) then
                playAgain := true
        end
    until not playAgain;

    clrscr
end.
