package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d12: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {

    Vector :: [2]int
    map_vec :: proc(v: Vector, f: proc(n: int) -> int) -> Vector {
        return {f(v[0]), f(v[1])}
    }

    non_zero_sign :: proc(n: int) -> int {
        return n == 0 ? 1 : n / utils.abs(n)
    }

    solve_part1 :: proc(input: string) -> (result: int) {
        lines := strings.split_lines(input)
        width := len(lines[0])
        height := len(lines)
        end_i: int
        end: Vector
        start_i: int

        buffer := make([]u8, width * height)
        mtx := make([][]u8, width)
        for line, y in lines {
            mtx[y] = buffer[y * width:(y + 1) * width]
            for c, x in line {
                idx := y * width + x
                switch c {
                case 'S':
                    buffer[idx] = 0
                    start_i = idx
                case 'E':
                    buffer[idx] = 25
                    end_i = idx
                    end = {x, y}
                case:
                    buffer[idx] = u8(c - 'a')
                }
            }
        }

        // for y in 0 ..< height {
        //     for x in 0 ..< width {
        //         if mtx[y][x] < 10 {
        //             fmt.printf("%d  ", mtx[y][x])
        //         } else {
        //             fmt.printf("%d ", mtx[y][x])
        //         }
        //     }
        //     fmt.print("\n")
        // }

        // fmt.print("idx:\n")

        // for y in 0 ..< height {
        //     for x in 0 ..< width {
        //         if x + y * width < 10 {
        //             fmt.printf("%d  ", x + y * width)
        //         } else {
        //             fmt.printf("%d ", x + y * width)
        //         }
        //     }
        //     fmt.print("\n")
        // }


        path: [dynamic]int
        visited := make([]bool, width * height)
        append(&path, start_i)

        print_path :: proc(path: [dynamic]int, mtx: [][]u8, w, h, end_i: int) {
            buffer := make([]rune, w * h)
            mtx_copy := make([][]rune, w)

            for y in 0 ..< h {
                mtx_copy[y] = buffer[y * w:(y + 1) * w]
                for x in 0 ..< w {
                    mtx_copy[y][x] = rune(mtx[y][x] + 'a')
                }
            }

            for idx, i in path {
                ix := idx % w
                iy := idx / w
                char: rune
                if i == 0 {
                    char = 'S'
                } else if idx == end_i {
                    char = 'E'
                } else {
                    prev := path[i - 1]
                    px := prev % w
                    py := prev / w
                    if px - 1 == ix {
                        char = '<'
                    } else if px + 1 == ix {
                        char = '>'
                    } else if py - 1 == iy {
                        char = '^'
                    } else {
                        char = 'v'
                    }
                }
                mtx_copy[iy][ix] = char
            }

            for y in 0 ..< h {
                for x in 0 ..< w {
                    fmt.printf("%c ", mtx_copy[y][x])
                }
                fmt.print("\n")
            }
        }

        fmt.printf("end: %d\n", end_i)

        for {
            curr_i := utils.last(path)
            curr := Vector{curr_i % width, curr_i / width}
            curr_h := buffer[curr_i]
            if curr_i == end_i {
                fmt.printf("found the end\n")
                print_path(path, mtx, width, height, end_i)
                break
            }

            d: Vector = {end.x - curr.x, end.y - curr.y}
            mx := non_zero_sign(d.x)
            my := non_zero_sign(d.y)

            dirs: [4]Vector =
                abs(d.x) > abs(d.y) \
                ? {{mx, 0}, {0, my}, {0, 0 - my}, {0 - mx, 0}} \
                : {{0, my}, {mx, 0}, {0 - mx, 0}, {0, 0 - my}}

            next: Vector
            next_i: int

            for_dirs: {
                for dir in dirs {
                    next = {curr.x + dir.x, curr.y + dir.y}
                    next_i = next.y * width + next.x

                    if next.x >= 0 &&
                       next.x < width &&
                       next.y >= 0 &&
                       next.y < height &&
                       buffer[next_i] - curr_h <= 1 &&
                       (buffer[next_i] - curr_h >= 0 || buffer[next_i] > 10) &&
                       visited[next_i] == false {
                        break for_dirs
                    }
                }
                // failed to find a direction
                // fmt.printf("failed to find a direction\n")
                // print_path(path, mtx, width, height, end_i)

                if len(path) == 1 {
                    fmt.printf("failed to find a path\n")
                    break
                }
                pop(&path)
                continue
            }

            assert(curr != next, "curr == next")
            // fmt.printf("curr: %d, next: %d\n", curr, next)
            append(&path, next_i)
            visited[next_i] = true
        }

        fmt.printf("path: %d\n", path)

        assert(utils.last(path) == end_i, "path doesn't end at the END")

        return len(path) - 1
    }

    solve_part2 :: proc(input: string) -> (result: int) {
        return
    }


    return solve_part1(input), solve_part2(input)
}
