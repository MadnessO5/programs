program TreeDemo;                                { treedemo.pas }
type
    TreeNodePtr = ^TreeNode;
    TreeNode = record
        data: longint;
        left, right: TreeNodePtr;
    end;
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
function AddToTree(var p: TreeNodePtr; val: longint): boolean;
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
        AddToTree := true;
        {$IFDEF DEBUG}
        writeln('DEBUG: AddToTree inserted ', val)
        {$ENDIF}
    end
    else
    begin
        AddToTree := false;
        {$IFDEF DEBUG}
        writeln('DEBUG: AddToTree rejected duplicate ', val)
        {$ENDIF}
    end
end;
function IsInTree(p: TreeNodePtr; val: longint): boolean;
begin
    IsInTree := SearchTree(p, val)^ <> nil
end;

{$IFDEF DEBUG}
procedure DebugPrintTree(p: TreeNodePtr);
begin
    if p <> nil then
    begin
        DebugPrintTree(p^.left);
        write(p^.data, ' ');
        DebugPrintTree(p^.right)
    end
end;

procedure DebugDumpTree(root: TreeNodePtr);
begin
    write('DEBUG: tree contents, sorted: ');
    DebugPrintTree(root);
    writeln
end;
{$ENDIF}
var
    root: TreeNodePtr = nil;
    c: char;
    n: longint;
begin
    writeln('=== Binary Search Tree ===');
    writeln('Enter commands in the form: <command> <number>');
    writeln('  + 5   -> add 5 to the tree');
    writeln('  ? 5   -> check whether 5 is in the tree');
    writeln('Press Ctrl+D (Linux/macOS) or Ctrl+Z (Windows) to exit');
    writeln;
    while not eof do
    begin
        readln(c, n);
        case c of
            '?': begin
                if IsInTree(root, n) then
                    writeln('Yes!')
                else
                    writeln('No.')
            end;
            '+': begin
                if AddToTree(root, n) then
                begin
                    writeln('Successfully added');
                    {$IFDEF DEBUG}
                    DebugDumpTree(root)
                    {$ENDIF}
                end
                else
                    writeln('Couldn''t add!')
            end;
            else
                writeln('I don''t know such command! Try "+" or "?"')
        end
    end;
    writeln('Done, goodbye!')
end.
