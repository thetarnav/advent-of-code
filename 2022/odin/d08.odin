package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d08: Day_Proc = proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
    parse_input :: proc(input: string) -> (buffer: []int, m: [][]int, size: int) {
        lines := strings.split_lines(input)
        size = len(lines)
        buffer = make([]int, size * size)
        m = make([][]int, size)
        for line, y in lines {
            m[y] = buffer[y * size:(y + 1) * size]
            for c, x in line do m[y][x] = utils.rune_to_int(c)
        }
        return
    }

    solve_part1 :: proc(input: string) -> (result: int) {
        buf, m, size := parse_input(input)
        defer delete(buf)

        it_i := 0
        for x, y in utils.iterate_matrix(size, &it_i) {
            h := m[y][x]
            right: {
                for x2 in x + 1 ..< size do if m[y][x2] >= h do break right
                result += 1
                continue
            }
            left: {
                for x2 in 0 ..< x do if m[y][x2] >= h do break left
                result += 1
                continue
            }
            up: {
                for y2 in 0 ..< y do if m[y2][x] >= h do break up
                result += 1
                continue
            }
            down: {
                for y2 in y + 1 ..< size do if m[y2][x] >= h do break down
                result += 1
                continue
            }
        }

        return
    }

    solve_part2 :: proc(input: string) -> (result: int) {
        buf, m, size := parse_input(input)
        defer delete(buf)

        it_i := 0
        for x, y in utils.iterate_matrix(size, &it_i) {
            if x == 0 || y == 0 || x == size - 1 || y == size - 1 do continue
            h := m[y][x]
            r, l, d, u := 0, 0, 0, 0
            for x2 in x + 1 ..< size {
                r += 1
                if m[y][x2] >= h do break
            }
            for x2 in 0 ..< x {
                l += 1
                if m[y][x - x2 - 1] >= h do break
            }
            for y2 in 0 ..< y {
                u += 1
                if m[y - y2 - 1][x] >= h do break
            }
            for y2 in y + 1 ..< size {
                d += 1
                if m[y2][x] >= h do break
            }
            result = max(result, r * l * d * u)
        }

        return
    }

    return solve_part1(input), solve_part2(input)
}
