unit StatsUnit;                                   { statsunit.pp }

interface

function StatsCount(root: pointer): longint;
function StatsHeight(root: pointer): integer;

implementation

uses
    ContactUnit;                { call coupling only: no ContactUnit types leak into the interface above }

function StatsCount(root: pointer): longint;
var
    p: ContactPtr;
begin
    p := ContactPtr(root);
    if p = nil then
        StatsCount := 0
    else
        StatsCount := 1 + StatsCount(p^.left) + StatsCount(p^.right)
end;

function StatsHeight(root: pointer): integer;
var
    p: ContactPtr;
    lh, rh: integer;
begin
    p := ContactPtr(root);
    if p = nil then
        StatsHeight := 0
    else
    begin
        lh := StatsHeight(p^.left);
        rh := StatsHeight(p^.right);
        if lh > rh then
            StatsHeight := lh + 1
        else
            StatsHeight := rh + 1
    end
end;

end.
