package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:testing"
import "../../utils"

move_splits :: []string{"move ", " from ", " to "}

move_line_values :: proc(line: string) -> (from, to, amount: int) {
    vals := slice.mapper(strings.split_multi(line, move_splits), strconv.atoi)
    return vals[2] - 1, vals[3] - 1, vals[1]
}

parse_initial_state :: proc(
    lines: []string,
    n_cols: int,
) -> (
    state: [][dynamic]rune,
    moves: []string,
) {
    state = make([][dynamic]rune, n_cols)

    for line, line_i in lines {
        if (line[1] == '1') {
            moves = lines[line_i + 2:]
            break
        }

        for i in 0 ..< (len(line) + 1) / 4 {
            char := rune(line[i * 4 + 1])
            if (char > 'A') do append(&state[i], char)
        }
    }

    for col, i in state do utils.reverse(col)

    return
}

solve_part1 :: proc(input: string, n_cols: int) -> (result: string) {
    lines := strings.split_lines(input)
    state, moves := parse_initial_state(lines, n_cols)

    for move in moves {
        from, to, amount := move_line_values(move)
        for _ in 0 ..< amount do append(&state[to], pop(&state[from]))
    }

    result_builder := strings.builder_make()
    for col in state do strings.write_rune(&result_builder, utils.last(col))
    return strings.to_string(result_builder)
}

solve_part2 :: proc(input: string, n_cols: int) -> (result: string) {
    lines := strings.split_lines(input)
    state, moves := parse_initial_state(lines, n_cols)

    for move in moves {
        from, to, amount := move_line_values(move)
        end := len(state[from]) - amount
        append(&state[to], ..state[from][end:])
        resize(&state[from], end)
    }

    result_builder := strings.builder_make()
    for col in state do strings.write_rune(&result_builder, utils.last(col))
    return strings.to_string(result_builder)
}

DAY :: 5
EXAMPLE_COLS :: 3
INPUT_COLS :: 9

main :: proc() {
    input := utils.read_input_file(DAY)
    result1 := solve_part1(input, INPUT_COLS)
    fmt.println("part 1:", result1) // VQZNJMWTR
    result2 := solve_part2(input, INPUT_COLS)
    fmt.println("part 2:", result2) // NLCDCLVMQ
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
    result := solve_part2(input, EXAMPLE_COLS)
    testing.expect_value(t, result, "MCD")
}
