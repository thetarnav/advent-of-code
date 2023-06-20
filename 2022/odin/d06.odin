package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d06: Day_Proc = proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
    solve :: proc(input: string, marker_size: int) -> (result: int) {
        seen := input[:marker_size]

        for i in marker_size ..< len(input) {
            if utils.is_unique(seen) do return i - 1
            seen = input[i - marker_size:i]
        }

        fmt.panicf("no solution found")
    }

    return solve(input, 4), solve(input, 14)
}
