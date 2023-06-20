package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d07: Day_Proc = proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
    Directory :: struct {
        parent:   ^Directory,
        size:     int, // own
        children: [dynamic]^Directory,
    }

    parse_input :: proc(input: string) -> (dirs: [dynamic]^Directory) {
        root := new(Directory)
        append(&dirs, root)
        dir := root
        for line in strings.split_lines(input) {
            if line[:4] == "$ ls" do continue
            if line[:3] == "dir" do continue
            if len(line) >= 6 && line[:6] == "$ cd /" do continue
            if len(line) >= 7 && line[:7] == "$ cd .." {
                dir = dir.parent
                continue
            }
            if line[:4] == "$ cd" {
                child := new(Directory)
                child.parent = dir
                append(&dir.children, child)
                dir = child
                append(&dirs, child)
                continue
            }
            pair := strings.split(line, " ")
            file_size := strconv.atoi(pair[0])
            c := dir
            for c != nil {
                c.size += file_size
                c = c.parent
            }
        }
        return
    }

    solve_part1 :: proc(input: string) -> (result: int) {
        dirs := parse_input(input)
        for dir in dirs {
            if dir.size <= 100000 do result += dir.size
        }
        return
    }

    solve_part2 :: proc(input: string) -> (result: int) {
        total :: 70000000
        needed :: 30000000
        dirs := parse_input(input)
        used := dirs[0].size
        unused := total - used
        to_delete := needed - unused
        sufficing: [dynamic]int
        for dir in dirs {
            if dir.size >= to_delete do append(&sufficing, dir.size)
        }
        slice.sort(sufficing[:])
        return sufficing[0]
    }

    return solve_part1(input), solve_part2(input)
}
