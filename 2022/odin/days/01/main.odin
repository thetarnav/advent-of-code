package main

import "core:os"
import "core:fmt"

funny :: proc() {
    program := "+ + * 😃 - /"
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
        case: // Ignore everything else
        }
    }

    fmt.printf("The program \"%s\" calculates the value %d\n", program, accumulator)
}

read_file_lines :: proc(path: string) -> (lines: [dynamic]string, err: os.Errno) {
    // input := [dynamic]string

    f, open_err := os.open(path)
    err = open_err
    defer os.close(f)

    if err != os.ERROR_NONE {
        return
    }

    fmt.printf("File: %s\n", f)
    fmt.printf("Error: %s\n", err)

    {
        buf: [1024]byte // an array of 1024 bytes, because we know the length at compile time
        buf_slice := buf[:] // a slice, becasue we don't know the length at compile time?

        fmt.println("Buf:", buf, ' ')
        fmt.println("Buf slice:", buf_slice, ' ')

        i, read_err := os.read(f, buf_slice)

        fmt.printf("Read %d bytes\n", i)
        fmt.printf("Error: %s\n", read_err)
        fmt.printf("Data: %s\n", buf)
    }


    // for {
    //     fmt.printf("Enter something: ")
    //     input = os.readln()

    //     if input == "quit" {
    //         break
    //     }

    //     fmt.printf("You entered \"%s\"\n", input)
    // }

    return
}

main :: proc() {
    // funny()


    lines, err := read_file_lines("../../../data/01/example.txt")

    if err != os.ERROR_NONE {
        fmt.printf("Error: %d\n", err)
        return
    }

    for line in lines {
        fmt.printf("You entered \"%s\"\n", line)
    }


}
