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

solve_part1 :: proc(input: string) -> (result: int) {
    h_pos, t_pos: Vector
    tail_positions: [dynamic]Vector
    append(&tail_positions, t_pos)

    for line in strings.split_lines(input) {
        values := strings.split(line, " ")
        times := strconv.atoi(values[1])
        h_delta := direction_to_vector_map[values[0]]

        for i in 0 ..< times {
            h_pos += h_delta
            dx, dy := h_pos.x - t_pos.x, h_pos.y - t_pos.y
            adx, ady := abs(dx), abs(dy)
            prev_t_pos := t_pos

            if adx > 1 {
                t_pos.x += dx / adx
                if ady > 0 do t_pos.y = h_pos.y
            } else if ady > 1 {
                t_pos.y += dy / ady
                if adx > 0 do t_pos.x = h_pos.x
            }

            if t_pos != prev_t_pos do append(&tail_positions, t_pos)
        }
    }

    return len(utils.dedupe(tail_positions[:]))
}

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 9

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(input)) // 6563
    fmt.println("part 2:", solve_part2(input)) //
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part1(input), 13)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part2(input), 0)
}
