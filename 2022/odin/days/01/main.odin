package main

import "core:fmt"

main :: proc() {
    program := "+ + * 😃 - /"
    accumulator := 0

    test_fn := proc() {
        fmt.print("Test")
    }


    test_fn()


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
