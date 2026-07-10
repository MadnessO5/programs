CharArrayDemo
An interactive console program demonstrating string literals and char arrays in Pascal, and a common pitfall when printing them.
What it covers
Assigning a string literal to a char array — hello := 'Hello, world!', one of the few things Pascal lets you do with arrays that aren't the exact same type (a string literal can be assigned to any array of char, unlike assignment between two differently-typed arrays).
The "invisible zeros" pitfall — when a string literal is shorter than the array, the remaining elements are filled with #0 (the null character). Printing the array naively with writeln looks correct on screen, but it actually outputs the trailing #0 characters too (invisible, but present — and technically not valid text).
The correct fix — a for loop with break that stops printing as soon as it hits #0, avoiding the invisible padding.
Mixed string literals with character codes — literals can freely alternate between apostrophe-quoted text and #code character codes, e.g. 'first'#10#9'second', where #10 is a newline and #9 is a tab.
Reading user input into a char array — readln(name), then printing it correctly using the same #0-aware loop.
Requirements
Free Pascal (fpc) or any compatible Pascal compiler.
How to build and run
fpc char_array_demo.pas ./char_array_demo 
The program will:
Print hello: array [1..30] of char the naive way (looks fine on screen, but technically includes trailing #0 characters).
Print the same array the correct way, stopping at the first #0.
Print a literal built from mixed text and character codes (#10, #9), showing tabs/newlines.
Ask for your name and print a greeting, correctly trimmed at the first #0.
Sample session (abbreviated)
Наивный вывод массива char (видны лишние нулевые символы, но на экране они не отображаются, только занимают место): Hello, world! Правильный вывод с остановкой на первом символе #0: Hello, world! Строковый литерал со вставленными кодами символов: first  second   third    fourth Введите ваше имя (до 30 символов): Vova Здравствуйте, Vova! 
Notes
To actually see the invisible trailing #0 characters from the naive writeln(hello) call, try redirecting the output to a file and inspecting it with hexdump, or piping it through wc -c to compare the byte count to the visible text length.
The array size is fixed at 30 characters; typing a name longer than that will only fill the first 30 characters (the rest is silently discarded) — this fixed-length limitation is exactly the motivation for the proper string types covered later in the source material.
