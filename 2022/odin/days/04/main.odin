package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

solve_part1 :: proc(input: string) -> (result: int) {
    for line in strings.split_lines(input) {
        ranges: [4]int
        start := 0
        for i := 0; i < len(line); i += 1 {
            if line[i] == '-' {
                i += 1
                ranges[0] = strconv.atoi(line[:i])
                start = i
                break
            }
        }
        for i := start; i < len(line); i += 1 {
            if line[i] == ',' {
                i += 1
                ranges[1] = strconv.atoi(line[start:i])
                start = i
                break
            }
        }
        for i := start; i < len(line); i += 1 {
            if line[i] == '-' {
                i += 1
                ranges[2] = strconv.atoi(line[start:i])
                ranges[3] = strconv.atoi(line[i:])
            }
        }

        if (ranges[0] <= ranges[2] && ranges[1] >= ranges[3]) ||
           (ranges[0] >= ranges[2] && ranges[1] <= ranges[3]) {
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
