program GeomDemo;                                  { geomdemo.pas }

{
  Uses PathUnit and StatsUnit, but never GeomUnit directly -- and
  yet it freely reads/writes the "x"/"y" fields of GeomPoint values
  stored inside a PathArray, without ever naming "GeomPoint" itself.
  That's because PathUnit's interface already pulled GeomUnit's
  types in; this program just works structurally with whatever
  PathArray's elements happen to contain, field by field, without
  needing to spell out the element type's name.

  Note this is NOT the same as saying GeomUnit's identifiers become
  automatically nameable here: writing "var p: GeomPoint;" directly
  in this program would still fail to compile without adding
  "uses GeomUnit" here too. Structural use (through PathArray) works
  without it; naming the type directly does not.
}

uses
    PathUnit, StatsUnit;

var
    pts: PathArray;
    n, i: integer;

begin
    write('How many points? ');
    readln(n);
    for i := 1 to n do
    begin
        write('Point ', i, ' x y: ');
        readln(pts[i].x, pts[i].y)
    end;

    writeln('Total path length: ', PathLength(pts, n):0:3);
    writeln('Rounded distance from point 1 to point ', n, ': ',
             StatsRoundedDistance(pts[1].x, pts[1].y, pts[n].x, pts[n].y))
end.
