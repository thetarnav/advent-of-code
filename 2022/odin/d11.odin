package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "./utils"

d11: Day_Proc : proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result) {

    add: Operation_Proc : proc(old: u64, payload: u64) -> (result: u64) {
        return old + payload
    }
    mul: Operation_Proc : proc(old: u64, payload: u64) -> (result: u64) {
        return old * payload
    }
    mul_self: Operation_Proc : proc(old: u64, payload: u64) -> (result: u64) {
        return old * old
    }

    Operation_Proc :: #type proc(old: u64, payload: u64) -> (result: u64)

    Monkey :: struct {
        items:             [dynamic]u64,
        operation_proc:    Operation_Proc,
        operation_payload: u64,
        test:              u64,
        if_true:           int,
        if_false:          int,
        interactions:      int,
    }

    STARTING_ITEMS_PREFIX :: "  Starting items: "
    TEST_PREFIX :: "  Test: divisible by "

    solve :: proc(input: string, rounds: int, does_divide: bool) -> (result: int) {
        monkeys: [dynamic]^Monkey
        mod: u64 = 1

        {
            i := -1
            for line in strings.split_lines(input) {
                if strings.has_prefix(line, "Monkey") {
                    append(&monkeys, new(Monkey))
                    i += 1
                } else if strings.has_prefix(line, STARTING_ITEMS_PREFIX) {
                    for char in strings.split(line[len(STARTING_ITEMS_PREFIX):], ", ") {
                        num := strconv.atoi(char)
                        append(&monkeys[i].items, u64(num))
                    }
                } else if strings.has_prefix(line, "  Operation: new = old ") {
                    procedure := line[23:] == "* old" ? mul_self : line[23] == '+' ? add : mul
                    monkeys[i].operation_proc = procedure
                    monkeys[i].operation_payload = u64(strconv.atoi(line[25:]))
                } else if strings.has_prefix(line, TEST_PREFIX) {
                    test := u64(strconv.atoi(line[len(TEST_PREFIX):]))
                    monkeys[i].test = test
                    mod *= test
                } else if strings.has_prefix(line, "    If true") {
                    monkeys[i].if_true = strconv.atoi(line[29:])
                } else if strings.has_prefix(line, "    If false") {
                    monkeys[i].if_false = strconv.atoi(line[30:])
                }
            }
        }

        for _ in 0 ..< rounds {
            for monkey in monkeys {
                monkey.interactions += len(monkey.items)
                for _item in monkey.items {
                    item := monkey.operation_proc(_item, monkey.operation_payload)
                    if does_divide do item /= 3
                    else do item %= mod
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


    return solve(input, 20, true), solve(input, 10000, false)
}
