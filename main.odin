package main

import "core:os"
import "core:fmt"
import "core:slice"

BUFFER_SIZE :: 512

launch_interactive :: proc() {
    data_buff := make([]u8, BUFFER_SIZE)
    defer delete(data_buff)

    err : os.Errno = 0
    read_count := 1
    for read_count > 0 {
        slice.fill(data_buff[:], 0)
        read_count, err = os.read(0, data_buff)
        if err != 0 {
            fmt.fprintf(os.stderr, "ERROR: could not read stdin: %d", err)
            return
        }
        fmt.print(string(data_buff))
    }
}

print_file :: proc(file: string) {
    file_bytes, ok := os.read_entire_file(file)
    if !ok {
        fmt.fprintf(os.stderr, "ERROR: could not read file at %s", file)
        return
    }
    defer delete(file_bytes)

    file_content := string(file_bytes)
    fmt.print(file_content)
}

main :: proc() {
    args := os.args[1:]
    if (len(args) == 0) {
        launch_interactive()
    }
    for arg in args {
        switch arg {
            case "-":
                launch_interactive()
            case:
                print_file(arg)
        }
    }
}
