package main

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:testing"
import "../../utils"

sum_group :: proc(group: string) -> int {
    return utils.sum(slice.mapper(strings.split(group, "\n"), strconv.atoi))
}

solve_part1 :: proc(input: string) -> int {
    groups := strings.split(input, "\n\n")
    totals := slice.mapper(groups, sum_group)
    return slice.max(totals)
}

solve_part2 :: proc(input: string) -> int {
    max := [3]int{0, 0, 0}

    for group in strings.split(input, "\n\n") {
        total := sum_group(group)

        for i in 0 ..< 3 {
            if total > max[i] {
                // shift the rest of the array down to preserve order
                for j := 2; j > i; j -= 1 {
                    max[j] = max[j - 1]
                }
                // max is always on the left
                max[i] = total
                break
            }
        }
    }

    return utils.sum(max[:])
}

DAY :: 1

main :: proc() {
    input := utils.read_input_file(DAY)

    fmt.println("part 1:", solve_part1(input))

    fmt.println("part 2:", solve_part2(input))
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part1(input), 24000)
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")

    testing.expect_value(t, solve_part2(input), 45000)
}
