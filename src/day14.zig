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
    std.debug.print("\n", .{});
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

fn copy_grid(grid: ArrayList(ArrayList(StoneType))) ArrayList(ArrayList(StoneType)) {
    var ret = ArrayList(ArrayList(StoneType)).init(allocator);

    for (grid.items) |row| {
        var new_row = ArrayList(StoneType).init(allocator);
        new_row.appendSlice(row.items) catch unreachable;
        ret.append(new_row) catch unreachable;
    }
    return ret;
}

fn grid_eql(left: ArrayList(ArrayList(StoneType)), right: ArrayList(ArrayList(StoneType))) bool {
    for (0..left.items.len) |y| {
        for (0..left.items[y].items.len) |x| {
            if (left.items[y].items[x] != right.items[y].items[x]) {
                return false;
            }
        }
    }
    return true;
}

fn part2(input: ArrayList(u8)) usize {
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
        // grid.append(row) catch unreachable;
    }

    // print_grid(grid);
    {
    var changed = true;
    var cycles_remaining: usize = 1000000000;

    var seen_grids = ArrayList(ArrayList(ArrayList(StoneType))).init(allocator);

    seen_grids.append(copy_grid(grid)) catch unreachable;

    while (changed and cycles_remaining > 0) {
        changed = false;
        cycles_remaining -= 1;

        // Move north
        {
        var n_changed = true;
        while (n_changed) {
            n_changed = false;

            for (0..grid.items.len) |y| {
                const row = grid.items[y];
                for (0..row.items.len) |x| {
                    if (row.items[x] == StoneType.RoundRock) {
                        if (y > 0 and grid.items[y-1].items[x] == StoneType.Empty) {
                            changed = true;
                            n_changed = true;
                            grid.items[y-1].items[x] = StoneType.RoundRock;
                            grid.items[y].items[x] = StoneType.Empty;
                        }
                    }
                }
            }
        }
        }

        // print_grid(grid);

        // Move west
        {
        var w_changed = true;
        while (w_changed) {
            w_changed = false;

            for (0..grid.items[0].items.len) |x| {
                for (0..grid.items.len) |y| {
                    if (grid.items[y].items[x] == StoneType.RoundRock) {
                        if (x > 0 and grid.items[y].items[x-1] == StoneType.Empty) {
                            changed = true;
                            w_changed = true;
                            grid.items[y].items[x-1] = StoneType.RoundRock;
                            grid.items[y].items[x] = StoneType.Empty;
                        }
                    }
                }
            }
        }
        }

        // print_grid(grid);

        // Move south
        {
        var s_changed = true;
        while (s_changed) {
            s_changed = false;

            for (0..grid.items.len) |y| {
                const row = grid.items[y];
                for (0..row.items.len) |x| {
                    if (row.items[x] == StoneType.RoundRock) {
                        if (y+1 < grid.items.len and grid.items[y+1].items[x] == StoneType.Empty) {
                            changed = true;
                            s_changed = true;
                            grid.items[y+1].items[x] = StoneType.RoundRock;
                            grid.items[y].items[x] = StoneType.Empty;
                        }
                    }
                }
            }
        }
        }

        // print_grid(grid);

        // Move east
        {
        var e_changed = true;
        while (e_changed) {
            e_changed = false;

            for (0..grid.items[0].items.len) |x| {
                for (0..grid.items.len) |y| {
                    if (grid.items[y].items[x] == StoneType.RoundRock) {
                        if (x+1 < grid.items[y].items.len and grid.items[y].items[x+1] == StoneType.Empty) {
                            changed = true;
                            e_changed = true;
                            grid.items[y].items[x+1] = StoneType.RoundRock;
                            grid.items[y].items[x] = StoneType.Empty;
                        }
                    }
                }
            }
        }
        }

        // print_grid(grid);
        // std.debug.print("{}\n", .{cycles_remaining});

        for (0..seen_grids.items.len) |grid_i| {
            if (grid_eql(seen_grids.items[grid_i], grid)) {
                // std.debug.print("Found it {} == {}\n", .{grid_i, 1000000000 - cycles_remaining});
                const end_i = grid_i + ((1000000000 - grid_i) % (1000000000 - cycles_remaining - grid_i));
                // std.debug.print("{} {}\n", .{end_i, seen_grids.items.len});
                grid = seen_grids.items[end_i];
                changed = false;
                break;
            }
        }
        seen_grids.append(copy_grid(grid)) catch unreachable;
    }
    }

    // print_grid(grid);

    for (0..grid.items.len) |y| {
        const row = grid.items[y];
        for (0..row.items.len) |x| {
            if (row.items[x] == StoneType.RoundRock) {
                ret += grid.items.len - y;
            }
        }
    }
    // 88812 --> too low
    return ret;
}
