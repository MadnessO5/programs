program SnakeGame;                               { snake.pas }
uses crt;

const
    BoardWidth  = 30;
    BoardHeight = 16;
    CellWidth   = 2;
    MaxLength   = BoardWidth * BoardHeight;
    InitialDelay = 150;
    MinDelay    = 50;
    SpeedStep   = 4;
    FoodScore   = 10;
    HighScoreFile = 'snake_highscore.txt';
    BodyColor = Green;
    HeadColor = Cyan;
    FoodColor = Red;
    FrameFG   = LightGray;
    TitleFG   = White;
    BoxBG     = Green;
    BoxFG     = Black;

type
    TPoint = record
        x, y: integer;
    end;

var
    snake: array [1..MaxLength] of TPoint;
    snakeLen: integer;
    dirX, dirY: integer;
    nextDirX, nextDirY: integer;
    foodX, foodY: integer;
    score: longint;
    highScore: longint;
    delayMs: integer;
    gameOver: boolean;
    quitRequested: boolean;
    frameLeft, frameTop, frameWidth, frameHeight: integer;
    boardOriginX, boardOriginY: integer;
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

procedure LoadHighScore;
var
    f: text;
    line: string;
    parsed: longint;
    errCode: word;
begin
    highScore := 0;
    {$I-}
    assign(f, HighScoreFile);
    reset(f);
    if IOResult = 0 then
    begin
        readln(f, line);
        val(line, parsed, errCode);
        if errCode = 0 then
            highScore := parsed;
        close(f)
    end
end;

procedure SaveHighScore;
var
    f: text;
begin
    {$I-}
    assign(f, HighScoreFile);
    rewrite(f);
    if IOResult = 0 then
    begin
        writeln(f, highScore);
        close(f)
    end
end;

procedure SpawnFood;
var
    valid: boolean;
    i: integer;
begin
    repeat
        foodX := random(BoardWidth) + 1;
        foodY := random(BoardHeight) + 1;
        valid := true;
        for i := 1 to snakeLen do
            if (snake[i].x = foodX) and (snake[i].y = foodY) then
                valid := false
    until valid
end;

procedure InitGame;
begin
    snakeLen := 3;
    snake[1].x := BoardWidth div 2;
    snake[1].y := BoardHeight div 2;
    snake[2].x := snake[1].x - 1;
    snake[2].y := snake[1].y;
    snake[3].x := snake[1].x - 2;
    snake[3].y := snake[1].y;

    dirX := 1;
    dirY := 0;
    nextDirX := 1;
    nextDirY := 0;

    score := 0;
    delayMs := InitialDelay;
    gameOver := false;

    SpawnFood
end;

procedure HandleInput;
var
    code: integer;
begin
    if KeyPressed then
    begin
        code := GetKey;
        case code of
            -72: if dirY <> 1 then
                 begin
                     nextDirX := 0;
                     nextDirY := -1
                 end;
            -80: if dirY <> -1 then
                 begin
                     nextDirX := 0;
                     nextDirY := 1
                 end;
            -75: if dirX <> 1 then
                 begin
                     nextDirX := -1;
                     nextDirY := 0
                 end;
            -77: if dirX <> -1 then
                 begin
                     nextDirX := 1;
                     nextDirY := 0
                 end;
            27:  quitRequested := true
        end
    end
end;

procedure Tick;
var
    newHead: TPoint;
    growing, collided: boolean;
    i: integer;
begin
    dirX := nextDirX;
    dirY := nextDirY;

    newHead.x := snake[1].x + dirX;
    newHead.y := snake[1].y + dirY;

    collided := false;
    if (newHead.x < 1) or (newHead.x > BoardWidth) or
       (newHead.y < 1) or (newHead.y > BoardHeight) then
        collided := true;

    growing := (newHead.x = foodX) and (newHead.y = foodY);

    if not collided then
        for i := 1 to snakeLen do
        begin
            if (i = snakeLen) and (not growing) then
                continue;
            if (snake[i].x = newHead.x) and (snake[i].y = newHead.y) then
                collided := true
        end;

    if collided then
    begin
        gameOver := true;
        exit
    end;

    if growing then
    begin
        snakeLen := snakeLen + 1;
        score := score + FoodScore;
        if delayMs > MinDelay then
            delayMs := delayMs - SpeedStep;
        if score > highScore then
        begin
            highScore := score;
            SaveHighScore
        end
    end;

    for i := snakeLen downto 2 do
        snake[i] := snake[i - 1];
    snake[1] := newHead;

    if growing then
        SpawnFood
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

procedure ClearBoard;
var
    y: integer;
begin
    TextBackground(Black);
    for y := 1 to BoardHeight do
    begin
        GotoXY(boardOriginX + 1, boardOriginY + y);
        write('':(BoardWidth * CellWidth))
    end
end;

procedure DrawCellColor(x, y: integer; color: word);
begin
    GotoXY(boardOriginX + (x - 1) * CellWidth + 1, boardOriginY + y);
    TextBackground(color);
    write('':CellWidth)
end;

procedure DrawAll;
var
    i: integer;
    title, scoreStr, highStr: string;
begin
    TextBackground(Black);
    TextColor(TitleFG);
    title := 'SNAKE';
    GotoXY((ScreenWidth - length(title)) div 2 + 1, titleRow);
    write(title);

    TextBackground(Black);
    TextColor(FrameFG);
    str(score, scoreStr);
    str(highScore, highStr);
    GotoXY(frameLeft, scoreRow);
    write('Score: ', scoreStr, '   Best: ', highStr, '        ');

    DrawFrame;
    ClearBoard;
    DrawCellColor(foodX, foodY, FoodColor);
    for i := 1 to snakeLen do
        if i = 1 then
            DrawCellColor(snake[i].x, snake[i].y, HeadColor)
        else
            DrawCellColor(snake[i].x, snake[i].y, BodyColor);

    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(frameLeft, statusRow);
    write('Arrows to move, Esc to quit           ');

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

var
    playAgain: boolean;
    key: integer;
    scoreStr, highStr: string;

begin
    randomize;

    frameWidth := BoardWidth * CellWidth + 2;
    frameHeight := BoardHeight + 2;
    frameLeft := (ScreenWidth - frameWidth) div 2 + 1;
    frameTop := (ScreenHeight - frameHeight - 4) div 2 + 1;
    titleRow := frameTop - 2;
    scoreRow := frameTop - 1;
    boardOriginX := frameLeft + 1;
    boardOriginY := frameTop;
    statusRow := frameTop + frameHeight + 1;

    LoadHighScore;

    repeat
        InitGame;
        quitRequested := false;
        clrscr;

        while (not gameOver) and (not quitRequested) do
        begin
            HandleInput;
            if not quitRequested then
            begin
                Tick;
                if not gameOver then
                begin
                    DrawAll;
                    delay(delayMs)
                end
            end
        end;

        playAgain := false;
        if gameOver then
        begin
            DrawAll;
            str(score, scoreStr);
            str(highScore, highStr);
            key := ShowMessageBoxKey('Game Over!', 'Score: ' + scoreStr + '   Best: ' + highStr,
                                      'R to play again, any other key to exit');
            if (key = 82) or (key = 114) then
                playAgain := true
        end
    until not playAgain;

    clrscr
end.
