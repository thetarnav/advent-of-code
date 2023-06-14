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

solve_part1 :: proc(input: string) -> (sum: int) {
    lines: for line in utils.lines(input) {
        length := len(line)
        left := line[:length / 2]

        for n in line[length / 2:] {
            if (strings.contains_rune(left, n)) {
                sum += to_priority(n)
                continue lines
            }
        }

    }
    return
}

DAY :: 3

main :: proc() {
    input := utils.read_input_file(DAY)

    fmt.println("part 1:", solve_part1(input)) // 7737

    // fmt.println("part 2:", solve_part2(input)) // 10560
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part1(input), 157)
}

// @(test)
// test_part2 :: proc(t: ^testing.T) {
//     input := utils.read_input_file(DAY, "example")

//     testing.expect_value(t, solve_part2(input), 12)
// }
