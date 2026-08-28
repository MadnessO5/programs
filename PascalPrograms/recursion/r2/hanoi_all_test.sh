#!/bin/zsh
#                    hanoi_all_test.sh
#
# Tests all three Hanoi solutions (hanoi.pas, hanoi2.pas, hanoi3.pas)
# at once, two different ways:
#
#   1. Differential testing: since all three solve the exact same
#      problem optimally, their output for the same n must be
#      IDENTICAL, not just the same length. Comparing three
#      independent implementations against each other is often a
#      stronger check than comparing against a single hand-written
#      "expected" answer -- there's no separate expected-output file
#      to keep in sync, and a bug would have to affect two out of
#      three implementations in exactly the same way to slip past.
#
#   2. A sanity check on the move count (2^n - 1) for each program
#      individually, the same property checked in hanoi_test.sh.

while read n expectedCount; do
    out1=`./hanoi $n`
    out2=`./hanoi2 $n`
    out3=`./hanoi3 $n`

    count1=`echo "$out1" | wc -l`
    count2=`echo "$out2" | wc -l`
    count3=`echo "$out3" | wc -l`

    if [ "$count1" -ne "$expectedCount" ]; then
        echo TEST hanoi $n FAILED: expected $expectedCount lines, got $count1
    fi
    if [ "$count2" -ne "$expectedCount" ]; then
        echo TEST hanoi2 $n FAILED: expected $expectedCount lines, got $count2
    fi
    if [ "$count3" -ne "$expectedCount" ]; then
        echo TEST hanoi3 $n FAILED: expected $expectedCount lines, got $count3
    fi

    if [ "x$out1" != "x$out2" ]; then
        echo TEST n=$n FAILED: hanoi and hanoi2 produced different move sequences
    fi
    if [ "x$out1" != "x$out3" ]; then
        echo TEST n=$n FAILED: hanoi and hanoi3 produced different move sequences
    fi
done <<END
1 1
2 3
3 7
4 15
5 31
6 63
7 127
8 255
END
