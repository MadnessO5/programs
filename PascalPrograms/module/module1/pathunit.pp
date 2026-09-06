unit PathUnit;                                    { pathunit.pp }

{
  A path is a sequence of geometry points -- so this unit's own
  interface has to mention GeomUnit's GeomPoint type directly
  (PathArray below is an array of GeomPoint). That means the "uses
  GeomUnit" has to go in THIS unit's interface section, not just its
  implementation (see section 2.14.2) -- and it also means PathUnit
  is coupled to GeomUnit by *data*, the strongest and most
  caution-worthy kind of coupling discussed in section 2.14.4: any
  change to GeomPoint's layout would ripple through PathArray and
  everything built on it. It's unavoidable here, though -- a path
  genuinely cannot be described without referring to points.

  Every exported name is prefixed "Path", per section 2.14.3.
}

interface

uses
    GeomUnit;

const
    PathMaxPoints = 100;

type
    PathArray = array [1..PathMaxPoints] of GeomPoint;

function PathLength(const pts: PathArray; count: integer): real;

implementation

function PathLength(const pts: PathArray; count: integer): real;
var
    i: integer;
    total: real;
begin
    total := 0;
    for i := 1 to count - 1 do
        total := total + GeomDistance(pts[i], pts[i + 1]);
    PathLength := total
end;

end.
