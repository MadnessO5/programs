program ChessBoard;                              { chess.pas }
uses crt;

const
    DarkSquare  = Blue;
    LightSquare = LightGray;
    CursorBG    = Cyan;
    SelectBG    = Green;
    WhiteFG     = White;
    BlackFG     = Black;
    FrameFG     = LightGray;
    FrameBG     = Black;
    TitleFG     = LightGray;
    LabelFG     = LightGray;
    StatusFG    = LightGray;
    BoxBG       = Cyan;
    BoxFG       = Black;
    Title       = '♔  C H E S S  ♚';
    StatusWidth = 68;

type
    TBoard = array [1..8, 1..8] of char;

var
    board: TBoard;
    cellWidth, cellHeight: integer;
    marginLeft: integer;
    boardOriginX, boardOriginY: integer;
    frameLeft, frameTop, frameRight, frameBottom: integer;
    frameWidth, frameHeightTotal: integer;
    titleRow, fileLabelRow, statusRow: integer;
    cursorRow, cursorCol: integer;
    selRow, selCol: integer;
    isWhiteTurn: boolean;
    gameOver: boolean;
    gameOverMessage: string;

function MaxInt2(a, b: integer): integer;
begin
    if a > b then MaxInt2 := a else MaxInt2 := b
end;

function MinInt2(a, b: integer): integer;
begin
    if a < b then MinInt2 := a else MinInt2 := b
end;

function AbsInt(a: integer): integer;
begin
    if a < 0 then AbsInt := -a else AbsInt := a
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

function PadRight(s: string; width: integer): string;
var
    res: string;
begin
    res := s;
    while VisualLength(res) < width do
        res := res + ' ';
    PadRight := res
end;

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

procedure InitBoard;
var
    i: integer;
begin
    for i := 1 to 8 do
    begin
        board[2, i] := 'P';
        board[7, i] := 'p'
    end;
    board[1, 1] := 'R'; board[1, 8] := 'R';
    board[1, 2] := 'N'; board[1, 7] := 'N';
    board[1, 3] := 'B'; board[1, 6] := 'B';
    board[1, 4] := 'Q';
    board[1, 5] := 'K';
    board[8, 1] := 'r'; board[8, 8] := 'r';
    board[8, 2] := 'n'; board[8, 7] := 'n';
    board[8, 3] := 'b'; board[8, 6] := 'b';
    board[8, 4] := 'q';
    board[8, 5] := 'k';
    for i := 3 to 6 do
    begin
        board[i, 1] := '.'; board[i, 2] := '.'; board[i, 3] := '.'; board[i, 4] := '.';
        board[i, 5] := '.'; board[i, 6] := '.'; board[i, 7] := '.'; board[i, 8] := '.'
    end
end;

function IsWhitePiece(c: char): boolean;
begin
    IsWhitePiece := c in ['A'..'Z']
end;

function IsBlackPiece(c: char): boolean;
begin
    IsBlackPiece := c in ['a'..'z']
end;

function PieceGlyph(c: char): string;
begin
    case c of
        'K': PieceGlyph := '♔';
        'Q': PieceGlyph := '♕';
        'R': PieceGlyph := '♖';
        'B': PieceGlyph := '♗';
        'N': PieceGlyph := '♘';
        'P': PieceGlyph := '♙';
        'k': PieceGlyph := '♚';
        'q': PieceGlyph := '♛';
        'r': PieceGlyph := '♜';
        'b': PieceGlyph := '♝';
        'n': PieceGlyph := '♞';
        'p': PieceGlyph := '♟';
    else
        PieceGlyph := ' '
    end
end;

function PathClearOnBoard(const b: TBoard; r1, c1, r2, c2: integer): boolean;
var
    dr, dc, steps, i, rr, cc: integer;
