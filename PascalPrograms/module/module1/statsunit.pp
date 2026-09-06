unit StatsUnit;                                    { statsunit.pp }

{
  Contrast this with PathUnit: StatsRoundedDistance's parameters and
  return type are all plain "real"/"longint" -- nothing here needs
  GeomUnit's GeomPoint type to be visible in the interface. GeomUnit
  is only needed to do the actual computation internally, so its
  "uses" goes after "implementation" instead, per the simple case
  described in section 2.14.2.

  This means StatsUnit's dependency on GeomUnit is *call coupling*
  only (it calls GeomDistance, nothing more) -- per section 2.14.4,
  this is the weaker, more desirable kind of coupling, compared to
  PathUnit's unavoidable data coupling above. Every exported name
  here is prefixed "Stats".
}

interface

function StatsRoundedDistance(x1, y1, x2, y2: real): longint;

implementation

uses
    GeomUnit;

function StatsRoundedDistance(x1, y1, x2, y2: real): longint;
var
    a, b: GeomPoint;
begin
    a.x := x1;
    a.y := y1;
    b.x := x2;
    b.y := y2;
    StatsRoundedDistance := round(GeomDistance(a, b))
end;

end.

