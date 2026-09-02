#!/bin/zsh
#                    unitdemo_test.sh
#
# Tests unitdemo.pas (which uses the lngtree unit) by feeding it
# fixed "+ n" / "? n" command sequences and checking the resulting
# transcript. Unlike treedemo.pas, this program prints no banner or
# goodbye line, so no stripping is needed before comparing.

run_case() {
    local commands="$1"
    local expected="$2"
    local actual
    actual=`printf '%s\n' "${(f)commands}" | ./unitdemo`
    if [ "x$actual" != "x$expected" ]; then
        echo "TEST FAILED"
        echo "  commands: ${(f)commands}"
        echo "  expected: $expected"
        echo "  actual:   $actual"
    fi
}

run_case "+ 50
+ 25
+ 75
? 25
? 99
+ 25" "Successfully added
Successfully added
Successfully added
Yes!
No.
Couldn't add!"

run_case "? 1" "No."

run_case "+ 1
? 1" "Successfully added
Yes!"

run_case "+ 5
+ 5" "Successfully added
Couldn't add!"

run_case "x 1" 'Unknown command "x"'