begin
    dr := 0;
    if r2 > r1 then dr := 1 else if r2 < r1 then dr := -1;
    dc := 0;
    if c2 > c1 then dc := 1 else if c2 < c1 then dc := -1;

    steps := MaxInt2(AbsInt(r2 - r1), AbsInt(c2 - c1));
    PathClearOnBoard := true;
    for i := 1 to steps - 1 do
    begin
        rr := r1 + dr * i;
        cc := c1 + dc * i;
        if b[rr, cc] <> '.' then
            PathClearOnBoard := false
    end
end;

function PathClear(r1, c1, r2, c2: integer): boolean;
begin
    PathClear := PathClearOnBoard(board, r1, c1, r2, c2)
end;

function ValidMove(fromRow, fromCol, toRow, toCol: integer): boolean;
var
    piece, target: char;
    dr, dc: integer;
    kind: char;
begin
    ValidMove := false;
    piece := board[fromRow, fromCol];
    target := board[toRow, toCol];
    if piece = '.' then exit;
    if (fromRow = toRow) and (fromCol = toCol) then exit;

    if IsWhitePiece(piece) and IsWhitePiece(target) then exit;
    if IsBlackPiece(piece) and IsBlackPiece(target) then exit;

    dr := toRow - fromRow;
    dc := toCol - fromCol;
    kind := upcase(piece);

    case kind of
        'P':
            begin
                if IsWhitePiece(piece) then
                begin
                    if (dc = 0) and (dr = 1) and (target = '.') then
                        ValidMove := true
                    else
                        if (dc = 0) and (dr = 2) and (fromRow = 2)
                           and (target = '.') and (board[fromRow + 1, fromCol] = '.') then
                            ValidMove := true
                        else
                            if (AbsInt(dc) = 1) and (dr = 1) and IsBlackPiece(target) then
                                ValidMove := true
                end
                else
                begin
                    if (dc = 0) and (dr = -1) and (target = '.') then
                        ValidMove := true
                    else
                        if (dc = 0) and (dr = -2) and (fromRow = 7)
                           and (target = '.') and (board[fromRow - 1, fromCol] = '.') then
                            ValidMove := true
                        else
                            if (AbsInt(dc) = 1) and (dr = -1) and IsWhitePiece(target) then
                                ValidMove := true
                end
            end;
        'N':
            if (AbsInt(dr) = 1) and (AbsInt(dc) = 2) then
                ValidMove := true
            else
                if (AbsInt(dr) = 2) and (AbsInt(dc) = 1) then
                    ValidMove := true;
        'B':
            if (AbsInt(dr) = AbsInt(dc)) and (dr <> 0) and PathClear(fromRow, fromCol, toRow, toCol) then
                ValidMove := true;
        'R':
            if ((dr = 0) xor (dc = 0)) and PathClear(fromRow, fromCol, toRow, toCol) then
                ValidMove := true;
        'Q':
            if (((dr = 0) xor (dc = 0)) or (AbsInt(dr) = AbsInt(dc)))
               and ((dr <> 0) or (dc <> 0)) and PathClear(fromRow, fromCol, toRow, toCol) then
                ValidMove := true;
        'K':
            if (AbsInt(dr) <= 1) and (AbsInt(dc) <= 1) then
                ValidMove := true
    end
end;

function FindKing(const b: TBoard; findWhite: boolean; var kr, kc: integer): boolean;
var
    r, c: integer;
begin
    FindKing := false;
    for r := 1 to 8 do
        for c := 1 to 8 do
            if (findWhite and (b[r, c] = 'K')) or ((not findWhite) and (b[r, c] = 'k')) then
            begin
                kr := r;
                kc := c;
                FindKing := true
            end
end;

function IsSquareAttacked(const b: TBoard; row, col: integer; attackerIsWhite: boolean): boolean;
var
    r, c, dr, dc: integer;
    piece, kind: char;
