program ExprEval;                                { expreval_fixed.pas }

{
  A recursive-descent arithmetic expression evaluator, supporting
  +, -, *, /, parentheses, and standard operator precedence.

  This is the corrected version of expreval.pas: ParseTerm's
  multiplication/division loop now calls SkipSpaces after applying
  each operator, before checking whether another '*'/'/' follows --
  matching what ParseExpr's addition/subtraction loop already did.
  That missing call was the bug found via gdb in expreval.pas (see
  README_expreval.md).
}

var
    expr: string;
    pos: integer;

procedure SkipSpaces;
begin
    while (pos <= length(expr)) and (expr[pos] = ' ') do
        pos := pos + 1
end;

function ParseNumber: longint;
var
    value: longint;
begin
    value := 0;
    while (pos <= length(expr)) and (expr[pos] >= '0') and (expr[pos] <= '9') do
    begin
        value := value * 10 + (ord(expr[pos]) - ord('0'));
        pos := pos + 1
    end;
    ParseNumber := value
end;

function ParseExpr: longint; forward;

function ParseFactor: longint;
var
    value: longint;
begin
    SkipSpaces;
    {$IFDEF DEBUG}
    writeln('DEBUG: ParseFactor at pos=', pos, ' char=''', expr[pos], '''');
    {$ENDIF}
    if expr[pos] = '(' then
    begin
        pos := pos + 1;
        value := ParseExpr;
        SkipSpaces;
        pos := pos + 1              { skip the closing ')' }
    end
    else
        value := ParseNumber;
    ParseFactor := value
end;

function ParseTerm: longint;
var
    value, rhs: longint;
    op: char;
begin
    value := ParseFactor;
    SkipSpaces;
    {$IFDEF DEBUG}
    writeln('DEBUG: ParseTerm after factor, value=', value, ', pos=', pos);
    {$ENDIF}
    while (pos <= length(expr)) and ((expr[pos] = '*') or (expr[pos] = '/')) do
    begin
        op := expr[pos];
        pos := pos + 1;
        rhs := ParseFactor;
        if op = '*' then
            value := value * rhs
        else
            value := value div rhs;
        SkipSpaces;
        {$IFDEF DEBUG}
        writeln('DEBUG: ParseTerm applied ''', op, ''', value=', value, ', pos=', pos);
        {$ENDIF}
    end;
    ParseTerm := value
end;

function ParseExpr: longint;
var
    value, rhs: longint;
    op: char;
begin
    value := ParseTerm;
    SkipSpaces;
    while (pos <= length(expr)) and ((expr[pos] = '+') or (expr[pos] = '-')) do
    begin
        op := expr[pos];
        pos := pos + 1;
        rhs := ParseTerm;
        if op = '+' then
            value := value + rhs
        else
            value := value - rhs;
        SkipSpaces
    end;
    ParseExpr := value
end;

begin
    if ParamCount < 1 then
    begin
        writeln(ErrOutput, 'Usage: expreval "<expression>"');
        halt(1)
    end;
    expr := ParamStr(1);
    pos := 1;
    writeln(expr, ' = ', ParseExpr)
end.
