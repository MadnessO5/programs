program Huffman;                                 { huffman.pas }

{
  A general-purpose file compressor/decompressor based on Huffman coding.

  Usage:
      huffman compress   <input file> <output file>
      huffman decompress <input file> <output file>

  File format written by "compress" (all multi-byte integers are
  stored little-endian, least significant byte first):

      [4 bytes]  original file size, as an unsigned 32-bit value
      [2 bytes]  number of distinct byte values present in the file
      for each distinct byte value, in ascending order:
          [1 byte]  the byte value itself
          [4 bytes] how many times it occurs in the original file
      [remaining bytes] the file's contents, Huffman-encoded as a
                         packed bit stream (the final byte may be
                         padded with zero bits)

  Decompression rebuilds the exact same Huffman tree purely from the
  frequency table stored in the header -- the tree itself is never
  written to disk, which is what keeps the format compact.
}

type
    NodePtr = ^HuffNode;
    HuffNode = record
        symbol: byte;
        freq: longint;
        isLeaf: boolean;
        left, right: NodePtr;
    end;

    CodeTable = array [0..255] of string;
    FreqTable = array [0..255] of longint;

var
    outFile: file of byte;
    inFile: file of byte;
    outBuffer, outBitCount: integer;
    inBuffer, inBitCount: integer;

{ ----------------------------------------------------------------
  Little-endian integer I/O for the header fields.
  ---------------------------------------------------------------- }

procedure WriteLongint(v: longint);
var
    i: integer;
    b: byte;
begin
    for i := 1 to 4 do
    begin
        b := byte(v mod 256);
        write(outFile, b);
        v := v div 256
    end
end;

function ReadLongint: longint;
var
    i: integer;
    b: byte;
    total, mult: longint;
begin
    total := 0;
    mult := 1;
    for i := 1 to 4 do
    begin
        read(inFile, b);
        total := total + longint(b) * mult;
        mult := mult * 256
    end;
    ReadLongint := total
end;

procedure WriteWordValue(v: integer);
var
    b: byte;
begin
    b := byte(v mod 256);
    write(outFile, b);
    b := byte(v div 256);
    write(outFile, b)
end;

function ReadWordValue: integer;
var
    b0, b1: byte;
begin
    read(inFile, b0);
    read(inFile, b1);
    ReadWordValue := integer(b0) + integer(b1) * 256
end;

{ ----------------------------------------------------------------
  Bit-level I/O, built on top of the plain byte file.
  ---------------------------------------------------------------- }

procedure InitBitWriter;
begin
    outBuffer := 0;
    outBitCount := 0
end;

procedure WriteBit(bit: integer);
begin
    outBuffer := (outBuffer shl 1) or bit;
    outBitCount := outBitCount + 1;
    if outBitCount = 8 then
    begin
        write(outFile, byte(outBuffer and $FF));
        outBuffer := 0;
        outBitCount := 0
    end
end;

procedure FlushBits;
begin
    if outBitCount > 0 then
    begin
        outBuffer := outBuffer shl (8 - outBitCount);
        write(outFile, byte(outBuffer and $FF));
        outBuffer := 0;
        outBitCount := 0
    end
end;

procedure WriteCode(const code: string);
var
    i: integer;
begin
    for i := 1 to length(code) do
        if code[i] = '1' then
            WriteBit(1)
        else
            WriteBit(0)
end;

function ReadBit: integer;
var
    b: byte;
begin
    if inBitCount = 0 then
    begin
        read(inFile, b);
        inBuffer := b;
        inBitCount := 8
    end;
    ReadBit := (inBuffer shr 7) and 1;
    inBuffer := (inBuffer shl 1) and $FF;
    inBitCount := inBitCount - 1
end;

{ ----------------------------------------------------------------
  Huffman tree construction and use.
  ---------------------------------------------------------------- }

procedure BuildTree(const freq: FreqTable; var root: NodePtr);
var
    forest, rebuilt: array [1..256] of NodePtr;
    forestCount, i, j, idx1, idx2: integer;
    combined: NodePtr;
begin
    forestCount := 0;
    for i := 0 to 255 do
        if freq[i] > 0 then
        begin
            forestCount := forestCount + 1;
            new(forest[forestCount]);
            forest[forestCount]^.symbol := i;
            forest[forestCount]^.freq := freq[i];
            forest[forestCount]^.isLeaf := true;
            forest[forestCount]^.left := nil;
            forest[forestCount]^.right := nil
        end;

    if forestCount = 0 then
    begin
        root := nil;
        exit
    end;

    while forestCount > 1 do
    begin
        idx1 := 1;
        for i := 2 to forestCount do
            if forest[i]^.freq < forest[idx1]^.freq then
                idx1 := i;

        idx2 := -1;
        for i := 1 to forestCount do
            if (i <> idx1) and ((idx2 = -1) or (forest[i]^.freq < forest[idx2]^.freq)) then
                idx2 := i;

        new(combined);
        combined^.isLeaf := false;
        combined^.freq := forest[idx1]^.freq + forest[idx2]^.freq;
        combined^.left := forest[idx1];
        combined^.right := forest[idx2];

        j := 0;
        for i := 1 to forestCount do
            if (i <> idx1) and (i <> idx2) then
            begin
                j := j + 1;
                rebuilt[j] := forest[i]
            end;
        j := j + 1;
        rebuilt[j] := combined;

        forestCount := j;
        for i := 1 to forestCount do
            forest[i] := rebuilt[i]
    end;

    root := forest[1]
