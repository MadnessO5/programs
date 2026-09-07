unit ContactUnit;                                 { contactunit.pp }

interface

type
    ContactPtr = ^ContactRecord;
    ContactRecord = record
        name, phone: string;
        left, right: ContactPtr;
    end;

procedure ContactAdd(var root: ContactPtr; const name, phone: string; var ok: boolean);
function ContactFind(root: ContactPtr; const name: string): ContactPtr;
procedure ContactPrintAll(root: ContactPtr);
procedure ContactSave(root: ContactPtr; const filename: string);
procedure ContactLoad(var root: ContactPtr; const filename: string);
procedure ContactFree(var root: ContactPtr);

implementation

procedure ContactAdd(var root: ContactPtr; const name, phone: string; var ok: boolean);
begin
    if root = nil then
    begin
        new(root);
        root^.name := name;
        root^.phone := phone;
        root^.left := nil;
        root^.right := nil;
        ok := true;
        {$IFDEF DEBUG}
        writeln('DEBUG: ContactAdd inserted "', name, '"');
        {$ENDIF}
    end
    else
        if name < root^.name then
            ContactAdd(root^.left, name, phone, ok)
        else
            if name > root^.name then
                ContactAdd(root^.right, name, phone, ok)
            else
                ok := false
end;

function ContactFind(root: ContactPtr; const name: string): ContactPtr;
begin
    if root = nil then
        ContactFind := nil
    else
        if name = root^.name then
            ContactFind := root
        else
            if name < root^.name then
                ContactFind := ContactFind(root^.left, name)
            else
                ContactFind := ContactFind(root^.right, name)
end;

procedure ContactPrintAll(root: ContactPtr);
begin
    if root <> nil then
    begin
        ContactPrintAll(root^.left);
        writeln(root^.name, ': ', root^.phone);
        ContactPrintAll(root^.right)
    end
end;

procedure ContactSave(root: ContactPtr; const filename: string);
var
    f: text;

    procedure WriteNode(p: ContactPtr);
    begin
        if p <> nil then
        begin
            WriteNode(p^.left);
            writeln(f, p^.name, ';', p^.phone);
            WriteNode(p^.right)
        end
    end;

begin
    {$I-}
    assign(f, filename);
    rewrite(f);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Could not create ', filename);
        exit
    end;
    WriteNode(root);
    close(f)
end;

procedure ContactLoad(var root: ContactPtr; const filename: string);
var
    f: text;
    line, name, phone: string;
    p: integer;
    ok: boolean;
begin
    {$I-}
    assign(f, filename);
    reset(f);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Could not open ', filename);
        exit
    end;
    while not eof(f) do
    begin
        readln(f, line);
        p := pos(';', line);
        if p > 0 then
        begin
            name := copy(line, 1, p - 1);
            phone := copy(line, p + 1, length(line));
            ContactAdd(root, name, phone, ok)
        end
    end;
    close(f)
end;

procedure ContactFree(var root: ContactPtr);
begin
    if root <> nil then
    begin
        ContactFree(root^.left);
        ContactFree(root^.right);
        dispose(root);
        root := nil
    end
end;

end.
