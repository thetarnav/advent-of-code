package aoc

import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d01: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
    sum_group :: proc(group: string) -> int {
        return utils.sum(slice.mapper(strings.split_lines(group), strconv.atoi))
    }

    solve_part1 :: proc(input: string) -> int {
        groups := strings.split(input, "\n\n")
        totals := slice.mapper(groups, sum_group)
        return slice.max(totals)
    }

    solve_part2 :: proc(input: string) -> int {
        groups := strings.split(input, "\n\n")
        totals := slice.mapper(groups, sum_group)
        max := utils.top_n(totals, 3)
        return utils.sum(max[:])
    }

    return solve_part1(input), solve_part2(input)
}
