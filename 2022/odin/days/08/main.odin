package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

rune_to_int :: proc(c: rune) -> (result: int) {
    return int(c - '0')
}

solve_part1 :: proc(input: string) -> (result: int) {
    lines := strings.split_lines(input)
    size := len(lines)
    result += size * 4 - 4

    m := make([][]int, size)
    for line, y in lines {
        m[y] = make([]int, size)
        for c, x in line do m[y][x] = rune_to_int(c)
    }
    fmt.println(m)

    for _y in 0 ..< size {
        y := _y % 2 == 0 ? _y : size - _y - 1
        fmt.println("y:", y)
    }

    return
}

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 8

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(input)) //
    fmt.println("part 2:", solve_part2(input)) //
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part1(input), 21)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part2(input), 0)
}
