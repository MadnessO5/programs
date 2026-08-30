#!/bin/zsh
#                    expreval_fixed_test.sh
#
# Tests expreval_fixed.pas -- the corrected version. Unlike
# expreval_test.sh (which has two intentionally-failing cases to
# find via gdb), every test here is expected to pass.

run_case() {
    local expr="$1"
    local expected="$2"
    local actual
    actual=`./expreval_fixed "$expr" | sed 's/.*= //'`
    if [ "x$actual" != "x$expected" ]; then
        echo "TEST FAILED: \"$expr\" expected $expected, got $actual"
    fi
}

run_case "2+3" "5"
run_case "2*3" "6"
run_case "2+3*4" "14"
run_case "10-2-3" "5"
run_case "2*3*4" "24"
run_case "(2+3)*4" "20"
run_case "6/2/3" "1"
run_case "2 * 3 * 4" "24"
run_case "6 / 2 / 3" "1"
run_case "2 + 3 * 4" "14"
run_case "( 2 + 3 ) * 4" "20"
