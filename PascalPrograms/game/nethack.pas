{ ============================================================
  MINIHACK — упрощённый NetHack-подобный roguelike на Pascal
  ============================================================
  Управление (несколько схем одновременно — используйте любую):
    Стрелки           — движение по 4 направлениям
    W A S D           — движение по 4 направлениям
    Numpad 1-9        — движение во все 8 направлений (5 = ждать)
    h j k l y u b n   — движение во все 8 направлений (для любителей vi)
    G / ,             — подобрать предмет
    V                 — выпить зелье (quaff/drink)
    E                 — поесть (eat)
    I                 — инвентарь
    .  или  5         — подождать один ход
    >                 — спуститься по лестнице вниз
    ?                 — помощь по управлению
    Q                 — выйти из игры (с подтверждением)

  Компилируется Free Pascal Compiler (fpc):
      fpc nethack.pas
  Использует юнит crt (доступен в FPC).
============================================================ }
program MiniHack;

uses crt, SysUtils;

const
  MapW = 60;
  MapH = 20;
  MaxMonsters = 15;
  MaxItems = 10;

type
  TTile = (tWall, tFloor, tStairsDown, tDoor);

  TMonster = record
    Alive: Boolean;
    X, Y: Integer;
    Ch: Char;
    Name: string;
    HP, MaxHP, Atk, Def: Integer;
    XPValue: Integer;
  end;

  TItem = record
    Present: Boolean;
    X, Y: Integer;
    Ch: Char;
    Name: string;
    Kind: (ikPotion, ikFood, ikGold, ikWeapon);
    Value: Integer;
  end;

var
  Map: array[0..MapH-1, 0..MapW-1] of TTile;
  Seen: array[0..MapH-1, 0..MapW-1] of Boolean;
  Monsters: array[1..MaxMonsters] of TMonster;
  Items: array[1..MaxItems] of TItem;

  PlayerX, PlayerY: Integer;
  PlayerHP, PlayerMaxHP: Integer;
  PlayerAtk, PlayerDef: Integer;
  PlayerGold: Integer;
  PlayerLevel: Integer;
  PlayerXP, PlayerXPNext: Integer;
  Hunger: Integer;
  DungeonLevel: Integer;
  TurnCount: LongInt;
  Message: string;
  GameOver: Boolean;
  PlayerHasWeaponBonus: Integer;

  InvPotions, InvFood, InvWeapons: Integer;

{ ---------- утилиты ---------- }

procedure SetMsg(const S: string);
begin
  Message := S;
end;

function RndRange(Lo, Hi: Integer): Integer;
begin
  RndRange := Lo + Random(Hi - Lo + 1);
end;

{ ---------- генерация уровня ---------- }

procedure ClearMap;
var
  X, Y: Integer;
begin
  for Y := 0 to MapH-1 do
    for X := 0 to MapW-1 do
    begin
      Map[Y, X] := tWall;
      Seen[Y, X] := False;
    end;
end;

procedure CarveRoom(X1, Y1, X2, Y2: Integer);
var
  X, Y: Integer;
begin
  if X1 < 1 then X1 := 1;
  if Y1 < 1 then Y1 := 1;
  if X2 > MapW-2 then X2 := MapW-2;
  if Y2 > MapH-2 then Y2 := MapH-2;
  for Y := Y1 to Y2 do
    for X := X1 to X2 do
      Map[Y, X] := tFloor;
end;

procedure CarveHTunnel(X1, X2, Y: Integer);
var
  X, XA, XB: Integer;
begin
  if X1 < X2 then begin XA := X1; XB := X2; end
  else begin XA := X2; XB := X1; end;
  for X := XA to XB do
    if (Y >= 0) and (Y < MapH) and (X >= 0) and (X < MapW) then
      Map[Y, X] := tFloor;
end;

procedure CarveVTunnel(Y1, Y2, X: Integer);
var
  Y, YA, YB: Integer;
begin
  if Y1 < Y2 then begin YA := Y1; YB := Y2; end
  else begin YA := Y2; YB := Y1; end;
  for Y := YA to YB do
    if (Y >= 0) and (Y < MapH) and (X >= 0) and (X < MapW) then
      Map[Y, X] := tFloor;
end;

const
  MaxRooms = 8;
var
  RoomCX, RoomCY: array[1..MaxRooms] of Integer;

