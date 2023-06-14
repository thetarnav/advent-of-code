package main

import "core:fmt"
import "core:strings"
import "core:testing"
import "../../utils"

me_to_foe := map[rune]rune {
    'X' = 'A',
    'Y' = 'B',
    'Z' = 'C',
}

points_for_pick := map[rune]int {
    'X' = 1,
    'Y' = 2,
    'Z' = 3,
}

winning_combinations := map[string]bool {
    "A Y" = true,
    "B Z" = true,
    "C X" = true,
}

solve_part1 :: proc(input: string) -> int {
    points := 0

    for line in strings.split(input, "\n") {
        if len(line) != 3 {continue}
        foe := rune(line[0])
        me := rune(line[2])

        points += points_for_pick[me]

        if (foe == me_to_foe[me]) {
            points += 3
        } else if line in winning_combinations {
            points += 6
        }
    }

    return points
}

DAY :: 2

main :: proc() {
    input := utils.read_input_file(DAY)

    fmt.println("part 1:", solve_part1(input))

    // fmt.println("part 2:", solve_part2(input))
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part1(input), 15)
}

// @(test)
// test_part2 :: proc(t: ^testing.T) {
//     input := utils.read_input_file(DAY, "example")

//     testing.expect_value(t, solve_part2(input), 45000)
// }
