package aoc

import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d04: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
    splits :: []string{"\n", "-", ","}

    solve_part1 :: proc(input: string) -> (result: int) {
        values := slice.mapper(strings.split_multi(input, splits), strconv.atoi)
        defer delete(values)

        for i := 0; i < len(values); i += 4 {
            a, b, c, d := values[i], values[i + 1], values[i + 2], values[i + 3]
            if a <= c && b >= d || a >= c && b <= d {
                result += 1
            }
        }
        return
    }

    solve_part2 :: proc(input: string) -> (result: int) {
        values := slice.mapper(strings.split_multi(input, splits), strconv.atoi)
        defer delete(values)

        for i := 0; i < len(values); i += 4 {
            a, b, c, d := values[i], values[i + 1], values[i + 2], values[i + 3]
            if a <= c && b >= d || a >= c && b <= d || a >= c && a <= d || b >= c && b <= d {
                result += 1
            }
        }
        return
    }

    return solve_part1(input), solve_part2(input)
}