procedure GenerateLevel;
var
  I, NRooms: Integer;
  RW, RH, RX, RY: Integer;
  CX, CY: Integer;
  M: Integer;
  MonNames: array[1..5] of string;
  MonChars: array[1..5] of Char;
  MonHP: array[1..5] of Integer;
  MonAtk: array[1..5] of Integer;
  MonDef: array[1..5] of Integer;
  MonXP: array[1..5] of Integer;
  Kind: Integer;
begin
  ClearMap;
  NRooms := RndRange(4, MaxRooms);
  for I := 1 to NRooms do
  begin
    RW := RndRange(5, 10);
    RH := RndRange(3, 6);
    RX := RndRange(1, MapW - RW - 2);
    RY := RndRange(1, MapH - RH - 2);
    CarveRoom(RX, RY, RX + RW, RY + RH);
    CX := RX + RW div 2;
    CY := RY + RH div 2;
    RoomCX[I] := CX;
    RoomCY[I] := CY;
    if I > 1 then
    begin
      if Random(2) = 0 then
      begin
        CarveHTunnel(RoomCX[I-1], CX, RoomCY[I-1]);
        CarveVTunnel(RoomCY[I-1], CY, CX);
      end
      else
      begin
        CarveVTunnel(RoomCY[I-1], CY, RoomCX[I-1]);
        CarveHTunnel(RoomCX[I-1], CX, CY);
      end;
    end;
  end;

  { игрок стартует в первой комнате }
  PlayerX := RoomCX[1];
  PlayerY := RoomCY[1];

  { лестница вниз в последней комнате }
  Map[RoomCY[NRooms], RoomCX[NRooms]] := tStairsDown;

  { монстры }
  MonNames[1] := 'крыса';      MonChars[1] := 'r'; MonHP[1] := 4;  MonAtk[1] := 2; MonDef[1] := 0; MonXP[1] := 2;
  MonNames[2] := 'кобольд';    MonChars[2] := 'k'; MonHP[2] := 6;  MonAtk[2] := 3; MonDef[2] := 1; MonXP[2] := 4;
  MonNames[3] := 'гоблин';     MonChars[3] := 'g'; MonHP[3] := 8;  MonAtk[3] := 4; MonDef[3] := 1; MonXP[3] := 6;
  MonNames[4] := 'зомби';      MonChars[4] := 'z'; MonHP[4] := 12; MonAtk[4] := 3; MonDef[4] := 2; MonXP[4] := 8;
  MonNames[5] := 'орк';        MonChars[5] := 'o'; MonHP[5] := 14; MonAtk[5] := 5; MonDef[5] := 2; MonXP[5] := 10;

  for M := 1 to MaxMonsters do
    Monsters[M].Alive := False;

  for M := 1 to RndRange(4, MaxMonsters) do
  begin
    I := RndRange(2, NRooms);
    Kind := RndRange(1, 5);
    Monsters[M].Alive := True;
    Monsters[M].X := RoomCX[I] + RndRange(-1, 1);
    Monsters[M].Y := RoomCY[I] + RndRange(-1, 1);
    if Map[Monsters[M].Y, Monsters[M].X] <> tFloor then
    begin
      Monsters[M].X := RoomCX[I];
      Monsters[M].Y := RoomCY[I];
    end;
    Monsters[M].Ch := MonChars[Kind];
    Monsters[M].Name := MonNames[Kind];
    Monsters[M].MaxHP := MonHP[Kind] + DungeonLevel;
    Monsters[M].HP := Monsters[M].MaxHP;
    Monsters[M].Atk := MonAtk[Kind];
    Monsters[M].Def := MonDef[Kind];
    Monsters[M].XPValue := MonXP[Kind];
  end;

  { предметы }
  for I := 1 to MaxItems do
    Items[I].Present := False;

  for I := 1 to RndRange(3, MaxItems) do
  begin
    M := RndRange(1, NRooms);
    Items[I].Present := True;
    Items[I].X := RoomCX[M] + RndRange(-1, 1);
    Items[I].Y := RoomCY[M] + RndRange(-1, 1);
    if Map[Items[I].Y, Items[I].X] <> tFloor then
    begin
      Items[I].X := RoomCX[M];
      Items[I].Y := RoomCY[M];
    end;
    Kind := RndRange(0, 3);
    case Kind of
      0: begin Items[I].Kind := ikPotion; Items[I].Ch := '!'; Items[I].Name := 'зелье'; Items[I].Value := RndRange(5, 15); end;
      1: begin Items[I].Kind := ikFood;   Items[I].Ch := '%'; Items[I].Name := 'еда';   Items[I].Value := RndRange(10, 25); end;
      2: begin Items[I].Kind := ikGold;   Items[I].Ch := '$'; Items[I].Name := 'золото'; Items[I].Value := RndRange(5, 50); end;
      3: begin Items[I].Kind := ikWeapon; Items[I].Ch := ')'; Items[I].Name := 'оружие'; Items[I].Value := RndRange(1, 4); end;
    end;
  end;