begin
    IsSquareAttacked := false;
    for r := 1 to 8 do
        for c := 1 to 8 do
        begin
            piece := b[r, c];
            if piece = '.' then continue;
            if attackerIsWhite and (not IsWhitePiece(piece)) then continue;
            if (not attackerIsWhite) and (not IsBlackPiece(piece)) then continue;

            dr := row - r;
            dc := col - c;
            kind := upcase(piece);

            case kind of
                'P':
                    if attackerIsWhite then
                    begin
                        if (dr = 1) and (AbsInt(dc) = 1) then
                            IsSquareAttacked := true
                    end
                    else
                    begin
                        if (dr = -1) and (AbsInt(dc) = 1) then
                            IsSquareAttacked := true
                    end;
                'N':
                    if ((AbsInt(dr) = 1) and (AbsInt(dc) = 2)) or ((AbsInt(dr) = 2) and (AbsInt(dc) = 1)) then
                        IsSquareAttacked := true;
                'B':
                    if (AbsInt(dr) = AbsInt(dc)) and (dr <> 0) and PathClearOnBoard(b, r, c, row, col) then
                        IsSquareAttacked := true;
                'R':
                    if ((dr = 0) xor (dc = 0)) and PathClearOnBoard(b, r, c, row, col) then
                        IsSquareAttacked := true;
                'Q':
                    if (((dr = 0) xor (dc = 0)) or (AbsInt(dr) = AbsInt(dc)))
                       and ((dr <> 0) or (dc <> 0)) and PathClearOnBoard(b, r, c, row, col) then
                        IsSquareAttacked := true;
                'K':
                    if (AbsInt(dr) <= 1) and (AbsInt(dc) <= 1) and ((dr <> 0) or (dc <> 0)) then
                        IsSquareAttacked := true
            end
        end
end;

function InCheck(const b: TBoard; whiteKing: boolean): boolean;
var
    kr, kc: integer;
begin
    InCheck := false;
    if FindKing(b, whiteKing, kr, kc) then
        InCheck := IsSquareAttacked(b, kr, kc, not whiteKing)
end;

function MoveLeavesKingInCheck(fromRow, fromCol, toRow, toCol: integer; moverIsWhite: boolean): boolean;
var
    temp: TBoard;
begin
    temp := board;
    temp[toRow, toCol] := temp[fromRow, fromCol];
    temp[fromRow, fromCol] := '.';
    MoveLeavesKingInCheck := InCheck(temp, moverIsWhite)
end;

function LegalMove(fromRow, fromCol, toRow, toCol: integer; moverIsWhite: boolean): boolean;
begin
    LegalMove := ValidMove(fromRow, fromCol, toRow, toCol)
                 and not MoveLeavesKingInCheck(fromRow, fromCol, toRow, toCol, moverIsWhite)
end;

function HasAnyLegalMove(isWhite: boolean): boolean;
var
    fr, fc, tr, tc: integer;
begin
    HasAnyLegalMove := false;
    for fr := 1 to 8 do
        for fc := 1 to 8 do
        begin
            if isWhite and (not IsWhitePiece(board[fr, fc])) then continue;
            if (not isWhite) and (not IsBlackPiece(board[fr, fc])) then continue;
            for tr := 1 to 8 do
                for tc := 1 to 8 do
                    if LegalMove(fr, fc, tr, tc, isWhite) then
                    begin
                        HasAnyLegalMove := true;
                        exit
                    end
        end
end;

procedure MakeMove(fromRow, fromCol, toRow, toCol: integer);
begin
    board[toRow, toCol] := board[fromRow, fromCol];
    board[fromRow, fromCol] := '.';
    if (board[toRow, toCol] = 'P') and (toRow = 8) then
        board[toRow, toCol] := 'Q';
    if (board[toRow, toCol] = 'p') and (toRow = 1) then
        board[toRow, toCol] := 'q'
end;

procedure CellOrigin(row, col: integer; var ox, oy: integer);
begin
    ox := boardOriginX + (col - 1) * cellWidth;
    oy := boardOriginY + (8 - row) * cellHeight
end;

procedure DrawSquare(row, col: integer);
var
    ox, oy, xx, yy: integer;
    bg: word;
    fg: word;
    letter: char;
