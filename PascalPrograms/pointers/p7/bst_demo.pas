program BSTDemo;                                 { bst_demo.pas }

{
  Двоичное дерево поиска для целых чисел.
  Вставка и поиск сделаны итеративно (приём "указатель на указатель",
  уже знакомый нам по спискам); обход и вычисление высоты - рекурсивно,
  как раз для иллюстрации того, о чём говорит книга: операции над
  деревом значительно проще записываются через рекурсию.
}

type
    NodePtr = ^Node;
    Node = record
        data: integer;
        left, right: NodePtr;
    end;

procedure BSTInsert(var root: NodePtr; value: integer);
var
    pp: ^NodePtr;
begin
    pp := @root;
    while pp^ <> nil do
    begin
        if value < pp^^.data then
            pp := @(pp^^.left)
        else
            if value > pp^^.data then
                pp := @(pp^^.right)
            else
                exit                      { такое значение уже есть, дублей не держим }
    end;
    new(pp^);
    pp^^.data := value;
    pp^^.left := nil;
    pp^^.right := nil
end;

function BSTSearch(root: NodePtr; value: integer; var comparisons: integer): boolean;
var
    tmp: NodePtr;
begin
    comparisons := 0;
    tmp := root;
    while (tmp <> nil) and (tmp^.data <> value) do
    begin
        comparisons := comparisons + 1;
        if value < tmp^.data then
            tmp := tmp^.left
        else
            tmp := tmp^.right
    end;
    if tmp <> nil then
        comparisons := comparisons + 1;
    BSTSearch := tmp <> nil
end;

function BSTHeight(root: NodePtr): integer;
var
    lh, rh: integer;
begin
    if root = nil then
        BSTHeight := 0
    else
    begin
        lh := BSTHeight(root^.left);
        rh := BSTHeight(root^.right);
        if lh > rh then
            BSTHeight := lh + 1
        else
            BSTHeight := rh + 1
    end
end;

function BSTCount(root: NodePtr): integer;
begin
    if root = nil then
        BSTCount := 0
    else
        BSTCount := 1 + BSTCount(root^.left) + BSTCount(root^.right)
end;

procedure BSTPrintInOrder(root: NodePtr);
begin
    if root <> nil then
    begin
        BSTPrintInOrder(root^.left);
        write(root^.data, ' ');
        BSTPrintInOrder(root^.right)
    end
end;

procedure BSTFree(var root: NodePtr);
begin
    if root <> nil then
    begin
        BSTFree(root^.left);
        BSTFree(root^.right);
        dispose(root);
        root := nil
    end
end;

function ReadInt(const prompt: string): integer;
var
    line: string;
    value: integer;
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
    root: NodePtr;
    choice, n, comparisons: integer;
    found: boolean;

begin
    root := nil;

    repeat
        writeln;
        writeln('1 - Добавить число        4 - Высота дерева');
        writeln('2 - Найти число            5 - Количество узлов');
        writeln('3 - Показать по возрастанию 0 - Выход');
        choice := ReadInt('Выбор: ');

        case choice of
            1:
                begin
                    n := ReadInt('Число для добавления: ');
                    BSTInsert(root, n)
                end;

            2:
                begin
                    n := ReadInt('Число для поиска: ');
                    found := BSTSearch(root, n, comparisons);
                    if found then
                        writeln('Найдено! Потребовалось сравнений: ', comparisons)
                    else
                        writeln('Не найдено. Потребовалось сравнений: ', comparisons)
                end;

            3:
                begin
                    write('По возрастанию: ');
                    BSTPrintInOrder(root);
                    writeln
                end;

            4:
                writeln('Высота дерева: ', BSTHeight(root));

            5:
                writeln('Узлов в дереве: ', BSTCount(root));

            0:
                writeln('Выход');
        else
            writeln('Неизвестный пункт меню')
        end
    until choice = 0;

    BSTFree(root)
end.
