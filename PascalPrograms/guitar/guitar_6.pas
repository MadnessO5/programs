program GuitarSimulator;

uses Crt, SysUtils, Unix;

const
  { Названия струн (от толстой к тонкой) }
  StringNames: array[1..6] of string = ('E2', 'A2', 'B2', 'G3', 'B3', 'E4');

  { Ноты для каждой струны на ладах 0..12 }
  Notes: array[1..6, 0..12] of string = (
    ('E2','F2','F#2','G2','G#2','A2','A#2','B2','C3','C#3','D3','D#3','E3'),
    ('A2','A#2','B2','C3','C#3','D3','D#3','E3','F3','F#3','G3','G#3','A3'),
    ('D2','D#2','E2','F2','F#2','G2','G#2','A2','A#2','B2','C3','C#3','D3'),
    ('G2','G#2','A2','A#2','B2','C3','C#3','D3','D#3','E3','F3','F#3','G3'),
    ('B2','C3','C#3','D3','D#3','E3','F3','F#3','G3','G#3','A3','A#3','B3'),
    ('E3','F3','F#3','G3','G#3','A3','A#3','B3','C4','C#4','D4','D#4','E4')
  );

  { Клавиши для струн (открытые) }
  OpenKeys:  array[1..6] of Char = ('1','2','3','4','5','6');

  { Клавиши для ладов (q..i = лады 1..8, затем 9,0,-,=) }
  FretKeys: array[1..12] of Char =
    ('Q','W','E','R','T','Y','U','I','O','P','[',']');

var
  currentFret: integer;   { текущий лад 0..12 }
  ch: Char;
  s, f: integer;
  played: boolean;

procedure DrawNeck;
var i, j: integer;
begin
  ClrScr;
  TextColor(Yellow);
  WriteLn('╔══════════════════════════════════════════════════════════════╗');
  WriteLn('║          🎸  PASCAL GUITAR SIMULATOR  🎸                    ║');
  WriteLn('╚══════════════════════════════════════════════════════════════╝');
  WriteLn;

  { Лады сверху }
  TextColor(Cyan);
  Write('  Лад:  [0] ');
  for j := 1 to 12 do
    Write(' [', j:2, ']');
  WriteLn;

  TextColor(LightGray);
  WriteLn('        ----+----+----+----+----+----+----+----+----+----+----+----+----');

  { Струны }
  for i := 1 to 6 do
  begin
    TextColor(LightGreen);
    Write(' ', OpenKeys[i], '-', StringNames[i], ': ');
    TextColor(White);
    for j := 0 to 12 do
    begin
      if j = currentFret then
      begin
        TextColor(LightRed);
        Write('[', Notes[i][j]:4, ']');
        TextColor(White);
      end
      else
        Write(' ', Notes[i][j]:4, ' ');
    end;
    WriteLn;
    TextColor(LightGray);
    WriteLn('        ----+----+----+----+----+----+----+----+----+----+----+----+----');
  end;

  WriteLn;
  TextColor(LightCyan);
  WriteLn('  УПРАВЛЕНИЕ:');
  TextColor(White);
  WriteLn('  Струны (открытые): 1 2 3 4 5 6');
  WriteLn('  Лады 1-12:         Q W E R T Y U I O P [ ]');
  WriteLn('  Сбросить лад (0):  Z');
  WriteLn('  Выход:             ESC');
  WriteLn;
  TextColor(Yellow);
  Write('  Текущий лад: ');
  TextColor(LightRed);
  Write(currentFret);
  TextColor(White);
  WriteLn;
end;

function NoteFreq(str: integer; fret: integer): integer;
const
  BaseFreq: array[1..6] of double = (82.41, 110.00, 146.83, 196.00, 246.94, 329.63);
var
  freq: double;
begin
  freq := BaseFreq[str] * exp(fret * ln(2) / 12);
  NoteFreq := Round(freq);
end;

procedure PlayString(str: integer; fret: integer);
var
  freq: integer;
  cmd: string;
begin
  TextColor(Yellow);
  GotoXY(1, 23);
  Write('  ♪ Струна ', StringNames[str], ' лад ', fret,
        ' → нота: ', Notes[str][fret], '          ');
  freq := NoteFreq(str, fret);
  { play из пакета sox — звук типа "щипок струны" }
  cmd := 'play -qn synth 0.4 pluck ' + IntToStr(freq) + ' 2>/dev/null &';
  fpSystem(cmd);
end;

begin
  currentFret := 0;
  DrawNeck;

  repeat
    ch := ReadKey;
    ch := UpCase(ch);
    played := false;

    { Проверяем нажатие клавиш струн }
    for s := 1 to 6 do
      if ch = OpenKeys[s] then
      begin
        PlayString(s, currentFret);
        played := true;
      end;

    { Проверяем нажатие клавиш ладов }
    for f := 1 to 12 do
      if ch = FretKeys[f] then
      begin
        currentFret := f;
        DrawNeck;
        played := true;
      end;

    { Сброс лада }
    if ch = 'Z' then
    begin
      currentFret := 0;
      DrawNeck;
    end;

  until ch = #27; { ESC }

  ClrScr;
  TextColor(White);
  WriteLn('До свидания, музыкант! 🎸');
end.
