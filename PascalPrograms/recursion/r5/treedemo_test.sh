#!/bin/zsh
#                    treedemo_test.sh
#
# Tests treedemo.pas by feeding it a sequence of "+ n" / "? n"
# commands (one per line) and checking the transcript of
# Yes!/No./Successfully added/Couldn't add! lines against what's
# expected. treedemo.pas always prints a fixed 6-line welcome banner
# first and a fixed "Done, goodbye!" line last, regardless of the
# commands given -- those are stripped out here (via "tail"/"head")
# so each test only has to state the part that actually depends on
# its input.
#
# Note: this uses GNU head's "-n -1" (all but the last line), which
# is not available in BSD/macOS head -- this script assumes Linux.

run_case() {
    local commands="$1"
    local expected="$2"
    local actual
    actual=`printf '%s\n' "${(f)commands}" | ./treedemo | tail -n +7 | head -n -1`
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
