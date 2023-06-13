package utils

import "core:os"
import "core:fmt"
import "core:strings"
import "core:path/filepath"

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
    return string(read_file_or_panic(path))
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
