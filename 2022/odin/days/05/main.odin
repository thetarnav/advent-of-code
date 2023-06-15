package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:testing"
import "../../utils"

reverse :: proc(array: [dynamic]$E) {
    if len(array) == 0 do return
    for i := 0; i < len(array) / 2; i += 1 {
        j := len(array) - 1 - i
        array[i], array[j] = array[j], array[i]
    }
}

last :: proc(array: [dynamic]$E) -> E {
    return array[len(array) - 1]
}

move_splits :: []string{"move ", " from ", " to "}

move_line_values :: proc(line: string) -> (from, to, amount: int) {
    vals := slice.mapper(strings.split_multi(line, move_splits), strconv.atoi)
    return vals[2] - 1, vals[3] - 1, vals[1]
}

solve_part1 :: proc(input: string, n_cols: int) -> (result: string) {
    state: [9][dynamic]rune
    moves_start: int
    lines := strings.split_lines(input)

    for line, line_i in lines {
        if (line[1] == '1') {
            moves_start = line_i + 2
            break
        }

        for i in 0 ..< (len(line) + 1) / 4 {
            char := rune(line[i * 4 + 1])
            if (char > 'A') do append_elem(&state[i], char)
        }
    }

    for col, i in state do reverse(col)

    for move in lines[moves_start:] {
        from, to, amount := move_line_values(move)

        for _ in 0 ..< amount {
            append_elem(&state[to], pop(&state[from]))
        }
    }

    result_builder := strings.builder_make()
    for col in state {
        if len(col) == 0 do continue
        strings.write_rune(&result_builder, last(col))
    }

    return strings.to_string(result_builder)
}

solve_part2 :: proc(input: string) -> (result: int) {
    return
}

DAY :: 5
EXAMPLE_COLS :: 3
INPUT_COLS :: 9

main :: proc() {
    input := utils.read_input_file(DAY)
    result1 := solve_part1(input, INPUT_COLS)
    fmt.println("part 1:", result1) // VQZNJMWTR
    fmt.println("part 2:", solve_part2(input)) //
}

@(test)
test_part1 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    result := solve_part1(input, EXAMPLE_COLS)
    testing.expect_value(t, result, "CMZ")
}

@(test)
test_part2 :: proc(t: ^testing.T) {
    input := utils.read_input_file(DAY, "example")
    testing.expect_value(t, solve_part2(input), 0)
}
