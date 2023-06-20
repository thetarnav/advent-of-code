package aoc

import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d05: Day_Proc = proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {
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

    n_cols := input_type == .Example ? 3 : 9
    return solve_part1(input, n_cols), solve_part2(input, n_cols)
}
