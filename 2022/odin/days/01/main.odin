package main

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"
import "core:path/filepath"


funny :: proc() {
    program := "+ + * 😃 - / 9"
    accumulator := 0


    for token in program {
        switch token {
        case '+':
            accumulator += 1
        case '-':
            accumulator -= 1
        case '*':
            accumulator *= 2
        case '/':
            accumulator /= 2
        case '😃':
            accumulator *= accumulator
        case '0' ..= '9':
            accumulator += -int('0' - token) // ??
        case: // Ignore everything else
        }
    }

    fmt.printf("The program \"%s\" calculates the value %d\n", program, accumulator)
}


// Alternative to `os.read_entire_file` I guess
read_file_or_panic :: proc(path: string) -> []byte {
    handle, open_err := os.open(path)
    if open_err > 0 {fmt.panicf("Open Error: %#v", open_err)}
    defer os.close(handle)

    length, size_err := os.file_size(handle)
    if size_err > 0 {fmt.panicf("File Size Error: %#v", open_err)}

    buf := make_slice([]byte, length) // make sure the slice is allocated on the heap
    _, read_err := os.read(handle, buf)
    if read_err > 0 {fmt.panicf("Read Error: %#v", open_err)}

    return buf
}


// Trying out iterators
Lines_Iterator :: struct {
    index, start, size: int,
    buf:                []byte,
}
make_lines_iterator :: proc(buf: []byte) -> Lines_Iterator {
    return Lines_Iterator{index = 0, start = 0, buf = buf, size = len(buf)}
}
each_lines :: proc(using it: ^Lines_Iterator) -> (line: string, cond: bool) {
    for index < size {
        defer index += 1 // so that it's always called, even if we return early
        if cond = buf[index] == 10; cond {     // 10 is a newline?
            line = string(buf[start:index])
            start = index + 1
            return
        }
    }

    if cond = start < size; cond {
        line = string(buf[start:size])
    }

    return
}

file_to_lines :: proc(buf: []byte) -> (lines: [dynamic]string) {
    size := len(buf)
    start := 0

    for i in 0 ..< size {
        if buf[i] == 10 {     // 10 is a newline?
            append(&lines, string(buf[start:i]))
            start = i + 1
        }
    }

    if start < size {
        append(&lines, string(buf[start:size]))
    }

    return
}

get_input_path :: proc(day: int, file: string = "input") -> string {
    builder := strings.builder_from_bytes([]byte{0, 0})

    if day < 10 {strings.write_int(&builder, 0)}
    strings.write_int(&builder, day)

    cwd := filepath.dir(#file)
    defer delete(cwd)
    day_string := strings.to_string(builder)
    filename := strings.concatenate([]string{file, ".txt"})
    return filepath.join([]string{cwd, "..", "..", "..", "data", day_string, filename})
}

read_input_file :: proc(day: int, file: string = "input") -> string {
    path := get_input_path(day, file)
    defer delete(path)
    return string(read_file_or_panic(path))
}

sum_slice :: proc(numbers: []int) -> int {
    result := 0
    for number in numbers {
        result += number
    }
    return result
}

main :: proc() {
    // funny()

    input := read_input_file(1, "input")
    defer delete(input)
    // lines := file_to_lines(buf)
    // defer delete(lines)

    // fmt.println("Lines out:", lines, len(lines))


    groups := strings.split(input, "\n\n")

    totals := slice.mapper(groups, proc(group: string) -> int {
        return sum_slice(slice.mapper(strings.split(group, "\n"), strconv.atoi))
    })

    max := slice.max(totals)

    fmt.println("Max:", max)
}