end;

{ ---------- отрисовка ---------- }

procedure UpdateVisibility;
var
  DX, DY, NX, NY: Integer;
begin
  for DY := -6 to 6 do
    for DX := -8 to 8 do
    begin
      NX := PlayerX + DX;
      NY := PlayerY + DY;
      if (NX >= 0) and (NX < MapW) and (NY >= 0) and (NY < MapH) then
        if (DX*DX + DY*DY) <= 64 then
          Seen[NY, NX] := True;
    end;
end;

function MonsterAt(X, Y: Integer): Integer;
var
  I: Integer;
begin
  MonsterAt := 0;
  for I := 1 to MaxMonsters do
    if Monsters[I].Alive and (Monsters[I].X = X) and (Monsters[I].Y = Y) then
    begin
      MonsterAt := I;
      Exit;
    end;
end;

function ItemAt(X, Y: Integer): Integer;
var
  I: Integer;
begin
  ItemAt := 0;
  for I := 1 to MaxItems do
    if Items[I].Present and (Items[I].X = X) and (Items[I].Y = Y) then
    begin
      ItemAt := I;
      Exit;
    end;
end;

procedure DrawScreen;
var
  X, Y, M, IT: Integer;
  C: Char;
begin
  ClrScr;
  for Y := 0 to MapH-1 do
  begin
    GotoXY(1, Y+1);
    for X := 0 to MapW-1 do
    begin
      if not Seen[Y, X] then
      begin
        Write(' ');
        Continue;
      end;
      C := ' ';
      case Map[Y, X] of
        tWall: C := '#';
        tFloor: C := '.';
        tStairsDown: C := '>';
        tDoor: C := '+';
      end;
      IT := ItemAt(X, Y);
      if IT > 0 then C := Items[IT].Ch;
      M := MonsterAt(X, Y);
      if (M > 0) and ((X <> PlayerX) or (Y <> PlayerY)) then C := Monsters[M].Ch;
      if (X = PlayerX) and (Y = PlayerY) then C := '@';
      Write(C);
    end;
  end;

  GotoXY(1, MapH+1);
  Write('HP:', PlayerHP, '/', PlayerMaxHP, '  Ур.персонажа:', PlayerLevel,
        '  Опыт:', PlayerXP, '/', PlayerXPNext,
        '  Золото:', PlayerGold, '  Голод:', Hunger,
        '  Этаж:', DungeonLevel, '  Ход:', TurnCount);
  GotoXY(1, MapH+2);
  Write('> ', Message);
  ClrEol;
  GotoXY(1, MapH+3);
  Write('Инвентарь: зелий=', InvPotions, ' еды=', InvFood, ' оружия=', InvWeapons,
        '  [стрелки/WASD/numpad-движение, G-взять, V-пить, E-есть, >-вниз, ?-помощь, Q-выход]');
  ClrEol;
end;

{ ---------- логика ---------- }

function TileWalkable(X, Y: Integer): Boolean;
begin
  if (X < 0) or (X >= MapW) or (Y < 0) or (Y >= MapH) then
  begin
    TileWalkable := False;
    Exit;
  end;
  TileWalkable := Map[Y, X] <> tWall;
end;

procedure GainXP(Amount: Integer);
begin
  PlayerXP := PlayerXP + Amount;
  while PlayerXP >= PlayerXPNext do
  begin
    PlayerXP := PlayerXP - PlayerXPNext;
    Inc(PlayerLevel);
    PlayerXPNext := PlayerXPNext + 15;
    PlayerMaxHP := PlayerMaxHP + 8;
    PlayerHP := PlayerMaxHP;
    PlayerAtk := PlayerAtk + 1;
    PlayerDef := PlayerDef + 1;
    SetMsg('Вы достигли уровня ' + IntToStr(PlayerLevel) + '! Вы чувствуете прилив сил.');
  end;
end;

procedure MonsterDies(M: Integer);
begin
  SetMsg('Вы убили ' + Monsters[M].Name + '!');
  GainXP(Monsters[M].XPValue);
  Monsters[M].Alive := False;
end;

procedure PlayerAttack(M: Integer);
var
  Dmg: Integer;
