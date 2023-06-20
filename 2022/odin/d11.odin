package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d11: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {

    add: Operation_Proc : proc(old: int, payload: int) -> (result: int) {
        return old + payload
    }
    mul: Operation_Proc : proc(old: int, payload: int) -> (result: int) {
        return old * payload
    }
    mul_self: Operation_Proc : proc(old: int, payload: int) -> (result: int) {
        return old * old
    }

    Operation_Proc :: #type proc(old: int, payload: int) -> (result: int)

    Monkey :: struct {
        items:             [dynamic]int,
        operation_proc:    Operation_Proc,
        operation_payload: int,
        test:              int,
        if_true:           int,
        if_false:          int,
        interactions:      int,
    }

    STARTING_ITEMS_PREFIX :: "  Starting items: "
    TEST_PREFIX :: "  Test: divisible by "

    solve_part1 :: proc(input: string) -> (result: int) {

        monkeys: [dynamic]^Monkey

        {
            i := -1
            for line in strings.split_lines(input) {
                if strings.has_prefix(line, "Monkey") {
                    append(&monkeys, new(Monkey))
                    i += 1
                } else if strings.has_prefix(line, STARTING_ITEMS_PREFIX) {
                    for char in strings.split(line[len(STARTING_ITEMS_PREFIX):], ", ") {
                        num := strconv.atoi(char)
                        append(&monkeys[i].items, num)
                    }
                } else if strings.has_prefix(line, "  Operation: new = old ") {
                    procedure := line[23:] == "* old" ? mul_self : line[23] == '+' ? add : mul
                    monkeys[i].operation_proc = procedure
                    monkeys[i].operation_payload = strconv.atoi(line[25:])
                } else if strings.has_prefix(line, TEST_PREFIX) {
                    monkeys[i].test = strconv.atoi(line[len(TEST_PREFIX):])
                } else if strings.has_prefix(line, "    If true") {
                    monkeys[i].if_true = strconv.atoi(line[29:])
                } else if strings.has_prefix(line, "    If false") {
                    monkeys[i].if_false = strconv.atoi(line[30:])
                }
            }
        }

        for round in 0 ..< 20 {
            for monkey, i in monkeys {
                monkey.interactions += len(monkey.items)
                for _item in monkey.items {
                    item := monkey.operation_proc(_item, monkey.operation_payload)
                    item /= 3
                    target_i := item % monkey.test == 0 ? monkey.if_true : monkey.if_false
                    append(&monkeys[target_i].items, item)
                }
                clear(&monkey.items)
            }
        }

        interactions := slice.mapper(monkeys[:], proc(monkey: ^Monkey) -> int {
            return monkey.interactions
        })

        top_two := utils.top_n(interactions, 2)

        return top_two[0] * top_two[1]
    }

    solve_part2 :: proc(input: string) -> (result: int) {
        return
    }


    return solve_part1(input), solve_part2(input)
}
