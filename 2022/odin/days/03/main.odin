package main

import "core:fmt"
import "core:strings"
import "core:testing"
import "../../utils"

to_priority :: proc(c: rune) -> int {
    switch c {
    case 'a' ..= 'z':
        return int(c - 'a') + 1
    case 'A' ..= 'Z':
        return int(c - 'A') + 27
    case:
        fmt.panicf("invalid character: \"%s\"", c)
    }
}

solve_part1 :: proc(input: string) -> (result: int) {
    lines: for line in strings.split_lines(input) {
        length := len(line)
        left := line[:length / 2]

        for n in line[length / 2:] {
            if strings.contains_rune(left, n) {
                result += to_priority(n)
                continue lines
            }
        }

    }
    return
}

solve_part2 :: proc(input: string) -> (result: int) {
    lines := strings.split_lines(input)

    groups: for i := 0; i < len(lines); i += 3 {
        for char in lines[i] {
            if strings.contains_rune(lines[i + 1], char) &&
               strings.contains_rune(lines[i + 2], char) {
                result += to_priority(char)
                continue groups
            }
        }
    }
    return
}

DAY :: 3

main :: proc() {
    input := utils.read_input_file(DAY)

    fmt.println("part 1:", solve_part1(input)) // 7737

    fmt.println("part 2:", solve_part2(input)) // 2697
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part1(input), 157)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part2(input), 70)
}
