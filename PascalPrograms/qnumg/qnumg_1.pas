program GuessTheNumber;

var
  secret   : integer;
  guess    : integer;
  attempts : integer;
  again    : char;
  low      : integer;
  high     : integer;
  record_  : integer;
  total    : integer;
  wins     : integer;

procedure PrintLine;
begin
  WriteLn('----------------------------------------');
end;

procedure PrintHeader;
begin
  PrintLine;
  WriteLn('         GUESS THE NUMBER (1 - 100)');
  PrintLine;
end;

procedure PrintStats;
begin
  PrintLine;
  WriteLn('  Games played : ', total);
  WriteLn('  Wins         : ', wins);
  if record_ > 0 then
    WriteLn('  Best result  : ', record_, ' attempts')
  else
    WriteLn('  Best result  : -');
  PrintLine;
end;

function GetRating(att: integer): string;
begin
  if att <= 5 then
    GetRating := 'Excellent! Are you a psychic?'
  else if att <= 8 then
    GetRating := 'Good job!'
  else if att <= 12 then
    GetRating := 'Not bad, keep practicing.'
  else
    GetRating := 'That was rough... try again!';
end;

procedure GiveHint(g, s, lo, hi: integer);
begin
  if g < s then
  begin
    WriteLn('  Too low!  (range: ', lo, ' - ', hi, ')');
  end
  else if g > s then
  begin
    WriteLn('  Too high! (range: ', lo, ' - ', hi, ')');
  end
  else
  begin
    WriteLn('  CORRECT!!!');
  end;
end;

procedure UpdateRecord(att: integer);
begin
  if (record_ = 0) or (att < record_) then
    record_ := att;
end;

procedure CheckInput(var g: integer; lo, hi: integer; var ok: boolean);
begin
  ok := true;
  if g < 1 then
  begin
    WriteLn('  Number must be at least 1!');
    ok := false;
  end
  else if g > 100 then
  begin
    WriteLn('  Number must be at most 100!');
    ok := false;
  end
  else if g < lo then
  begin
    WriteLn('  You already know it is higher than ', lo - 1, '!');
    ok := false;
  end
  else if g > hi then
  begin
    WriteLn('  You already know it is lower than ', hi + 1, '!');
    ok := false;
  end;
end;

var
  inputOk : boolean;

begin
  Randomize;
  record_ := 0;
  total   := 0;
  wins    := 0;

  PrintHeader;
  WriteLn('  I am thinking of a number between 1 and 100.');
  WriteLn('  Try to guess it!');
  WriteLn;

  repeat
    secret   := Random(100) + 1;
    attempts := 0;
    low      := 1;
    high     := 100;

    WriteLn('  Number is set. Let''s go!');
    PrintLine;

    repeat
      attempts := attempts + 1;

      Write('  Attempt ', attempts, ' [', low, '-', high, ']: ');
      Read(guess);

      CheckInput(guess, low, high, inputOk);

      if not inputOk then
      begin
        attempts := attempts - 1;
        Continue;
      end;

      GiveHint(guess, secret, low, high);

      if guess < secret then
        low := guess + 1;
      if guess > secret then
        high := guess - 1;

    until guess = secret;

    total := total + 1;
    wins  := wins + 1;

    UpdateRecord(attempts);

    PrintLine;
    WriteLn('  You got it in ', attempts, ' attempts!');
    WriteLn('  Rating: ', GetRating(attempts));
    PrintStats;

    Write('  Play again? (Y/N): ');
    Read(again);
    again := UpCase(again);
    WriteLn;

  until again = 'N';

  WriteLn;
  WriteLn('  Thanks for playing!');
  PrintStats;
end.
