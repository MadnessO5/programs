program AsciiArtGallery;

uses Crt;

const
  MAX_ART = 2;

type
  TArt = record
    Name: string[50];
    Art: array[1..30] of string[100];
    Lines: integer;
  end;

var
  Arts: array[1..MAX_ART] of TArt;
  Choice: integer;

procedure FillArts;
begin
  Arts[1].Name := 'Stalin';
  Arts[1].Lines := 18;
  Arts[1].Art[1] := '⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣶⣶⣿⣿⣿⣷⣶⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀';
  Arts[1].Art[2] := '⠀⠀⠀⠀⠀⠀⠀⣰⣾⠟⣿⢻⣿⠿⣿⣿⣿⣿⣟⣙⢿⣿⣦⠀⠀⠀⠀⠀⠀⠀';
  Arts[1].Art[3] := '⠀⠀⠀⠀⠀⠀⢠⣿⣴⡾⠾⠿⢿⣿⣿⣿⣿⣿⣿⣿⣶⡏⢿⣷⡀⠀⠀⠀⠀⠀';
  Arts[1].Art[4] := '⠀⠀⠀⠀⠀⠀⢸⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⣷⣾⣿⣇⠀⠀⠀⠀⠀';
  Arts[1].Art[5] := '⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⡜⢿⣿⠀⠀⠀⠀⠀';
  Arts[1].Art[6] := '⠀⠀⠀⠀⠀⠀⢸⢧⡴⠶⢤⣤⠀⠀⣠⡴⣶⠿⢶⡆⠀⠀⢸⡞⡿⠀⠀⠀⠀⠀';
  Arts[1].Art[7] := '⠀⠀⠀⠀⠀⠀⢸⠈⠰⠿⢻⣿⠀⠀⢻⣿⠾⣿⠶⡅⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀';
  Arts[1].Art[8] := '⠀⠀⠀⠀⠀⠀⣾⠀⠀⠀⠛⢁⠀⠀⠀⣉⠙⠒⠋⠀⠀⠀⠀⠻⢺⠀⠀⠀⠀⠀';
  Arts[1].Art[9] := '⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⣰⠧⢠⡤⠠⡹⣷⡀⠀⠀⠀⠀⠀⣹⢸⠀⠀⠀⠀⠀';
  Arts[1].Art[10] := '⠀⠀⠀⠀⠀⠀⣿⠀⠀⠔⣡⣶⣾⣿⣷⣷⣾⡻⠀⠀⠀⠀⠀⢡⠃⠀⠀⠀⠀⠀';
  Arts[1].Art[11] := '⠀⠀⠀⠀⠀⠀⠈⡆⣠⣾⣿⡿⠿⠿⢿⣿⣿⣿⣦⡀⠀⠀⢸⠁⠀⠀⠀⠀⠀⠀';
  Arts[1].Art[12] := '⠀⠀⠀⠀⠀⠀⠀⠱⡀⠙⠁⠀⠸⠿⠿⠇⠈⠀⠀⠀⠀⢀⠃⠀⠀⠀⠀⠀⠀⠀';
  Arts[1].Art[13] := '⠀⠀⠀⠀⠀⠀⠀⢀⣷⣄⣀⠀⠀⣠⣄⡀⠀⠀⠀⠀⠀⢸⡀⠀⠀⠀⠀⠀⠀⠀';
  Arts[1].Art[14] := '⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⡿⡛⠛⠻⣿⣿⠖⠈⠁⠀⢀⣾⣷⣀⠀⠀⠀⠀⠀⠀';
  Arts[1].Art[15] := '⠀⢀⣀⣤⣴⣺⣿⣿⣿⣿⣿⣿⣢⢀⠸⢿⡄⠀⢀⣠⣿⣿⣿⣿⣿⣶⣦⣤⣀⠀';
  Arts[1].Art[16] := '⠺⢿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣢⣧⣰⣿⣿⣿⢯⣻⢿⣿⣿⣿⣿⣿⠗';
  Arts[1].Art[17] := '⠀⠀⠙⠿⢿⣿⣿⣿⡿⣠⣸⣟⣿⣿⣿⠎⣿⣿⣿⣿⣿⣸⣬⡇⣿⣿⡿⠛⠉⠀';
  Arts[1].Art[18] := '⠀⠀⠀⠀⠀⠀⠉⠛⠿⣿⣿⣿⣾⡿⢋⣾⡛⣿⣿⣿⡇⣿⣿⡇⡿⠁⠀⠀⠀⠀';

  Arts[2].Name := 'Boykisser';
  Arts[2].Lines := 13;
  Arts[2].Art[1] := '⠀⠀⡔⠉⠑⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⠋⠉⠉⠓⡆⠀⠀';
  Arts[2].Art[2] := '⠀⣸⠁⠀⠀⠀⠙⢦⡀⢸⡉⠓⠲⣄⡀⢀⡞⠀⠀⠀⠀⣀⣽⡤⠀';
  Arts[2].Art[3] := '⠀⡇⠀⠀⠀⠀⠀⠀⠙⣦⠷⠄⠀⠀⠙⠞⠀⠀⠀⠀⠀⠒⠚⡏⠁';
  Arts[2].Art[4] := '⠀⡇⠀⠀⠀⠀⣀⣀⡚⠓⠒⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀';
  Arts[2].Art[5] := '⠀⡇⠀⠀⠀⡎⠀⠀⠈⡆⠀⠀⠀⠀⠘⢄⣀⣀⡀⠀⠀⠀⣸⠁⠀';
  Arts[2].Art[6] := '⠀⠈⣇⠀⠐⡶⠖⣲⣶⡆⠀⠀⠀⠀⣶⣶⡒⠲⡒⠀⢀⡼⠁⠀⠀';
  Arts[2].Art[7] := '⠰⣖⠺⠧⢸⠁⠀⣿⣿⠇⠀⠀⠀⠀⣿⣿⠇⠀⡇⠀⠉⣩⠇⠀⠀';
  Arts[2].Art[8] := '⠀⠈⣳⠀⣨⢃⠀⠈⠉⠀⠒⠂⠀⠀⠈⠁⢀⠄⡡⠀⢼⡁⠀⠀⠀';
  Arts[2].Art[9] := '⠀⢰⣃⣈⣀⠁⠀⠀⠀⠦⠔⠓⠲⡲⠃⠀⠀⢈⣀⣀⣀⣹⡄⠀⠀';
  Arts[2].Art[10] := '⠀⠀⠀⠀⠀⠉⢳⠲⠤⢄⣀⣀⣀⣠⢶⠒⣏⠉⠀⠀⠀⠀⠀⠀⠀';
  Arts[2].Art[11] := '⠀⠀⠀⠀⠀⠀⠈⣳⠒⢲⠋⢱⠤⠧⠚⠋⠘⡆⠀⠀⠀⠀⠀⠀⠀';
  Arts[2].Art[12] := '⠀⠀⠀⠀⠀⠀⠘⠓⡆⠈⠒⠁⠀⠀⠀⠀⠀⢹⡀⠀⠀⠀⠀⠀⠀';
  Arts[2].Art[13] := '⠀⠀⠀⠀⠀⠀⠀⣼⣁⣀⣀⣀⣀⣀⣀⣀⣀⣀⡇⠀⠀⠀⠀⠀⠀';
