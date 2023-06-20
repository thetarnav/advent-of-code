package aoc

import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d02: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
    get_battle_points :: proc(foe: int, me: int) -> int {
        return me + 1 + (me - foe + 1) %% 3 * 3
    }

    solve_part1 :: proc(input: string) -> (points: int) {
        for line in strings.split_lines(input) {
            foe := int(line[0] - 'A')
            me := int(line[2] - 'X')
            points += get_battle_points(foe, me)
        }
        return
    }

    solve_part2 :: proc(input: string) -> (points: int) {
        for line in strings.split_lines(input) {
            foe := int(line[0] - 'A')
            res := int(line[2] - 'X')
            me := (foe + (res - 1)) %% 3
            points += get_battle_points(foe, me)
        }
        return
    }

    return solve_part1(input), solve_part2(input)
}
