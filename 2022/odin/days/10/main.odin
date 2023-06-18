package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

solve_part1 :: proc(input: string) -> (result: int) {
    lines := strings.split_lines(input)
    value := 1
    cycle := 1

    add_cycle := proc(cycle: int, value: int) -> int {
        return (cycle - 20) % 40 == 0 ? value * cycle : 0
    }

    for line, i in lines {
        pair := strings.split(line, " ")

        cycle += 1
        result += add_cycle(cycle, value)

        if pair[0] == "addx" {
            cycle += 1
            value += strconv.atoi(pair[1])
            result += add_cycle(cycle, value)
        }
    }

    return
}

solve_part2 :: proc(input: string) -> (result: string) {
    w :: 40
    h :: 6
    buffer: [40 * 6]bool
    mtx := make([][]bool, h)
    defer delete(mtx)
    for y in 0 ..< h do mtx[y] = buffer[y * w:(y + 1) * w]
    lines := strings.split_lines(input)
    sprite_x := 1
    line_idx := 0
    to_add := 0

    for cycle := 0; cycle < len(buffer); cycle += 1 {
        cx, cy := cycle % w, cycle / w

        if cx >= sprite_x - 1 && cx <= sprite_x + 1 {
            mtx[cy][cx] = true
        }

        if to_add != 0 {
            sprite_x += to_add
            to_add = 0
        } else {
            line := lines[line_idx]
            line_idx += 1
            pair := strings.split(line, " ")
            if pair[0] == "addx" do to_add = strconv.atoi(pair[1])
        }
    }

    sb := strings.builder_make()
    for y in 0 ..< h {
        for x in 0 ..< w do strings.write_rune(&sb, mtx[y][x] ? '#' : '.')
        if y != h - 1 do strings.write_rune(&sb, '\n')
    }
    return strings.to_string(sb)
}

DAY :: 10

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(input)) // 14040
    fmt.println("part 2:\n", solve_part2(input)) // ZGCJZJFL
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part1(input), 420 + 1140 + 1800 + 2940 + 2880 + 3960)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    expected := utils.read_input_file(DAY, "example-solution")
    result := solve_part2(input)
    testing.expect_value(t, result, expected)
}
