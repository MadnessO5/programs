program TreeBasics;                              { tree_basics.pas }

{
  Здесь собраны примеры из §2.11.5, которые предшествуют введению
  SearchTree: SumTree (сумма узлов дерева) и самые первые, "наивные"
  версии AddToTree/IsInTree, ещё без объединяющей их функции поиска
  позиции. Более короткие версии AddToTree/IsInTree, построенные
  через SearchTree, показаны отдельно в treedemo.pas.
}

type
    TreeNodePtr = ^TreeNode;
    TreeNode = record
        data: longint;
        left, right: TreeNodePtr;
    end;

function SumTree(p: TreeNodePtr): longint;
begin
    if p = nil then
        SumTree := 0
    else
        SumTree := SumTree(p^.left) + p^.data + SumTree(p^.right)
end;

procedure AddToTree(var p: TreeNodePtr; val: longint; var ok: boolean);
begin
    if p = nil then
    begin
        new(p);
        p^.data := val;
        p^.left := nil;
        p^.right := nil;
        ok := true
    end
    else
    if val < p^.data then
        AddToTree(p^.left, val, ok)
    else
    if val > p^.data then
        AddToTree(p^.right, val, ok)
    else
        ok := false
end;

procedure IsInTree(p: TreeNodePtr; val: longint; var res: boolean);
begin
    if p = nil then
        res := false
    else
    if val < p^.data then
        IsInTree(p^.left, val, res)
    else
    if val > p^.data then
        IsInTree(p^.right, val, res)
    else
        res := true
end;

procedure PrintInOrder(p: TreeNodePtr);
begin
    if p <> nil then
    begin
        PrintInOrder(p^.left);
        write(p^.data, ' ');
        PrintInOrder(p^.right)
    end
end;

procedure FreeTree(var p: TreeNodePtr);
begin
    if p <> nil then
    begin
        FreeTree(p^.left);
        FreeTree(p^.right);
        dispose(p);
        p := nil
    end
end;

function ReadInt(const prompt: string): longint;
var
    line: string;
    value: longint;
    errCode: word;
begin
    repeat
        write(prompt);
        readln(line);
        val(line, value, errCode);
        if errCode <> 0 then
            writeln('Это не целое число, попробуйте ещё раз')
    until errCode = 0;
    ReadInt := value
end;

var
    root: TreeNodePtr;
    choice, n: longint;
    ok: boolean;

begin
    root := nil;

    repeat
        writeln;
        writeln('1 - Добавить число (AddToTree)');
        writeln('2 - Проверить наличие числа (IsInTree)');
        writeln('3 - Сумма всех узлов (SumTree)');
        writeln('4 - Показать дерево по возрастанию');
        writeln('0 - Выход');
        choice := ReadInt('Выбор: ');

        case choice of
            1:
                begin
                    n := ReadInt('Число для добавления: ');
                    AddToTree(root, n, ok);
                    if ok then
                        writeln('Successfully added')
                    else
                        writeln('Couldn''t add!')
                end;

            2:
                begin
                    n := ReadInt('Число для проверки: ');
                    IsInTree(root, n, ok);
                    if ok then
                        writeln('Yes!')
                    else
                        writeln('No.')
                end;

            3:
                writeln('Сумма узлов дерева: ', SumTree(root));

            4:
                begin
                    write('По возрастанию: ');
                    PrintInOrder(root);
                    writeln
                end;

            0:
                writeln('Выход');
        else
            writeln('Неизвестный пункт меню')
        end
    until choice = 0;

    FreeTree(root)
end.
