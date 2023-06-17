package utils

import "core:os"
import "core:fmt"
import "core:strings"
import "core:slice"
import "core:path/filepath"

get_input_path :: proc(day: int, file: string = "input") -> string {
    builder := strings.builder_from_bytes([]byte{0, 0})

    if day < 10 {strings.write_int(&builder, 0)}
    strings.write_int(&builder, day)

    cwd := filepath.dir(#file)
    defer delete(cwd)
    day_string := strings.to_string(builder)
    filename := strings.concatenate([]string{file, ".txt"})
    return filepath.join([]string{cwd, "..", "..", "data", day_string, filename})
}

read_input_file :: proc(day: int, file: string = "input") -> string {
    path := get_input_path(day, file)
    defer delete(path)
    data, ok := os.read_entire_file(path)
    if !ok do fmt.panicf("Failed to read file: %s", path)
    return strings.trim_right(string(data), "\n")
}

trim_whitespace :: proc(content: string) -> string {
    return strings.trim(content, " \t\n")
}

sum_slice :: proc(numbers: []int) -> int {
    result := 0
    for number in numbers {
        result += number
    }
    return result
}

sum_int :: proc(a: int, b: int) -> int {
    return a + b
}

sum :: proc {
    sum_int,
    sum_slice,
}

rune_to_int :: proc(c: rune) -> (result: int) {
    return int(c - '0')
}

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

iterate_matrix :: proc(size: int, idx: ^int) -> (x, y: int, cond: bool) {
    i := idx^
    if i < size * size {
        x = i % size
        y = i / size
        cond = true
        idx^ += 1
    }
    return
}

iterate_matrix_shrink :: proc(size: int, idx: ^int) -> (x, y: int, cond: bool) {
    x, y, cond = iterate_matrix(size, idx)
    if cond {
        y = y % 2 == 0 ? y / 2 : size - y / 2 - 1
        x = x % 2 == 0 ? x / 2 : size - x / 2 - 1
    }
    return
}

is_unique_slice :: proc(list: []u8) -> bool {
    if len(list) < 2 do return true

    for i in 1 ..< len(list) {
        if (list[0] == list[i]) do return false
    }

    return is_unique_slice(list[1:])
}

is_unique_string :: proc(str: string) -> bool {
    return is_unique_slice(transmute([]u8)str)
}

is_unique :: proc {
    is_unique_slice,
    is_unique_string,
}
