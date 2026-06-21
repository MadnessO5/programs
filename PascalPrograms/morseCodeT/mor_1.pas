program MorseEncoder;

{ Type a word in English — it will be transmitted in Morse code }
{ Requires: sudo apt install sox }

uses Crt, SysUtils, Unix;

const
  FREQ    = 700;
  DIT_MS  = 80;
  DAH_MS  = 240;
  SIG_GAP = 80;
  LET_GAP = 240;
  WRD_GAP = 500;

  MORSE_TABLE: array['A'..'Z'] of string = (
    '.-',    { A }
    '-...',  { B }
    '-.-.',  { C }
    '-..',   { D }
    '.',     { E }
    '..-.',  { F }
    '--.',   { G }
    '....',  { H }
    '..',    { I }
    '.---',  { J }
    '-.-',   { K }
    '.-..',  { L }
    '--',    { M }
    '-.',    { N }
    '---',   { O }
    '.--.',  { P }
    '--.-',  { Q }
    '.-.',   { R }
    '...',   { S }
    '-',     { T }
    '..-',   { U }
    '...-',  { V }
    '.--',   { W }
    '-..-',  { X }
    '-.--',  { Y }
    '--..'   { Z }
  );

var
  word  : string;
  again : char;
  i     : integer;
  c     : char;
  morse : string;

procedure PlayTone(ms: integer);
var cmd, d: string;
begin
  Str(ms / 1000.0 : 0 : 3, d);
  cmd := 'play -qn synth ' + d + ' sin ' + IntToStr(FREQ) + ' 2>/dev/null';
  fpSystem(cmd);
end;

procedure PlayMorse(m: string);
var j: integer;
begin
  for j := 1 to Length(m) do
  begin
    if m[j] = '.' then
    begin
      TextColor(LightGreen);
      Write('* ');
      PlayTone(DIT_MS);
      Delay(SIG_GAP);
    end
    else if m[j] = '-' then
    begin
      TextColor(Green);
      Write('--- ');
      PlayTone(DAH_MS);
      Delay(SIG_GAP);
    end;
  end;
end;

procedure DrawHeader;
begin
  ClrScr;
  TextBackground(Black);
  TextColor(Green);
  WriteLn;
  WriteLn('  +------------------------------------------+');
  WriteLn('  |         MORSE CODE TRANSMITTER           |');
  WriteLn('  |                                          |');
  WriteLn('  |   * = dit  (short)   --- = dah  (long)  |');
  WriteLn('  +------------------------------------------+');
  WriteLn;
end;

begin
  repeat
    DrawHeader;

    TextColor(LightGreen);
    Write('  Enter a word: ');
    TextColor(White);
    ReadLn(word);

    if word = '' then
    begin
      TextColor(Green);
      WriteLn('  Empty input! Try again.');
      Delay(1000);
      Continue;
    end;

    DrawHeader;

    { Show letter-to-code table }
    TextColor(LightGreen);
    WriteLn('  Word: ', UpperCase(word));
    WriteLn;

    TextColor(Green);
    WriteLn('  Code table:');
    for i := 1 to Length(word) do
    begin
      c := UpCase(word[i]);
      if (c >= 'A') and (c <= 'Z') then
      begin
        TextColor(Green);      Write('    ', c, '  ->  ');
        TextColor(LightGreen); WriteLn(MORSE_TABLE[c]);
      end;
    end;
    WriteLn;

    TextColor(Green);
    WriteLn('  Transmitting...');
    WriteLn;

    { Play each letter }
    for i := 1 to Length(word) do
    begin
      c := UpCase(word[i]);
      if (c >= 'A') and (c <= 'Z') then
      begin
        morse := MORSE_TABLE[c];

        TextColor(Green);
        Write('  [', c, ']  ');
        PlayMorse(morse);
        WriteLn;

        Delay(LET_GAP);
      end
      else if c = ' ' then
        Delay(WRD_GAP);
    end;

    WriteLn;
    TextColor(LightGreen);
    WriteLn('  >>> Transmission complete! <<<');
    WriteLn;
    TextColor(Green);
    Write('  Transmit again? (Y/N): ');
    again := UpCase(ReadKey);
    WriteLn;

  until again = 'N';

  ClrScr;
  TextColor(LightGreen);
  WriteLn;
  WriteLn('  73 de PASCAL  --  Good bye!');
  TextColor(Green);
  WriteLn('  (73 means "best regards" in ham radio)');
  WriteLn;
  TextColor(White);
end.
