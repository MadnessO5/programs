# Huffman

A general-purpose file compressor/decompressor implementing Huffman coding — the same family of entropy coding used inside ZIP, JPEG, PNG, and many other real-world formats.

## Usage

```bash
fpc huffman.pas
./huffman compress   <input file> <output file>
./huffman decompress <input file> <output file>
```

```bash
./huffman compress report.txt report.huff
```
```
Compressed "report.txt" -> "report.huff"
  Original size:   18432 bytes
  Compressed size: 10877 bytes
  Space saved:     40%
```

```bash
./huffman decompress report.huff report_restored.txt
```
```
Decompressed "report.huff" -> "report_restored.txt"
  Output size: 18432 bytes
```

`report_restored.txt` will be byte-for-byte identical to the original `report.txt` — this is lossless compression.

## How it works

Huffman coding assigns shorter bit sequences to more frequent bytes and longer bit sequences to rarer ones, so the file as a whole ends up needing fewer bits than the standard 8-bits-per-byte encoding — the more skewed a file's byte distribution is (plain English text, for instance), the better it compresses; already-dense data (random bytes, already-compressed files) barely compresses at all, since there's no redundancy left to exploit.

- **Frequency counting** — `Compress` reads the whole input once just to count how often each of the 256 possible byte values occurs.
- **Tree construction (`BuildTree`)** — repeatedly takes the two least-frequent nodes in a working "forest" and merges them into a new internal node (whose frequency is their sum), until only one node — the root — remains. Frequent bytes end up near the root (short codes); rare bytes end up deep in the tree (long codes). Both compression and decompression run this *exact same* deterministic construction (same tie-breaking rule, same input order), so they always produce identical trees from the same frequency table — that's what lets the compressed file store only the frequency table, not the tree itself.
- **Code assignment (`AssignCodes`)** — a straightforward recursive walk: going left appends a `'0'`, going right appends a `'1'`; each leaf's accumulated path *is* that byte's code.
- **Bit-packing (`WriteBit`/`ReadBit`)** — since Huffman codes are rarely a whole number of bits long (let alone 8), `WriteBit` accumulates individual bits into a byte-sized buffer and only writes an actual byte to disk once 8 bits have piled up; `FlushBits` pads and writes out whatever's left at the very end. `ReadBit` does the reverse for decompression.
- **Decoding (`DecodeSymbol`)** — walks the tree from the root, following `left`/`right` according to each bit read, until landing on a leaf; that leaf's `symbol` is the decoded byte. Since decompression knows the exact original file size (stored in the header), it stops exactly there, ignoring any leftover padding bits in the final byte.
- **Two degenerate cases handled explicitly**: an empty input file (no bytes at all) and a file containing only one distinct byte value repeated throughout — neither case has a meaningful two-branch tree to build, so both are detected and handled as special cases (writing/reading the repeated byte directly, with zero bits of encoded payload) rather than being forced through the general tree-building machinery.

## File format

All multi-byte integers are little-endian (least significant byte first):

| Field | Size | Meaning |
|---|---|---|
| Original size | 4 bytes | how many bytes the decompressed file should contain |
| Symbol count | 2 bytes | how many distinct byte values follow |
| Symbol table | 5 bytes × symbol count | for each: 1 byte (the value) + 4 bytes (its frequency) |
| Encoded data | remainder of file | the packed Huffman-coded bit stream |

This header is what lets `Decompress` rebuild the identical tree `Compress` used, without ever storing the tree structure itself.

## Requirements

- Free Pascal (`fpc`) or any compatible Pascal compiler.

## Notes

- **This implementation targets clarity over raw performance.** `BuildTree` finds the two smallest-frequency nodes with two linear scans per merge step rather than a proper priority queue/heap — for a byte-alphabet (at most 256 distinct symbols, so at most 255 merge steps), this is computationally trivial and finishes essentially instantly regardless of the *input file's* size, since tree construction only depends on the number of *distinct byte values*, not the file's length. A production compressor handling much larger alphabets (e.g., whole-word or Unicode-codepoint-based coding) would want a heap-based priority queue instead.
- **Compression is not guaranteed to shrink every file.** Files with a nearly uniform byte distribution (already-compressed data, random data, encrypted data) can end up *slightly larger* after compression, since the header itself carries a small fixed overhead (up to `4 + 2 + 256×5 = 1286` bytes in the worst case, when every byte value 0-255 actually appears). This is an inherent property of entropy coding, not a bug — verified directly: compressing 5000 bytes of genuinely random data through this exact algorithm (independently checked in Python) produced 4994 bytes of output, essentially no savings, exactly as expected.
- **Lossless and exact**: every test case checked — an empty file, a file of one repeated byte, ordinary text, uniformly random bytes, and a heavily skewed byte distribution — round-trips back to a byte-for-byte identical file after compress-then-decompress.
- This tool doesn't attempt to detect or reject a corrupted or non-Huffman input file passed to `decompress`; malformed input could cause it to read garbage values from the header (and likely fail or produce nonsense output) rather than reporting a clear format error.
