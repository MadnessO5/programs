#!/bin/zsh
#                    match_pt_test.sh
#
# Automated test harness for match_pt.pas, following the pattern from
# section 2.13.2: each test is one line of "string pattern expected",
# read via the shell's own "read" builtin, run through the program,
# and compared against the expected result. Silence means success;
# any failing test prints exactly what went wrong.

while read str pat expected; do
    res=`./match_pt "$str" "$pat"`
    if [ "x$expected" != "x$res" ]; then
        echo TEST "$str" "$pat" FAILED: expected "$expected", got "$res"
    fi
done <<END
abc a?c yes
abc a??c no
abc abc yes
abc *** yes
abc *a*c* yes
abc *z* no
abc a*z no
hello ????? yes
hello ?????? no
test *st yes
test te* yes
test *xyz* no
END
