unit lngtree;                                      { lngtree.pp }
interface

type
    TreeNodePtr = ^TreeNode;
    TreeNode = record
        data: longint;
        left, right: TreeNodePtr;
    end;

procedure AddToTree(var p: TreeNodePtr; val: longint; var ok: boolean);
function IsInTree(p: TreeNodePtr; val: longint): boolean;

implementation

type
    TreeNodePos = ^TreeNodePtr;

function SearchTree(var p: TreeNodePtr; val: longint): TreeNodePos;
begin
    {$IFDEF DEBUG}
    if p = nil then
        writeln('DEBUG: SearchTree reached an empty subtree, val = ', val)
    else
        writeln('DEBUG: SearchTree at node ', p^.data, ', looking for ', val);
    {$ENDIF}
    if (p = nil) or (p^.data = val) then
        SearchTree := @p
    else
    if val < p^.data then
        SearchTree := SearchTree(p^.left, val)
    else
        SearchTree := SearchTree(p^.right, val)
end;

procedure AddToTree(var p: TreeNodePtr; val: longint; var ok: boolean);
var
    pos: TreeNodePos;
begin
    pos := SearchTree(p, val);
    if pos^ = nil then
    begin
        new(pos^);
        pos^^.data := val;
        pos^^.left := nil;
        pos^^.right := nil;
        ok := true;
        {$IFDEF DEBUG}
        writeln('DEBUG: AddToTree inserted ', val)
        {$ENDIF}
    end
    else
    begin
        ok := false;
        {$IFDEF DEBUG}
        writeln('DEBUG: AddToTree rejected duplicate ', val)
        {$ENDIF}
    end
end;

function IsInTree(p: TreeNodePtr; val: longint): boolean;
begin
    IsInTree := SearchTree(p, val)^ <> nil
end;

end.
