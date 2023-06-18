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

    for line in lines {
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

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 10

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(input)) // 14040
    fmt.println("part 2:", solve_part2(input)) //
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part1(input), 420 + 1140 + 1800 + 2940 + 2880 + 3960)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part2(input), 0)
}
