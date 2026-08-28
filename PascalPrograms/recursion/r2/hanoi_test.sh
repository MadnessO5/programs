#!/bin/zsh
#                    hanoi_test.sh
#
# A different style of test than match_pt_test.sh: instead of
# comparing exact output text, this checks a *property* of the
# result -- that solving Towers of Hanoi for n disks always takes
# exactly 2^n - 1 moves. This is easier to state and check than
# writing out every expected move by hand, and it would catch most
# realistic bugs (extra or missing moves) just as well.

while read n expected; do
    count=`./hanoi $n | wc -l`
    if [ "$count" -ne "$expected" ]; then
        echo TEST hanoi $n FAILED: expected $expected lines, got $count
    fi
done <<END
1 1
2 3
3 7
4 15
5 31
10 1023
END
