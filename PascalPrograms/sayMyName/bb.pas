program SayMyName;
const
        question = 'Say my name: ';
        aname1 = 'heisenberg';
        right = 'You god damn right!';
        left = 'You god damn left!';
var
        name: string;
begin
        repeat
                write(question);
                readln(name);
                if name <> aname1 then
                        writeln(left);
        until name = aname1;
        writeln(right);
end.
