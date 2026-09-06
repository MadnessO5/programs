unit GeomUnit;                                    { geomunit.pp }

{
  The base geometry subsystem: a single point type and the distance
  between two points. Every name this unit exports is prefixed with
  "Geom", per section 2.14.3's advice -- Pascal has no separate
  namespace for global identifiers, so a shared prefix is how you
  avoid accidental collisions with names some other subsystem
  exports (see PathUnit's "Path" prefix and StatsUnit's "Stats"
  prefix below).

  GeomUnit depends on nothing else in this collection: a one-way
  dependency chain starts here.
}

interface

type
    GeomPoint = record
        x, y: real
    end;

function GeomDistance(a, b: GeomPoint): real;

implementation

function GeomDistance(a, b: GeomPoint): real;
begin
    {$IFDEF DEBUG}
    writeln('DEBUG: GeomDistance from (', a.x:0:2, ',', a.y:0:2,
            ') to (', b.x:0:2, ',', b.y:0:2, ')');
    {$ENDIF}
    GeomDistance := sqrt(sqr(a.x - b.x) + sqr(a.y - b.y))
end;

end.
