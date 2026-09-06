GeomDemo: GeomUnit + PathUnit + StatsUnit

Three small, deliberately-contrasted units demonstrating sections 2.14.2, 2.14.3, and 2.14.4.

FILES

- geomunit.pp -- the base subsystem: a GeomPoint record and GeomDistance between two points. Depends on nothing else here.
- pathunit.pp -- a path (sequence of points) and its total length. Needs GeomUnit in its own interface, since PathArray is defined as an array of GeomPoint.
- statsunit.pp -- a distance calculation that only exposes plain numbers (real/longint) in its interface. Needs GeomUnit only internally, to do the actual computation.
- geomdemo.pas -- reads a list of points interactively and reports the total path length and the rounded distance between the first and last point.

ONE PHRASE PER MODULE (section 2.14.3's test)

- GeomUnit: "represents a 2D point and the distance between two points."
- PathUnit: "represents a sequence of points and the total distance along them."
- StatsUnit: "computes a rounded distance between two coordinate pairs."

Each answer fits in one sentence -- per the source material, that's the sign these are reasonably-scoped modules.

PREFIXED IDENTIFIERS (section 2.14.3)

Pascal has no separate namespace for global identifiers, so every name each unit exports is prefixed with its own subsystem name: GeomPoint/GeomDistance, PathArray/PathLength/PathMaxPoints, StatsRoundedDistance -- directly following the source material's own Complex/ComplexAddition/ComplexMultiplication example.

COUPLING, COMPARED DIRECTLY (section 2.14.4)

This example was built specifically to contrast the two kinds of coupling the source material discusses:

  PathUnit -> GeomUnit:
    where the "uses" goes: interface (required)
    kind of coupling: DATA coupling -- PathArray is literally built from GeomPoint
    avoidable here? No -- a path IS a sequence of points, there is no way around it

  StatsUnit -> GeomUnit:
    where the "uses" goes: implementation only
    kind of coupling: CALL coupling -- only calls GeomDistance, nothing about GeomPoint appears in StatsUnit's interface
    avoidable here? Yes, and avoided -- StatsRoundedDistance's signature only needs plain numbers

Per the source material, call coupling is always preferable to data coupling where you have the choice. StatsUnit demonstrates the preferred case; PathUnit demonstrates a case where data coupling is genuinely unavoidable, not a mistake. Both dependencies are still one-way (GeomUnit knows nothing about either PathUnit or StatsUnit), which the source material says is always better than a mutual dependency between two units.

A SUBTLETY IN geomdemo.pas: STRUCTURAL USE VS. NAMING A TYPE

geomdemo.pas only lists "uses PathUnit, StatsUnit;" -- never GeomUnit -- yet it freely reads and writes pts[i].x/pts[i].y (fields of GeomPoint values, reached through PathUnit's PathArray). This works because Pascal record field access only needs the value's type to be known to the compiler (which it is, via PathArray's own definition) -- it never requires the program's own source text to spell out GeomPoint by name. If geomdemo.pas instead tried to write "var p: GeomPoint;" directly, that would fail to compile without also adding "uses GeomUnit" itself -- using a type's values structurally (through another unit's exported type) and naming that type directly are two different things, and only the first one comes "for free."

REQUIREMENTS

- Free Pascal (fpc) or any compatible Pascal compiler.
- geomunit.pp, pathunit.pp, and statsunit.pp must all be in the same directory as geomdemo.pas.

HOW TO BUILD AND RUN

    fpc geomdemo.pas

This compiles GeomUnit, PathUnit, and StatsUnit automatically (in dependency order -- GeomUnit first, since both other units need it), then links everything into geomdemo.

    echo '2
    0 0
    3 4' | ./geomdemo

Output:

    Total path length: 5.000
    Rounded distance from point 1 to point 2: 5

TESTING

    chmod +x geomdemo_test.sh
    ./geomdemo_test.sh

No output means every test passed. Test points are chosen as 3-4-5 Pythagorean triples specifically so the expected distances are exact integers, avoiding any floating-point rounding ambiguity in the comparison.

DEBUG PRINTING

GeomUnit.GeomDistance includes {$IFDEF DEBUG}-guarded tracing -- since both PathUnit and StatsUnit funnel their distance calculations through this one function, turning on debug output here shows every underlying distance computation regardless of which higher-level unit triggered it:

    fpc -dDEBUG geomdemo.pas
    echo '3
    0 0
    3 4
    3 0' | ./geomdemo

Output:

    DEBUG: GeomDistance from (0.00,0.00) to (3.00,4.00)
    DEBUG: GeomDistance from (3.00,4.00) to (3.00,0.00)
    DEBUG: GeomDistance from (0.00,0.00) to (3.00,0.00)
    Total path length: 9.000
    Rounded distance from point 1 to point 3: 3

NOTES

- GeomUnit is compiled once and reused by both PathUnit and StatsUnit -- since it's the one thing they have in common, this is exactly the situation the source material describes as motivating a shared, narrowly-scoped module in the first place, rather than each of PathUnit/StatsUnit reimplementing distance calculation on its own.
- All units here use the .pp extension, matching the convention from section 2.14.1.
