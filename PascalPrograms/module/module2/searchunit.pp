unit SearchUnit;                                  { searchunit.pp }

interface

uses
    ContactUnit;                { data coupling: search walks a ContactRecord tree }

function SearchMatch(const s, pat: string): boolean;
procedure SearchByPattern(root: ContactPtr; const pat: string);

implementation

function SearchMatchIdx(var s, pat: string; idxs, idxp: integer): boolean;
var
    i: integer;
begin
    while true do
    begin
        if idxp > length(pat) then
        begin
            SearchMatchIdx := idxs > length(s);
            exit
        end;
        if pat[idxp] = '*' then
        begin
            for i := 0 to length(s) - idxs + 1 do
                if SearchMatchIdx(s, pat, idxs + i, idxp + 1) then
                begin
                    SearchMatchIdx := true;
                    exit
                end;
            SearchMatchIdx := false;
            exit
        end;
        if (idxs > length(s)) or
           ((s[idxs] <> pat[idxp]) and (pat[idxp] <> '?')) then
        begin
            SearchMatchIdx := false;
            exit
        end;
        idxs := idxs + 1;
        idxp := idxp + 1
    end
end;

function SearchMatch(const s, pat: string): boolean;
var
    ss, pp: string;
begin
    ss := s;
    pp := pat;
    SearchMatch := SearchMatchIdx(ss, pp, 1, 1)
end;

procedure SearchByPattern(root: ContactPtr; const pat: string);
begin
    if root <> nil then
    begin
        SearchByPattern(root^.left, pat);
        if SearchMatch(root^.name, pat) then
            writeln(root^.name, ': ', root^.phone);
        SearchByPattern(root^.right, pat)
    end
end;

end.
