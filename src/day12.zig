const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;
const read_num = @import("shared.zig").read_num;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

const Cell = enum(u8) {
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

fn calculate_solutions(
    cells: ArrayList(Cell),
    numbers: ArrayList(usize),
    g_running_count: usize,
    g_numbers_i: usize,
    g_unknown_i: usize,
) usize {
    // print_cells(cells);
    // Check if we have a solution
    var is_solution = true;
    var running_count = g_running_count;
    var numbers_i = g_numbers_i;
    var unknown_i: usize = g_unknown_i;
    for (cells.items[g_unknown_i..]) |cell| {
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
        unknown_i += 1;
    }
    
    if (numbers_i == numbers.items.len) {
        var has_on = false;

        for (cells.items[unknown_i..]) |cell| {
            if (cell == Cell.On) {
                has_on = true;
                break;
            }
        }
        if (!has_on) {
            return 1;
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

    var ret: usize = 0;
    cells.items[unknown_i] = Cell.On;
    ret += calculate_solutions(cells, numbers, running_count, numbers_i, unknown_i);
    cells.items[unknown_i] = Cell.Off;
    ret += calculate_solutions(cells, numbers, running_count, numbers_i, unknown_i);
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

        const num_solutions = calculate_solutions(cells, numbers, 0, 0, 0);

        // std.debug.print("{}\n", .{num_solutions});

        ret += num_solutions;
    }

    return ret;
}

fn thread_fn(cells: ArrayList(Cell), numbers: ArrayList(usize), line_num: usize, ret: *usize) void {
    const start = std.time.milliTimestamp();
    const num_solutions = calculate_solutions(cells, numbers, 0, 0, 0);

    _ = @atomicRmw(usize, ret, .Add, num_solutions, std.atomic.Ordering.Monotonic);

    std.debug.print("{} ({}) ({} ms) -> {}\n", .{num_solutions, line_num, std.time.milliTimestamp() - start, ret.*});
}

fn part2(input: ArrayList(u8)) usize {
    var i: usize = 0;
    var ret: usize = 0;
    var line_num: usize = 0;

    var all_cells = ArrayList(ArrayList(Cell)).init(allocator);
    var all_numbers = ArrayList(ArrayList(usize)).init(allocator);

    while (i < input.items.len) {
        line_num += 1;
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

        // Expand cells and numbers
        var new_cells = ArrayList(Cell).init(allocator);
        var new_numbers= ArrayList(usize).init(allocator);
        for (0..5) |rep| {
            for (cells.items) |c| {
                new_cells.append(c) catch unreachable;
            }

            for (numbers.items) |n| {
                new_numbers.append(n) catch unreachable;
            }

            if (rep != 4) {
                new_cells.append(Cell.Unknown) catch unreachable;
            }
        }

        all_cells.append(new_cells) catch unreachable;
        all_numbers.append(new_numbers) catch unreachable;
    }

    var threads = ArrayList(std.Thread).init(allocator);
    for (0..all_cells.items.len) |cells_num| {
        var thread = std.Thread.spawn(
            .{},
            thread_fn,
            .{
                all_cells.items[cells_num],
                all_numbers.items[cells_num],
                cells_num,
                &ret
            }
        ) catch unreachable;
        threads.append(thread) catch unreachable;
    }

    for (threads.items) |t| {
        t.join();
    }

    return ret;
}
