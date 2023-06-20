package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d03: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
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

    return solve_part1(input), solve_part2(input)
}
