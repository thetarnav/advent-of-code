package main

import "core:fmt"
import "core:strings"
import "core:testing"
import "../../utils"

get_battle_points :: proc(foe: int, me: int) -> int {
    return me + 1 + (me - foe + 1) %% 3 * 3
}

solve_part1 :: proc(input: string) -> int {
    points := 0

    for line in strings.split(input, "\n") {
        if len(line) == 3 {
            foe := int(line[0] - 'A')
            me := int(line[2] - 'X')
            points += get_battle_points(foe, me)
        }

    }

    return points
}

solve_part2 :: proc(input: string) -> int {
    points := 0

    for line in strings.split(input, "\n") {
        if len(line) == 3 {
            foe := int(line[0] - 'A')
            res := int(line[2] - 'X')
            me := (foe + (res - 1)) %% 3
            points += get_battle_points(foe, me)
        }

    }

    return points
}

DAY :: 2

main :: proc() {
    input := utils.read_input_file(DAY)

    fmt.println("part 1:", solve_part1(input)) // 9651

    fmt.println("part 2:", solve_part2(input)) // 10560
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part1(input), 15)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part2(input), 12)
}