end;

procedure ShowArt(num: integer);
var
  k: integer;
begin
  ClrScr;
  TextColor(14);
  Writeln('╔════════════════════════════════════════╗');
  Writeln('║         ', Arts[num].Name);
  Writeln('╚════════════════════════════════════════╝');
  TextColor(11);
  Writeln;
  
  for k := 1 to Arts[num].Lines do
    Writeln(Arts[num].Art[k]);
  
  TextColor(10);
  Writeln;
  Writeln('ГОЙДААААА');
  TextColor(15);
  Writeln;
  Writeln('Press Enter...');
  Readln;
end;

procedure ShowMenu;
begin
  ClrScr;
  TextColor(14);
  Writeln('╔════════════════════════════════════════╗');
  Writeln('║                  ГОЙДА                 ║');
  Writeln('╚════════════════════════════════════════╝');
  TextColor(15);
  Writeln;
  Writeln('CHOSE');
  Writeln;
  
  TextColor(11);
  Writeln('  1. ');
  Writeln('  2. ');
  TextColor(12);
  Writeln('  0. exit ');
  
  TextColor(15);
  Writeln;
  Write('Ya: ');
end;

begin
  FillArts;
  
  repeat
    ShowMenu;
    Readln(Choice);
    
    if (Choice >= 1) and (Choice <= MAX_ART) then
      ShowArt(Choice)
    else if Choice = 0 then
    begin
      ClrScr;
      TextColor(14);
      Writeln('PENIS');
      TextColor(15);
      Readln;
    end
    else
    begin
      TextColor(12);
      Writeln('ONLY 1 2');
      TextColor(15);
      Writeln('Press Enter...');
      Readln;
    end;
  until Choice = 0;
end.