end;

procedure AssignCodes(node: NodePtr; const prefix: string; var codes: CodeTable);
begin
    if node = nil then
        exit;
    if node^.isLeaf then
        codes[node^.symbol] := prefix
    else
    begin
        AssignCodes(node^.left, prefix + '0', codes);
        AssignCodes(node^.right, prefix + '1', codes)
    end
end;

procedure FreeTree(var p: NodePtr);
begin
    if p <> nil then
    begin
        FreeTree(p^.left);
        FreeTree(p^.right);
        dispose(p);
        p := nil
    end
end;

function DecodeSymbol(root: NodePtr): byte;
var
    node: NodePtr;
begin
    node := root;
    while not node^.isLeaf do
        if ReadBit = 0 then
            node := node^.left
        else
            node := node^.right;
    DecodeSymbol := node^.symbol
end;

{ ----------------------------------------------------------------
  Top-level compress / decompress commands.
  ---------------------------------------------------------------- }

procedure Compress(const inputName, outputName: string);
var
    inF: file of byte;
    b: byte;
    freq: FreqTable;
    i, symbolCount: integer;
    originalSize, compressedSize, saved: longint;
    root: NodePtr;
    codes: CodeTable;
begin
    {$I-}
    assign(inF, inputName);
    reset(inF);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Error: cannot open input file "', inputName, '"');
        halt(1)
    end;

    for i := 0 to 255 do
        freq[i] := 0;
    originalSize := 0;
    while not eof(inF) do
    begin
        read(inF, b);
        freq[b] := freq[b] + 1;
        originalSize := originalSize + 1
    end;
    close(inF);

    symbolCount := 0;
    for i := 0 to 255 do
        if freq[i] > 0 then
            symbolCount := symbolCount + 1;

    assign(outFile, outputName);
    rewrite(outFile);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Error: cannot create output file "', outputName, '"');
        halt(1)
    end;

    WriteLongint(originalSize);
    WriteWordValue(symbolCount);
    for i := 0 to 255 do
        if freq[i] > 0 then
        begin
            write(outFile, byte(i));
            WriteLongint(freq[i])
        end;

    if symbolCount >= 2 then
    begin
        BuildTree(freq, root);
        for i := 0 to 255 do
            codes[i] := '';
        AssignCodes(root, '', codes);

        InitBitWriter;
        assign(inF, inputName);
        reset(inF);
        while not eof(inF) do
        begin
            read(inF, b);
            WriteCode(codes[b])
        end;
        close(inF);
        FlushBits;

        FreeTree(root)
    end;

    compressedSize := FileSize(outFile);
    close(outFile);

    writeln('Compressed "', inputName, '" -> "', outputName, '"');
    writeln('  Original size:   ', originalSize, ' bytes');
    writeln('  Compressed size: ', compressedSize, ' bytes');
    if originalSize > 0 then
    begin
        saved := 100 - (compressedSize * 100) div originalSize;
        writeln('  Space saved:     ', saved, '%')
    end
end;

procedure Decompress(const inputName, outputName: string);
var
    outF: file of byte;
    freq: FreqTable;
    i, symbolCount: integer;
    originalSize, writtenCount: longint;
    symbolByte: byte;
    singleSymbol: byte;
    root: NodePtr;
begin
    {$I-}
    assign(inFile, inputName);
    reset(inFile);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Error: cannot open input file "', inputName, '"');
        halt(1)
    end;

    originalSize := ReadLongint;
    symbolCount := ReadWordValue;

    for i := 0 to 255 do
        freq[i] := 0;
    singleSymbol := 0;
    for i := 1 to symbolCount do
    begin
        read(inFile, symbolByte);
        freq[symbolByte] := ReadLongint;
        if symbolCount = 1 then
            singleSymbol := symbolByte
    end;

    assign(outF, outputName);
    rewrite(outF);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Error: cannot create output file "', outputName, '"');
        halt(1)
    end;

    if symbolCount = 1 then
        for writtenCount := 1 to originalSize do
            write(outF, singleSymbol)
    else
        if symbolCount > 1 then
        begin
            BuildTree(freq, root);
            inBitCount := 0;
            writtenCount := 0;
            while writtenCount < originalSize do
            begin
                write(outF, DecodeSymbol(root));
                writtenCount := writtenCount + 1
            end;
            FreeTree(root)
        end;

    close(outF);
    close(inFile);

    writeln('Decompressed "', inputName, '" -> "', outputName, '"');
    writeln('  Output size: ', originalSize, ' bytes')
end;

var
    command: string;

begin
    if ParamCount < 3 then
    begin
        writeln(ErrOutput, 'Usage:');
        writeln(ErrOutput, '  huffman compress   <input file> <output file>');
        writeln(ErrOutput, '  huffman decompress <input file> <output file>');
        halt(1)
    end;

    command := ParamStr(1);
    if command = 'compress' then
        Compress(ParamStr(2), ParamStr(3))
    else
        if command = 'decompress' then
            Decompress(ParamStr(2), ParamStr(3))
        else
        begin
            writeln(ErrOutput, 'Error: unknown command "', command, '"');
            writeln(ErrOutput, 'Expected "compress" or "decompress"');
            halt(1)
        end
end.
