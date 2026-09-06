#!/bin/zsh
#                    geomdemo_test.sh
#
# Tests geomdemo.pas with fixed point sets chosen as Pythagorean
# triples (3-4-5), so expected results are exact, avoiding any
# floating-point rounding ambiguity in the comparison.

run_case() {
    local input="$1"
    local expected="$2"
    local actual
    actual=`printf '%s\n' "${(f)input}" | ./geomdemo | sed 's/^[^:]*: //'`
    if [ "x$actual" != "x$expected" ]; then
        echo "TEST FAILED"
        echo "  input:    ${(f)input}"
        echo "  expected: $expected"
        echo "  actual:   $actual"
    fi
}

run_case "2
0 0
3 4" "5.000
5"

run_case "3
0 0
3 4
3 0" "9.000
3"








