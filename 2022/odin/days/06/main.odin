package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

solve_part1 :: proc(input: string) -> (result: int) {
    a := input[0]
    b := input[1]
    c := input[2]
    d := input[3]

    for i in 4 ..< len(input) {
        if utils.is_slice_unique({a, b, c, d}) do return i
        a, b, c, d = b, c, d, input[i]
    }

    return
}

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 6

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(input)) // 1816
    fmt.println("part 2:", solve_part2(input)) //
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    for line in strings.split_lines_iterator(&input) {
        pair := strings.split(line, " ")
        testing.expect_value(t, solve_part1(pair[0]), strconv.atoi(pair[1]))
    }
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part2(input), 0)
}