begin
  Dmg := PlayerAtk + RndRange(0, 3) + PlayerHasWeaponBonus - Monsters[M].Def;
  if Dmg < 1 then Dmg := 1;
  Monsters[M].HP := Monsters[M].HP - Dmg;
  if Monsters[M].HP <= 0 then
    MonsterDies(M)
  else
    SetMsg('Вы ударили ' + Monsters[M].Name + ' (' + IntToStr(Dmg) + ' урона).');
end;

procedure MonsterAttack(M: Integer);
var
  Dmg: Integer;
begin
  Dmg := Monsters[M].Atk + RndRange(0, 2) - PlayerDef;
  if Dmg < 1 then Dmg := 1;
  PlayerHP := PlayerHP - Dmg;
  SetMsg(Monsters[M].Name + ' атакует вас (' + IntToStr(Dmg) + ' урона)!');
  if PlayerHP <= 0 then
  begin
    PlayerHP := 0;
    GameOver := True;
  end;
end;

procedure MoveMonsters;
var
  I, DX, DY, NX, NY, Dist: Integer;
begin
  for I := 1 to MaxMonsters do
    if Monsters[I].Alive then
    begin
      DX := PlayerX - Monsters[I].X;
      DY := PlayerY - Monsters[I].Y;
      Dist := Abs(DX) + Abs(DY);
      if Dist = 1 then
      begin
        MonsterAttack(I);
        if GameOver then Exit;
      end
      else if (Dist <= 10) and Seen[Monsters[I].Y, Monsters[I].X] then
      begin
        NX := Monsters[I].X;
        NY := Monsters[I].Y;
        if DX > 0 then Inc(NX) else if DX < 0 then Dec(NX);
        if TileWalkable(NX, Monsters[I].Y) and (MonsterAt(NX, Monsters[I].Y) = 0) and
           not ((NX = PlayerX) and (Monsters[I].Y = PlayerY)) then
          Monsters[I].X := NX
        else
        begin
          NY := Monsters[I].Y;
          if DY > 0 then Inc(NY) else if DY < 0 then Dec(NY);
          if TileWalkable(Monsters[I].X, NY) and (MonsterAt(Monsters[I].X, NY) = 0) and
             not ((Monsters[I].X = PlayerX) and (NY = PlayerY)) then
            Monsters[I].Y := NY;
        end;
      end;
    end;
end;

procedure PickUp;
var
  IT: Integer;
begin
  IT := ItemAt(PlayerX, PlayerY);
  if IT = 0 then
  begin
    SetMsg('Здесь ничего нет.');
    Exit;
  end;
  case Items[IT].Kind of
    ikPotion: begin Inc(InvPotions); SetMsg('Вы подобрали зелье.'); end;
    ikFood:   begin Inc(InvFood); SetMsg('Вы подобрали еду.'); end;
    ikWeapon: begin Inc(InvWeapons); PlayerHasWeaponBonus := PlayerHasWeaponBonus + Items[IT].Value;
               SetMsg('Вы подобрали оружие (+' + IntToStr(Items[IT].Value) + ' атаки).'); end;
    ikGold:   begin PlayerGold := PlayerGold + Items[IT].Value;
               SetMsg('Вы подобрали ' + IntToStr(Items[IT].Value) + ' золота.'); end;
  end;
  Items[IT].Present := False;
end;

procedure QuaffPotion;
var
  Heal: Integer;
begin
  if InvPotions <= 0 then
  begin
    SetMsg('У вас нет зелий.');
    Exit;
  end;
  Dec(InvPotions);
  Heal := RndRange(8, 20);
  PlayerHP := PlayerHP + Heal;
  if PlayerHP > PlayerMaxHP then PlayerHP := PlayerMaxHP;
  SetMsg('Вы выпили зелье и восстановили ' + IntToStr(Heal) + ' HP.');
end;

procedure EatFood;
begin
  if InvFood <= 0 then
  begin
    SetMsg('У вас нет еды.');
    Exit;
  end;
  Dec(InvFood);
  Hunger := Hunger + RndRange(150, 300);
  if Hunger > 1000 then Hunger := 1000;
  SetMsg('Вы поели. Уже не так голодно.');
end;

procedure GoDownStairs;
begin
  if Map[PlayerY, PlayerX] <> tStairsDown then
  begin
    SetMsg('Здесь нет лестницы вниз.');
    Exit;
  end;
  Inc(DungeonLevel);
  GenerateLevel;
  SetMsg('Вы спускаетесь на этаж ' + IntToStr(DungeonLevel) + '.');