begin
    CellOrigin(row, col, ox, oy);

    if (row = cursorRow) and (col = cursorCol) then
        bg := CursorBG
    else
        if (row = selRow) and (col = selCol) then
            bg := SelectBG
        else
            if (row + col) mod 2 = 0 then
                bg := DarkSquare
            else
                bg := LightSquare;

    letter := board[row, col];
    if IsWhitePiece(letter) then
        fg := WhiteFG
    else
        if IsBlackPiece(letter) then
            fg := BlackFG
        else
            fg := bg;

    for yy := 0 to cellHeight - 1 do
    begin
        GotoXY(ox + 1, oy + yy + 1);
        TextBackground(bg);
        for xx := 1 to cellWidth do
            write(' ')
    end;

    if letter <> '.' then
    begin
        GotoXY(ox + cellWidth div 2 + 1, oy + cellHeight div 2 + 1);
        TextBackground(bg);
        TextColor(fg);
        write(PieceGlyph(letter))
    end
end;

procedure DrawFrameLine(y: integer; leftChar, midChar, rightChar: char);
var
    x: integer;
begin
    TextBackground(FrameBG);
    TextColor(FrameFG);
    GotoXY(frameLeft, y);
    write(leftChar);
    for x := frameLeft + 1 to frameRight - 1 do
        write(midChar);
    write(rightChar)
end;

procedure DrawBox(left, top, boxWidth, boxHeight: integer; bg, fg: word);
var
    x, y: integer;
begin
    TextBackground(bg);
    TextColor(fg);
    for y := top to top + boxHeight - 1 do
    begin
        GotoXY(left, y);
        if (y = top) or (y = top + boxHeight - 1) then
        begin
            write('+');
            for x := left + 1 to left + boxWidth - 2 do
                write('-');
            write('+')
        end
        else
        begin
            write('|');
            for x := left + 1 to left + boxWidth - 2 do
                write(' ');
            write('|')
        end
    end
end;

procedure DrawBoard;
var
    r, c: integer;
    labelY: integer;
    labelX: integer;
    statusText: string;
begin
    TextBackground(FrameBG);
    TextColor(TitleFG);
    GotoXY(frameLeft + (frameWidth - VisualLength(Title)) div 2, titleRow);
    write(Title);

    DrawFrameLine(frameTop, '+', '-', '+');
    DrawFrameLine(frameBottom, '+', '-', '+');

    TextBackground(FrameBG);
    TextColor(FrameFG);
    for r := boardOriginY to fileLabelRow do
    begin
        GotoXY(frameLeft, r);
        write('|');
        GotoXY(frameRight, r);
        write('|')
    end;

    for r := 1 to 8 do
    begin
        labelY := boardOriginY + (8 - r) * cellHeight + cellHeight div 2;
        TextColor(LabelFG);
        GotoXY(frameLeft + 1, labelY);
        write(r)
    end;

    for c := 1 to 8 do
    begin
        labelX := boardOriginX + (c - 1) * cellWidth + cellWidth div 2;
        TextColor(LabelFG);
        GotoXY(labelX + 1, fileLabelRow);
        write(chr(ord('a') + c - 1))
    end;

    for r := 1 to 8 do
        for c := 1 to 8 do
            DrawSquare(r, c);

    if isWhiteTurn then
        statusText := 'Ход белых.'
    else
        statusText := 'Ход чёрных.';
    if (not gameOver) and InCheck(board, isWhiteTurn) then
        statusText := statusText + ' Шах!';
    statusText := statusText + ' Стрелки - курсор, Enter - выбрать/сходить, Esc - выход';

    TextBackground(Black);
    TextColor(StatusFG);
    GotoXY(frameLeft, statusRow);
    write(PadRight(statusText, StatusWidth));
    GotoXY(1, 1)
end;

procedure DrawGameOverBox;
var
    instr: string;
    msgLen, instrLen: integer;
    boxWidth, boxHeight, boxLeft, boxTop: integer;
