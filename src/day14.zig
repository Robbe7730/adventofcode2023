const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

const StoneType = enum {
    Empty,
    SquareRock,
    RoundRock,
};

fn print_grid(grid: ArrayList(ArrayList(StoneType))) void {
    for (grid.items) |row| {
        for (row.items) |cell| {
            switch (cell) {
                StoneType.Empty => std.debug.print(".", .{}),
                StoneType.RoundRock => std.debug.print("O", .{}),
                StoneType.SquareRock => std.debug.print("#", .{})
            }
        }
        std.debug.print("\n", .{});
    }
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 0;

    var grid = ArrayList(ArrayList(StoneType)).init(allocator);
    {
        var row = ArrayList(StoneType).init(allocator);
        var i: usize = 0;
        while (i < input.items.len) {
            if (input.items[i] == '\n') {
                grid.append(row) catch unreachable;
                row = ArrayList(StoneType).init(allocator);
            } else if (input.items[i] == '#') {
                row.append(StoneType.SquareRock) catch unreachable;
            } else if (input.items[i] == 'O') {
                row.append(StoneType.RoundRock) catch unreachable;
            } else if (input.items[i] == '.') {
                row.append(StoneType.Empty) catch unreachable;
            } else { unreachable; }

            i += 1;
        }
        grid.append(row) catch unreachable;
    }

    // print_grid(grid);
    // Move north
    {
    var changed = true;

    while (changed) {
        changed = false;
        for (0..grid.items.len) |y| {
            const row = grid.items[y];
            for (0..row.items.len) |x| {
                if (row.items[x] == StoneType.RoundRock) {
                    if (y > 0 and grid.items[y-1].items[x] == StoneType.Empty) {
                        changed = true;
                        grid.items[y-1].items[x] = StoneType.RoundRock;
                        grid.items[y].items[x] = StoneType.Empty;
                    }
                }
            }
        }
    }
    }

    // print_grid(grid);

    for (0..grid.items.len) |y| {
        const row = grid.items[y];
        for (0..row.items.len) |x| {
            if (row.items[x] == StoneType.RoundRock) {
                ret += grid.items.len - y - 1;
            }
        }
    }
    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
