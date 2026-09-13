program BitwiseViz;                              { bitwiseviz.pas }
uses crt;

const
    Bits = 8;
    CellWidth = 3;
    LabelWidth = 10;
    ColorZero = Blue;
    ColorOne  = Green;
    FrameFG   = LightGray;
    TitleFG   = White;
    BitFG     = White;

var
    startX, startY: integer;

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
            writeln('Not a valid integer, try again')
    until errCode = 0;
    ReadInt := value
end;

procedure ComputeAll(a, b: integer; var rAnd, rOr, rXorV, notA, notB: integer);
begin
    rAnd := a and b;
    rOr := a or b;
    rXorV := a xor b;
    notA := (not a) and $FF;
    notB := (not b) and $FF;
    {$IFDEF DEBUG}
    writeln(ErrOutput, 'DEBUG: a=', a, ' b=', b, ' and=', rAnd, ' or=', rOr,
                        ' xor=', rXorV, ' nota=', notA, ' notb=', notB);
    {$ENDIF}
end;

{ Plain-text output, no crt at all -- meant for scripting/automated
  testing, since crt's screen-positioning escape codes don't survive
  being piped or redirected cleanly. }
procedure BatchMode(a, b: integer);
var
    rAnd, rOr, rXorV, notA, notB: integer;
begin
    ComputeAll(a, b, rAnd, rOr, rXorV, notA, notB);
    writeln('A = ', a);
    writeln('B = ', b);
    writeln('A AND B = ', rAnd);
    writeln('A OR B = ', rOr);
    writeln('A XOR B = ', rXorV);
    writeln('NOT A = ', notA);
    writeln('NOT B = ', notB)
end;

procedure DrawBitHeader(y: integer);
var
    i: integer;
begin
    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(startX, y);
    write(' ':LabelWidth);
    for i := Bits - 1 downto 0 do
    begin
        GotoXY(startX + LabelWidth + (Bits - 1 - i) * CellWidth, y);
        write(i:CellWidth)
    end
end;

procedure DrawBitRow(y: integer; const rowLabel: string; value: integer);
var
    i, bit: integer;
    color: word;
    valStr: string;
begin
    TextBackground(Black);
    TextColor(TitleFG);
    GotoXY(startX, y);
    write(rowLabel:LabelWidth);

    for i := 1 to Bits do
    begin
        bit := (value shr (Bits - i)) and 1;
        GotoXY(startX + LabelWidth + (i - 1) * CellWidth, y);
        if bit = 1 then
            color := ColorOne
        else
            color := ColorZero;
        TextBackground(color);
        TextColor(BitFG);
        write(' ', bit, ' ')
    end;

    TextBackground(Black);
    TextColor(FrameFG);
    str(value, valStr);
    write('   = ', valStr, '  (dec)   ')
end;

procedure VisualMode;
var
    a, b, rAnd, rOr, rXorV, notA, notB: integer;
    again: string;
    title: string;
begin
    startX := (ScreenWidth - (LabelWidth + Bits * CellWidth + 20)) div 2 + 1;
    if startX < 1 then
        startX := 1;
    startY := 4;

    repeat
        clrscr;
        a := ReadInt('Enter A (0..255): ');
        if (a < 0) or (a > 255) then a := a and $FF;
        b := ReadInt('Enter B (0..255): ');
        if (b < 0) or (b > 255) then b := b and $FF;

        ComputeAll(a, b, rAnd, rOr, rXorV, notA, notB);

        clrscr;
        TextBackground(Black);
        TextColor(TitleFG);
        title := 'BITWISE OPERATIONS VISUALIZER';
        GotoXY((ScreenWidth - length(title)) div 2 + 1, 1);
        write(title);

        DrawBitHeader(startY);
        DrawBitRow(startY + 2, 'A', a);
        DrawBitRow(startY + 3, 'B', b);
        DrawBitRow(startY + 5, 'A AND B', rAnd);
        DrawBitRow(startY + 6, 'A OR B', rOr);
        DrawBitRow(startY + 7, 'A XOR B', rXorV);
        DrawBitRow(startY + 9, 'NOT A', notA);
        DrawBitRow(startY + 10, 'NOT B', notB);

        TextBackground(Black);
        TextColor(FrameFG);
        GotoXY(startX, startY + 12);
        write('Green = bit is 1, Blue = bit is 0');

        GotoXY(1, 1);
        write('');
        GotoXY(startX, startY + 14);
        write('Press any key to continue...');
        GetKey;

        clrscr;
        write('Try another pair? (y/n): ');
        readln(again)
    until not ((length(again) > 0) and (upcase(again[1]) = 'Y'));

    clrscr
end;

var
    a, b, code: integer;

begin
    if ParamCount >= 2 then
    begin
        val(ParamStr(1), a, code);
        if code <> 0 then
        begin
            writeln(ErrOutput, 'Invalid number: ', ParamStr(1));
            halt(1)
        end;
        val(ParamStr(2), b, code);
        if code <> 0 then
        begin
            writeln(ErrOutput, 'Invalid number: ', ParamStr(2));
            halt(1)
        end;
        BatchMode(a, b)
    end
    else
        VisualMode
end.
