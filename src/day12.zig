const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;
const read_num = @import("shared.zig").read_num;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

const Cell = enum(usize) {
    On,
    Off,
    Unknown
};

fn print_cells(cells: ArrayList(Cell)) void {
    for (cells.items) |cell| {
        if (cell == Cell.Off) {
            std.debug.print(".", .{});
        } else if (cell == Cell.On) {
            std.debug.print("#", .{});
        } else {
            std.debug.print("?", .{});
        }
    }
    std.debug.print("\n", .{});
}

fn calculate_solutions(cells: ArrayList(Cell), numbers: ArrayList(usize)) usize {
    // print_cells(cells);
    // Check if we have a solution
    var is_solution = true;
    var numbers_i: usize = 0;
    var running_count: usize = 0;
    for (cells.items) |cell| {
        // std.debug.print("rc: {}, n_i: {}\n", .{running_count, numbers_i});
        if (cell == Cell.Unknown) {
            is_solution = false;
            break;
        } else if (cell == Cell.Off) {
            if (running_count > 0 and running_count != numbers.items[numbers_i]) {
                return 0;
            }
            if (running_count > 0) {
                running_count = 0;
                numbers_i += 1;
            }
        } else if (cell == Cell.On) {
            running_count += 1;
            if (numbers_i >= numbers.items.len or running_count > numbers.items[numbers_i]) {
                return 0;
            }
        }
    }

    if (is_solution) {
        if (numbers_i == numbers.items.len - 1 and running_count == numbers.items[numbers_i]) {
            numbers_i += 1;
        }
        if (numbers_i < numbers.items.len) {
            return 0;
        }
        // std.debug.print("Solution \\o/\n", .{});
        return 1;
    }

    // Find the first Unknown and replace it with On and Off
    var unknown_i: usize = 0;

    while (cells.items[unknown_i] != Cell.Unknown) {
        unknown_i += 1;
    }

    var ret: usize = 0;
    cells.items[unknown_i] = Cell.On;
    ret += calculate_solutions(cells, numbers);
    cells.items[unknown_i] = Cell.Off;
    ret += calculate_solutions(cells, numbers);
    cells.items[unknown_i] = Cell.Unknown;
    return ret;
}

fn part1(input: ArrayList(u8)) usize {
    var i: usize = 0;
    var ret: usize = 0;

    while (i < input.items.len) {
        // Read cells
        var cells = ArrayList(Cell).init(allocator);
        while (input.items[i] != ' ') {
            if (input.items[i] == '#') {
                cells.append(Cell.On) catch unreachable;
            } else if (input.items[i] == '.') {
                cells.append(Cell.Off) catch unreachable;
            } else if (input.items[i] == '?') {
                cells.append(Cell.Unknown) catch unreachable;
            } else {
                unreachable;
            }
            i += 1;
        }

        // Read numbers
        var numbers = ArrayList(usize).init(allocator);
        while (input.items[i] != '\n') {
            // Skip comma
            i += 1;

            numbers.append(read_num(&i, input)) catch unreachable;
        }

        // Skip newline
        i += 1;

        const num_solutions = calculate_solutions(cells, numbers);

        // std.debug.print("{}\n", .{num_solutions});

        ret += num_solutions;
    }

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
