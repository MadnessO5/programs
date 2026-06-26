program ReadLongintDemo;

{ ============================================================
  Demonstrates the ReadLongint procedure.
  It reads a number character by character from stdin,
  skips leading spaces, and reports exactly which position
  had a bad character instead of just crashing.

  Compile: fpc ReadLongintDemo.pas
  ============================================================ }

{ ----------------------------------------------------------
  ReadLongint
  Reads one integer from the current line of stdin.
    success = true  --> result holds the number
    success = false --> bad character was found (already reported)
  ---------------------------------------------------------- }

procedure ReadLongint(var success: boolean; var result: longint);
var
  c  : char;
  res: longint;
  pos: integer;
begin
  res := 0;
  pos := 0;

  { Skip leading spaces and stop at newline }
  repeat
    read(c);
    pos := pos + 1
  until (c <> ' ') and (c <> #10);

  { Read digits until space or newline }
  while (c <> ' ') and (c <> #10) do
  begin
    if (c < '0') or (c > '9') then
    begin
      writeln('Unexpected ''', c, '''' , ' in pos: ', pos);
      readln;
      success := false;
      exit
    end;
    res := res * 10 + ord(c) - ord('0');
    read(c);
    pos := pos + 1
  end;

  result  := res;
  success := true
end;

{ ----------------------------------------------------------
  TryReadNumber
  Wraps ReadLongint with a retry loop and a prompt.
  Returns true when a valid number was read.
  ---------------------------------------------------------- }

function TryReadNumber(const prompt: string; var num: longint): boolean;
var
  ok: boolean;
begin
  ok := false;
  while not ok do
  begin
    write(prompt);
    ReadLongint(ok, num);
    if not ok then
      writeln('  Please try again, digits only.')
  end;
  TryReadNumber := true
end;

{ ----------------------------------------------------------
  Main program
  Reads two numbers and shows basic operations on them.
  ---------------------------------------------------------- }

var
  a, b : longint;
  ok   : boolean;

begin
  writeln('========================================');
  writeln('  ReadLongint demo');
  writeln('  Enter digits only. Any other character');
  writeln('  will be reported with its position.');
  writeln('========================================');
  writeln;

  { --- read first number with retry --- }
  TryReadNumber('Enter first number : ', a);

  { --- read second number with retry --- }
  TryReadNumber('Enter second number: ', b);

  { --- show results --- }
  writeln;
  writeln('----------------------------------------');
  writeln('  a         = ', a);
  writeln('  b         = ', b);
  writeln('  a + b     = ', a + b);
  writeln('  a - b     = ', a - b);
  writeln('  a * b     = ', a * b);

  if b = 0 then
    writeln('  a div b   = (division by zero, skipped)')
  else
  begin
    writeln('  a div b   = ', a div b);
    writeln('  a mod b   = ', a mod b)
  end;

  writeln('----------------------------------------');
  writeln;

  { --- one more demo: single call without retry --- }
  writeln('Now try typing something with a letter in it.');
  write('Enter a number: ');
  ReadLongint(ok, a);
  if ok then
    writeln('Got: ', a)
  else
    writeln('ReadLongint returned success=false, no number stored.');

  writeln;
  writeln('Press Enter to quit...');
  readln
end.