end;

procedure TryMove(DX, DY: Integer);
var
  NX, NY, M: Integer;
begin
  NX := PlayerX + DX;
  NY := PlayerY + DY;
  M := MonsterAt(NX, NY);
  if M > 0 then
  begin
    PlayerAttack(M);
    Exit;
  end;
  if TileWalkable(NX, NY) then
  begin
    PlayerX := NX;
    PlayerY := NY;
  end
  else
    SetMsg('Путь преграждает стена.');
end;

procedure NextTurn;
begin
  Inc(TurnCount);
  Dec(Hunger);
  if Hunger <= 0 then
  begin
    Hunger := 0;
    PlayerHP := PlayerHP - 1;
    SetMsg('Вы умираете от голода!');
    if PlayerHP <= 0 then
    begin
      PlayerHP := 0;
      GameOver := True;
      Exit;
    end;
  end
  else if Hunger < 100 then
    SetMsg('Вы проголодались.');
  if not GameOver then
    MoveMonsters;
end;

{ ---------- главный цикл ---------- }

procedure InitPlayer;
begin
  PlayerHP := 30;
  PlayerMaxHP := 30;
  PlayerAtk := 3;
  PlayerDef := 1;
  PlayerGold := 0;
  PlayerLevel := 1;
  PlayerXP := 0;
  PlayerXPNext := 20;
  Hunger := 800;
  DungeonLevel := 1;
  TurnCount := 0;
  InvPotions := 0;
  InvFood := 0;
  InvWeapons := 0;
  PlayerHasWeaponBonus := 0;
  GameOver := False;
end;

procedure ShowIntro;
begin
  ClrScr;
  GotoXY(1,1);
  WriteLn('=========================================');
  WriteLn('   M I N I H A C K   (Pascal / NetHack)   ');
  WriteLn('=========================================');
  WriteLn;
  WriteLn('Вы спускаетесь в подземелье в поисках славы и золота.');
  WriteLn('Дойдите как можно глубже, побеждая монстров и собирая сокровища.');
  WriteLn;
  WriteLn('Управление (используйте любую удобную схему):');
  WriteLn('  Стрелки, WASD, numpad(1-9) или h j k l y u b n — движение во все стороны');
  WriteLn('  G или , — подобрать предмет      V — выпить зелье');
  WriteLn('  E — поесть                       . или numpad 5 — подождать');
  WriteLn('  I — инвентарь                    > — спуститься по лестнице');
  WriteLn('  ? — помощь по управлению         Q — выйти из игры (с подтверждением)');
  WriteLn;
  Write('Нажмите любую клавишу, чтобы начать...');
  ReadKey;
end;

procedure ShowHelp;
begin
  ClrScr;
  GotoXY(1,1);
  WriteLn('================ ПОМОЩЬ ================');
  WriteLn;
  WriteLn(' Движение (любая из схем работает):');
  WriteLn('   Стрелки        - вверх/вниз/влево/вправо');
  WriteLn('   W A S D        - вверх/влево/вниз/вправо');
  WriteLn('   Numpad 7 8 9   - диагонали и вверх');
  WriteLn('   Numpad 4 5 6   - влево / ждать / вправо');
  WriteLn('   Numpad 1 2 3   - диагонали и вниз');
  WriteLn('   y u          ');
  WriteLn('   h   l          - vi-стиль (как в NetHack)');
  WriteLn('   b n            ');
  WriteLn;
  WriteLn(' Действия:');
  WriteLn('   G или ,   - подобрать предмет под ногами');
  WriteLn('   V         - выпить зелье (лечит HP)');
  WriteLn('   E         - поесть (снимает голод)');
  WriteLn('   I         - показать инвентарь');
  WriteLn('   . или 5   - подождать один ход на месте');
  WriteLn('   >         - спуститься по лестнице вниз');
  WriteLn('   ?         - эта справка');
  WriteLn('   Q         - выйти из игры (спросит подтверждение)');
  WriteLn;
  WriteLn(' Нажмите любую клавишу, чтобы вернуться в игру...');
  ReadKey;
end;

function ConfirmQuit: Boolean;
var
  K: Char;
begin
  GotoXY(1, MapH+2);
  ClrEol;
  Write('> Точно выйти из игры? (y/n)');
  ClrEol;
  K := ReadKey;
  ConfirmQuit := (K = 'y') or (K = 'Y') or (K = 'д') or (K = 'Д');
end;

