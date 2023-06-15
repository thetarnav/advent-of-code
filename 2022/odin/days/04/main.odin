package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

solve_part1 :: proc(input: string) -> (result: int) {
    splits := []string{"\n", "-", ","}
    values := slice.mapper(strings.split_multi(input, splits), strconv.atoi)
    defer delete(values)

    for i := 0; i < len(values); i += 4 {
        a, b, c, d := values[i], values[i + 1], values[i + 2], values[i + 3]
        if a <= c && b >= d || a >= c && b <= d {
            result += 1
        }
    }
    return
}

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 4

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(input)) // 513
    fmt.println("part 2:", solve_part2(input)) //
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part1(input), 2)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part2(input), 0)
}
