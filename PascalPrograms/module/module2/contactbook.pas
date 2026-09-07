program ContactBook;                              { contactbook.pas }
uses
    ContactUnit, SearchUnit, StatsUnit;

var
    root: ContactPtr;
    choice: integer;
    name, phone, pat, filename: string;
    ok: boolean;
    found: ContactPtr;

begin
    root := nil;
    repeat
        writeln;
        writeln('1-Add  2-Find  3-List all  4-Search pattern  5-Stats  6-Save  7-Load  0-Exit');
        write('Choice: ');
        readln(choice);
        case choice of
            1: begin
                write('Name: '); readln(name);
                write('Phone: '); readln(phone);
                ContactAdd(root, name, phone, ok);
                if ok then writeln('Added') else writeln('Already exists')
               end;
            2: begin
                write('Name: '); readln(name);
                found := ContactFind(root, name);
                if found <> nil then writeln(found^.phone) else writeln('Not found')
               end;
            3: ContactPrintAll(root);
            4: begin
                write('Pattern: '); readln(pat);
                SearchByPattern(root, pat)
               end;
            5: begin
                writeln('Contacts: ', StatsCount(root));
                writeln('Tree height: ', StatsHeight(root))
               end;
            6: begin write('File: '); readln(filename); ContactSave(root, filename) end;
            7: begin write('File: '); readln(filename); ContactLoad(root, filename) end;
            0: writeln('Bye')
        end
    until choice = 0;
    ContactFree(root)
end.
