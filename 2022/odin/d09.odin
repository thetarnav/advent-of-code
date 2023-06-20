package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

Vector :: [2]int

direction_to_vector_map := map[string]Vector {
    "R" = Vector{1, 0},
    "L" = Vector{-1, 0},
    "U" = Vector{0, 1},
    "D" = Vector{0, -1},
}

d09: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
    solve :: proc(input: string, rope_size: int) -> (result: int) {
        rope := make([]Vector, rope_size)
        defer delete(rope)
        tail_positions: [dynamic]Vector
        append(&tail_positions, rope[rope_size - 1])

        for line in strings.split_lines(input) {
            values := strings.split(line, " ")
            times := strconv.atoi(values[1])
            h_delta := direction_to_vector_map[values[0]]

            for _ in 0 ..< times {
                rope[0] += h_delta
                for i in 1 ..< rope_size {
                    dx, dy := rope[i - 1].x - rope[i].x, rope[i - 1].y - rope[i].y
                    adx, ady := abs(dx), abs(dy)

                    if adx <= 1 && ady <= 1 do break
                    if adx != 0 do rope[i].x += dx / adx
                    if ady != 0 do rope[i].y += dy / ady

                    if i == rope_size - 1 && !slice.contains(tail_positions[:], rope[i]) {
                        append(&tail_positions, rope[i])
                    }
                }
            }
        }

        return len(tail_positions)
    }

    return solve(input, 2), solve(input, 10)
}
