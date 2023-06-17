package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

Vector :: [2]int

direction_to_vector_map := map[string]Vector {
    "R" = Vector{1, 0},
    "L" = Vector{-1, 0},
    "U" = Vector{0, 1},
    "D" = Vector{0, -1},
}

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
                prev_t_pos := rope[i]

                if adx <= 1 && ady <= 1 do continue
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

DAY :: 9
PART1_ROPE_SIZE :: 2
PART2_ROPE_SIZE :: 10

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve(input, PART1_ROPE_SIZE)) // 6563
    fmt.println("part 2:", solve(input, PART2_ROPE_SIZE)) // 2653
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve(input, PART1_ROPE_SIZE), 88)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve(input, PART2_ROPE_SIZE), 36)
}
