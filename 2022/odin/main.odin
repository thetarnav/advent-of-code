package aoc

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:time"
import "core:mem"
import "core:mem/virtual"
import "core:path/filepath"
import "core:runtime"
import "core:testing"

Result :: union {
    int,
    u64,
    string,
}

Input_Type :: enum {
    Input,
    Example,
}

Day_Proc :: proc(input: string, input_type: Input_Type) -> (part1: Result, part2: Result)

read_input_file :: proc(day: string, file: string) -> string {
    cwd := filepath.dir(#file);defer delete(cwd)

    filename := strings.concatenate([]string{file, ".txt"})
    path := filepath.join([]string{cwd, "..", "data", day, filename})
    defer delete(path)

    data, ok := os.read_entire_file(path)
    if !ok do fmt.panicf("Failed to read file: %s", path)
    return strings.trim_right(string(data), "\n")
}

print_result :: proc(result: Result) {
    #partial switch in result {
    case string:
        padding := 0
        it := result
        for line in strings.split_lines_iterator(&it.(string)) {
            for i in 0 ..< padding do fmt.printf(" ")
            fmt.println(line)
            padding = 11
        }
    case:
        fmt.printf("%v\n", result)
    }
}

copy_result :: proc(result: Result, allocator: runtime.Allocator) -> Result {
    #partial switch in result {
    case string:
        copy_result := make([]u8, len(result.(string)), allocator)
        copy(copy_result, result.(string))
        return string(copy_result)
    case:
        return result
    }
}

run :: proc(
    day: string,
    procedure: Day_Proc,
    input_type: Input_Type,
) -> (
    part1: Result,
    part2: Result,
    exec_time: f64,
) {
    input_file := input_type == Input_Type.Input ? "input" : "example"
    input := read_input_file(day, input_file)

    arena: virtual.Arena
    prev_allocator: mem.Allocator

    assert(virtual.arena_init_growing(&arena) == virtual.Allocator_Error.None)
    prev_allocator, context.allocator = context.allocator, virtual.arena_allocator(&arena)
    defer {
        context.allocator = prev_allocator
        virtual.arena_destroy(&arena)
    }

    stopwatch: time.Stopwatch

    time.stopwatch_start(&stopwatch)
    part1, part2 = procedure(input, input_type)
    time.stopwatch_stop(&stopwatch)

    exec_time += time.duration_milliseconds(stopwatch._accumulation)

    part1 = copy_result(part1, prev_allocator)
    part2 = copy_result(part2, prev_allocator)

    return
}

days := map[string]Day_Proc {
    "01" = d01,
    "02" = d02,
    "03" = d03,
    "04" = d04,
    "05" = d05,
    "06" = d06,
    "07" = d07,
    "08" = d08,
    "09" = d09,
    "10" = d10,
}

get_arg_days :: proc() -> []string {
    keys: [dynamic]string
    for i := 1; i < len(os.args); i += 1 {
        _, ok := days[os.args[i]]
        if !ok do fmt.panicf("Invalid argument: %s", os.args[i])
        append(&keys, os.args[i])
    }
    if len(keys) == 0 {
        for key, _ in days do append(&keys, key)
    }
    return keys[:]
}

main :: proc() {
    fmt.println("Advent of Code 2022")

    keys := get_arg_days();defer delete(keys)

    total_time := 0.0
    for day in keys {
        part1, part2, exec_time := run(day, days[day], Input_Type.Input)

        fmt.printf("%s -- %fms\n   part 1: ", day, exec_time)
        print_result(part1)
        fmt.printf("   part 2: ")
        print_result(part2)

        total_time += exec_time
    }

    fmt.println("total - ", total_time, "ms")
}

result_to_string :: proc(result: Result) -> string {
    #partial switch in result {
    case string:
        return result.(string)
    case:
        sb := strings.builder_make()
        strings.write_int(&sb, result.(int))
        return strings.to_string(sb)
    }
}

@(test)
test_run :: proc(t: ^testing.T) {
    fmt.println("Advent of Code 2022 Examples")

    keys := get_arg_days();defer delete(keys)

    total_time := 0.0
    for day in keys {
        part1, part2, exec_time := run(day, days[day], Input_Type.Example)
        total_time += exec_time

        fmt.printf("%s -- %fms\n", day, exec_time)

        expected := strings.split(read_input_file(day, "example_solution"), "---PART-2---")

        testing.expect_value(t, result_to_string(part1), strings.trim(expected[0], "\n"))
        testing.expect_value(t, result_to_string(part2), strings.trim(expected[1], "\n"))
    }

    fmt.println("total - ", total_time, "ms")
}
