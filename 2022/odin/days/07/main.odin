package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

Directory :: struct {
    parent:   ^Directory,
    size:     int, // own
    children: [dynamic]Directory,
}

parse_input :: proc(input: ^string) -> (root: Directory) {
    dir := &root
    for line in strings.split_lines_iterator(input) {
        if line[:4] == "$ ls" do continue
        if line[:3] == "dir" do continue
        if len(line) >= 6 && line[:6] == "$ cd /" do continue
        if len(line) >= 7 && line[:7] == "$ cd .." {
            dir = dir.parent
            continue
        }
        if line[:4] == "$ cd" {
            child := Directory {
                parent = dir,
            }
            append(&dir.children, child)
            dir = &child
            continue
        }
        pair := strings.split(line, " ")
        file_size := strconv.atoi(pair[0])
        dir.size += file_size
    }
    return
}

solve_part1 :: proc(input: ^string) -> (result: int) {
    dir := parse_input(input)

    fmt.println("dir:", dir, dir.size)

    return
}

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 7

main :: proc() {
    input := utils.read_input_file(DAY)
    fmt.println("part 1:", solve_part1(&input)) //
    fmt.println("part 2:", solve_part2(input)) //
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part1(&input), 95437)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part2(input), 0)
}