procedure ShowGameOver;
begin
  ClrScr;
  GotoXY(1,1);
  WriteLn('=========================================');
  WriteLn('              ВЫ ПОГИБЛИ                  ');
  WriteLn('=========================================');
  WriteLn;
  WriteLn('Вы достигли этажа ', DungeonLevel, ' на ', PlayerLevel, ' уровне персонажа.');
  WriteLn('Собрано золота: ', PlayerGold);
  WriteLn('Сделано ходов: ', TurnCount);
  WriteLn;
  WriteLn('Покойся с миром, искатель приключений.');
end;

var
  Key: Char;
  Extended: Char;

begin
  Randomize;
  ShowIntro;
  InitPlayer;
  GenerateLevel;
  SetMsg('Добро пожаловать в подземелье! Да пребудет с вами удача.');

  while not GameOver do
  begin
    UpdateVisibility;
    DrawScreen;
    Key := ReadKey;

    { --- расширенные (двухбайтовые) коды: стрелки и numpad при выключенном NumLock --- }
    if Key = #0 then
    begin
      Extended := ReadKey;
      case Extended of
        #72: begin TryMove(0, -1); NextTurn; end;   { стрелка вверх }
        #80: begin TryMove(0, 1);  NextTurn; end;   { стрелка вниз }
        #75: begin TryMove(-1, 0); NextTurn; end;   { стрелка влево }
        #77: begin TryMove(1, 0);  NextTurn; end;   { стрелка вправо }
        #71: begin TryMove(-1, -1); NextTurn; end;  { numpad 7 / Home }
        #73: begin TryMove(1, -1);  NextTurn; end;  { numpad 9 / PgUp }
        #79: begin TryMove(-1, 1);  NextTurn; end;  { numpad 1 / End }
        #81: begin TryMove(1, 1);   NextTurn; end;  { numpad 3 / PgDn }
        #76: begin SetMsg('Вы ждёте.'); NextTurn; end; { numpad 5 }
      end;
      Continue;
    end;

    case Key of
      { --- стрелки на терминалах, где приходят как ESC-последовательности, здесь не нужны:
            crt.ReadKey отдаёт arrow keys как #0 + код выше --- }

      { движение: WASD }
      'w', 'W': begin TryMove(0, -1); NextTurn; end;
      's', 'S': begin TryMove(0, 1);  NextTurn; end;
      'a', 'A': begin TryMove(-1, 0); NextTurn; end;
      'd', 'D': begin TryMove(1, 0);  NextTurn; end;

      { движение: numpad как обычные цифры (если NumLock включён) }
      '8': begin TryMove(0, -1);  NextTurn; end;
      '2': begin TryMove(0, 1);   NextTurn; end;
      '4': begin TryMove(-1, 0);  NextTurn; end;
      '6': begin TryMove(1, 0);   NextTurn; end;
      '7': begin TryMove(-1, -1); NextTurn; end;
      '9': begin TryMove(1, -1);  NextTurn; end;
      '1': begin TryMove(-1, 1);  NextTurn; end;
      '3': begin TryMove(1, 1);   NextTurn; end;
      '5': begin SetMsg('Вы ждёте.'); NextTurn; end;

      { движение: классический vi-стиль (как в оригинальном NetHack) }
      'h': begin TryMove(-1, 0);  NextTurn; end;
      'l': begin TryMove(1, 0);   NextTurn; end;
      'k': begin TryMove(0, -1);  NextTurn; end;
      'j': begin TryMove(0, 1);   NextTurn; end;
      'y': begin TryMove(-1, -1); NextTurn; end;
      'u': begin TryMove(1, -1);  NextTurn; end;
      'b': begin TryMove(-1, 1);  NextTurn; end;
      'n': begin TryMove(1, 1);   NextTurn; end;

      { подождать }
      '.': begin SetMsg('Вы ждёте.'); NextTurn; end;

      { действия }
      'g', 'G', ',': begin PickUp; NextTurn; end;
      'v', 'V': begin QuaffPotion; NextTurn; end;
      'e', 'E': begin EatFood; NextTurn; end;
      '>': begin GoDownStairs; NextTurn; end;
      'i', 'I': begin
             SetMsg('Зелий: ' + IntToStr(InvPotions) + ', Еды: ' + IntToStr(InvFood) +
                     ', Оружия: ' + IntToStr(InvWeapons));
           end;
      '?': ShowHelp;
      'q', 'Q': begin
             if ConfirmQuit then GameOver := True;
           end;
    end;
  end;

  ShowGameOver;
end.
