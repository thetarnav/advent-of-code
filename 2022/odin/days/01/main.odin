package main

import "core:os"
import "core:fmt"

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
manual_read_file :: proc(path: string) -> (buf: []byte) {
    handle, open_err := os.open(path)
    if open_err > 0 {fmt.panicf("Open Error: %#v", open_err)}
    defer os.close(handle)

    buf = make([]byte, 1024)
    // defer delete(buf) // breaks stuff (for some malloc reason)
    size, read_err := os.read(handle, buf)


    if read_err > 0 {fmt.panicf("Read Error: %#v", open_err)}

    return buf[:size]
}

file_to_lines :: proc(buf: []byte) -> (lines: [dynamic]string) {
    size := len(buf)
    start := 0

    for i in 0 ..< size {
        if buf[i] == 10 {     // 10 is a newline?
            append_elem(&lines, string(buf[start:i]))
            start = i + 1
        }
    }

    if start < size {
        append_elem(&lines, string(buf[start:size]))
    }

    return
}

main :: proc() {
    funny()


    buf := manual_read_file("../../../data/01/example.txt")
    defer delete(buf)
    lines := file_to_lines(buf)
    defer delete(lines)

    fmt.println("Lines out:", lines)

    // for line in lines {
    //     fmt.println("You entered:", line)
    // }


}
