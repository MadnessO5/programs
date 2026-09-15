program DTrigger;                                { dtrigger.pas }
uses crt;

{
  Simulates a positive-edge-triggered D flip-flop: on a clock pulse
  (CLK = 1), Q takes on whatever D currently is; at any other time,
  Q holds its previous value no matter what D does. That's the one
  idea this whole program exists to make visible: Q only ever
  changes AT a clock pulse, never in between.
}

const
    MaxHistory = 10;
    ColorZero = Blue;
    ColorOne  = Green;
    FrameFG   = LightGray;
    TitleFG   = White;
    IndicatorFG = White;

type
    THistEntry = record
        d, clk, q: integer;
    end;

var
    history: array [1..MaxHistory] of THistEntry;
    histCount: integer;
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

procedure PushHistory(d, clk, q: integer);
var
    i: integer;
begin
    {$IFDEF DEBUG}
    writeln(ErrOutput, 'DEBUG: step d=', d, ' clk=', clk, ' -> q=', q);
    {$ENDIF}
    if histCount < MaxHistory then
    begin
        histCount := histCount + 1;
        history[histCount].d := d;
        history[histCount].clk := clk;
        history[histCount].q := q
    end
    else
    begin
        for i := 1 to MaxHistory - 1 do
            history[i] := history[i + 1];
        history[MaxHistory].d := d;
        history[MaxHistory].clk := clk;
        history[MaxHistory].q := q
    end
end;

{ Plain-text simulation, no crt: reads "d clk" pairs from standard
  input (one pair per line) until end of file, and for each line
  prints the resulting Q. Meant for scripting/automated testing. }
procedure BatchMode;
var
    d, clk, q: integer;
begin
    q := 0;
    while not eof do
    begin
        readln(d, clk);
        if clk = 1 then
            q := d;
        writeln(q)
    end
end;

procedure DrawIndicator(x, y: integer; const labelStr: string; value: integer);
var
    color: word;
begin
    TextBackground(Black);
    TextColor(TitleFG);
    GotoXY(x, y);
    write(labelStr, ': ');
    if value = 1 then
        color := ColorOne
    else
        color := ColorZero;
    TextBackground(color);
    TextColor(IndicatorFG);
    write(' ', value, ' ');
    TextBackground(Black)
end;

procedure DrawHistory(x, y: integer);
var
    i: integer;
begin
    TextBackground(Black);
    TextColor(FrameFG);
    GotoXY(x, y);
    write('Step   D   CLK   Q');
    for i := 1 to histCount do
    begin
        GotoXY(x, y + i);
        write(i:4, '   ', history[i].d:1, '    ', history[i].clk:1, '    ', history[i].q:1)
    end;
    for i := histCount + 1 to MaxHistory do
    begin
        GotoXY(x, y + i);
        write('                    ')
    end
end;

procedure VisualMode;
var
    d, q, qBar, key: integer;
    title: string;
    quit: boolean;
begin
    startX := (ScreenWidth - 40) div 2 + 1;
    if startX < 1 then
        startX := 1;
    startY := 4;

    d := 0;
    q := 0;
    histCount := 0;
    quit := false;

    clrscr;
    while not quit do
    begin
        qBar := 1 - q;

        clrscr;
        TextBackground(Black);
        TextColor(TitleFG);
        title := 'D FLIP-FLOP (D-TRIGGER) SIMULATOR';
        GotoXY((ScreenWidth - length(title)) div 2 + 1, 1);
        write(title);

        DrawIndicator(startX, startY, 'D    (input) ', d);
        DrawIndicator(startX, startY + 2, 'Q    (output)', q);
        DrawIndicator(startX, startY + 3, 'Q'#39' bar     ', qBar);

        DrawHistory(startX, startY + 6);

        TextBackground(Black);
        TextColor(FrameFG);
        GotoXY(startX, startY + 6 + MaxHistory + 2);
        write('1 - Toggle D    2 - Pulse clock (CLK edge)    0 - Exit');
        GotoXY(startX, startY + 6 + MaxHistory + 3);
        write('Q only changes when you pulse the clock -- try toggling D');
        GotoXY(startX, startY + 6 + MaxHistory + 4);
        write('several times WITHOUT pulsing, then pulse once.');

        GotoXY(1, 1);
        key := GetKey;

        case key of
            49: begin                          { '1' }
                d := 1 - d;
                PushHistory(d, 0, q)
            end;
            50: begin                          { '2' }
                q := d;
                PushHistory(d, 1, q)
            end;
            48: quit := true                   { '0' }
        end
    end;

    clrscr
end;

begin
    if ParamCount >= 1 then
        BatchMode
    else
        VisualMode
end.
