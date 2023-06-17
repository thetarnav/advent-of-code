package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

Matrix :: [][]int

delete_matrix :: proc(m: Matrix) {
    for row in m do delete(row)
    delete(m)
}

parse_input :: proc(input: string) -> (m: Matrix, size: int) {
    lines := strings.split_lines(input)
    size = len(lines)
    m = make([][]int, size)
    for line, y in lines {
        m[y] = make([]int, size)
        for c, x in line do m[y][x] = utils.rune_to_int(c)
    }

    return
}

solve_part1 :: proc(input: string) -> (result: int) {
    m, size := parse_input(input)
    defer delete_matrix(m)

    it_i := 0
    for x, y in utils.iterate_matrix(size, &it_i) {
        h := m[y][x]
        right: {
            for x2 in x + 1 ..< size do if m[y][x2] >= h do break right
            result += 1
            continue
        }
        left: {
            for x2 in 0 ..< x do if m[y][x2] >= h do break left
            result += 1
            continue
        }
        up: {
            for y2 in 0 ..< y do if m[y2][x] >= h do break up
            result += 1
            continue
        }
        down: {
            for y2 in y + 1 ..< size do if m[y2][x] >= h do break down
            result += 1
            continue
        }
    }

    return
}

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 8

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(input)) // 1820
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
