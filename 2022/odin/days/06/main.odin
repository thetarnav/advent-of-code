package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

solve :: proc(input: string, marker_size: int) -> (result: int) {
    seen := input[:marker_size]

    for i in marker_size ..< len(input) {
        if utils.is_unique(seen) do return i - 1
        seen = input[i - marker_size:i]
    }

    fmt.panicf("no solution found")
}

DAY :: 6
MARKER_SIZE_1 :: 4
MARKER_SIZE_2 :: 14

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve(input, MARKER_SIZE_1)) // 1816
    fmt.println("part 2:", solve(input, MARKER_SIZE_2)) // 2625
}

@(test)
test :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    for line in strings.split_lines_iterator(&input) {
        pair := strings.split(line, " ")
        testing.expect_value(t, solve(pair[0], MARKER_SIZE_1), strconv.atoi(pair[1]))
        testing.expect_value(t, solve(pair[0], MARKER_SIZE_2), strconv.atoi(pair[2]))
    }
}
