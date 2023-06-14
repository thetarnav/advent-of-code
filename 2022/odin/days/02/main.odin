package main

import "core:fmt"
import "core:strings"
import "core:testing"
import "../../utils"

Shape :: enum {
    Rock     = 1,
    Paper    = 2,
    Scissors = 3,
}

rune_to_shape := map[rune]Shape {
    'X' = .Rock,
    'Y' = .Paper,
    'Z' = .Scissors,
    'A' = .Rock,
    'B' = .Paper,
    'C' = .Scissors,
}

winning_shape := map[Shape]Shape {
    .Rock     = .Paper,
    .Paper    = .Scissors,
    .Scissors = .Rock,
}

calculate_battle_points :: proc(foe: Shape, me: Shape) -> int {
    points := int(me)

    if me == foe {
        points += 3
    } else if me == winning_shape[foe] {
        points += 6
    }

    return points
}

solve_part1 :: proc(input: string) -> int {
    points := 0

    for line in strings.split(input, "\n") {
        if len(line) != 3 {continue}
        foe := rune_to_shape[rune(line[0])]
        me := rune_to_shape[rune(line[2])]

        points += calculate_battle_points(foe, me)
    }

    return points
}

solve_part2 :: proc(input: string) -> int {
    points := 0

    for line in strings.split(input, "\n") {
        if len(line) != 3 {continue}
        foe := rune_to_shape[rune(line[0])]

        me: Shape
        switch rune(line[2]) {
        case 'X':
            me = winning_shape[winning_shape[foe]] // lose
        case 'Y':
            me = foe // draw
        case 'Z':
            me = winning_shape[foe] // win
        }

        points += calculate_battle_points(foe, me)
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