begin
    instr := 'Esc - выход';
    msgLen := VisualLength(gameOverMessage);
    instrLen := VisualLength(instr);
    boxWidth := MaxInt2(msgLen, instrLen) + 4;
    boxHeight := 5;
    boxLeft := frameLeft + (frameWidth - boxWidth) div 2;
    boxTop := frameTop + (frameHeightTotal - boxHeight) div 2;

    DrawBox(boxLeft, boxTop, boxWidth, boxHeight, BoxBG, BoxFG);

    TextBackground(BoxBG);
    TextColor(BoxFG);
    GotoXY(boxLeft + (boxWidth - msgLen) div 2, boxTop + 1);
    write(gameOverMessage);
    GotoXY(boxLeft + (boxWidth - instrLen) div 2, boxTop + 3);
    write(instr);
    GotoXY(1, 1)
end;

var
    code: integer;

begin
    cellWidth := MinInt2(10, MaxInt2(4, ScreenWidth div 10));
    cellHeight := MinInt2(5, MaxInt2(2, cellWidth div 2));
    marginLeft := 3;

    frameWidth := marginLeft + 8 * cellWidth + 2;
    frameHeightTotal := 8 * cellHeight + 1 + 2;

    frameLeft := (ScreenWidth - frameWidth) div 2 + 1;
    frameTop := (ScreenHeight - frameHeightTotal - 2) div 2 + 1;
    frameRight := frameLeft + frameWidth - 1;
    frameBottom := frameTop + frameHeightTotal - 1;

    titleRow := frameTop - 1;
    boardOriginX := frameLeft + 1 + marginLeft;
    boardOriginY := frameTop + 1;
    fileLabelRow := boardOriginY + 8 * cellHeight;
    statusRow := frameBottom + 2;

    InitBoard;
    cursorRow := 1;
    cursorCol := 1;
    selRow := 0;
    selCol := 0;
    isWhiteTurn := true;
    gameOver := false;
    gameOverMessage := '';

    clrscr;
    while true do
    begin
        DrawBoard;
        if gameOver then
            DrawGameOverBox;

        code := GetKey;

        if gameOver then
        begin
            if code = 27 then break
        end
        else
            case code of
                -72: cursorRow := MinInt2(cursorRow + 1, 8);
                -80: cursorRow := MaxInt2(cursorRow - 1, 1);
                -75: cursorCol := MaxInt2(cursorCol - 1, 1);
                -77: cursorCol := MinInt2(cursorCol + 1, 8);
                27: break;
                13:
                    if selRow = 0 then
                    begin
                        if (isWhiteTurn and IsWhitePiece(board[cursorRow, cursorCol]))
                           or ((not isWhiteTurn) and IsBlackPiece(board[cursorRow, cursorCol])) then
                        begin
                            selRow := cursorRow;
                            selCol := cursorCol
                        end
                    end
                    else
                        if (cursorRow = selRow) and (cursorCol = selCol) then
                        begin
                            selRow := 0;
                            selCol := 0
                        end
                        else
                            if LegalMove(selRow, selCol, cursorRow, cursorCol, isWhiteTurn) then
                            begin
                                MakeMove(selRow, selCol, cursorRow, cursorCol);
                                selRow := 0;
                                selCol := 0;
                                isWhiteTurn := not isWhiteTurn;
                                if not HasAnyLegalMove(isWhiteTurn) then
                                begin
                                    gameOver := true;
                                    if InCheck(board, isWhiteTurn) then
                                    begin
                                        if isWhiteTurn then
                                            gameOverMessage := 'Мат! Победили чёрные'
                                        else
                                            gameOverMessage := 'Мат! Победили белые'
                                    end
                                    else
                                        gameOverMessage := 'Пат! Ничья'
                                end
                            end
                            else
                                if (isWhiteTurn and IsWhitePiece(board[cursorRow, cursorCol]))
                                   or ((not isWhiteTurn) and IsBlackPiece(board[cursorRow, cursorCol])) then
                                begin
                                    selRow := cursorRow;
                                    selCol := cursorCol
                                end
                                else
                                begin
                                    selRow := 0;
                                    selCol := 0
                                end
            end
    end;

    TextBackground(Black);
    TextColor(LightGray);
    clrscr
end.
