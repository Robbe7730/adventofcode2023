const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) usize {
    var grids = ArrayList(ArrayList(ArrayList(bool))).init(allocator);
    {
    var i: usize = 0;
    var grid = ArrayList(ArrayList(bool)).init(allocator);
    var row = ArrayList(bool).init(allocator);
    while (i < input.items.len) {
        if (input.items[i] == '\n') {
            grid.append(row) catch unreachable;
            row = ArrayList(bool).init(allocator);
            if (i+1 < input.items.len and input.items[i+1] == '\n') {
                i += 1;
                grids.append(grid) catch unreachable;
                grid = ArrayList(ArrayList(bool)).init(allocator);
            }
        } else if (input.items[i] == '#') {
            row.append(true) catch unreachable;
        } else if (input.items[i] == '.') {
            row.append(false) catch unreachable;
        } else { unreachable; }
        
        i += 1;
    }
    grids.append(grid) catch unreachable;
    }

    var ret: usize = 0;

    for (grids.items) |grid| {
        var vertical_mirrors = ArrayList(bool).init(allocator);
        for (0..grid.items[0].items.len-1) |_| {
            vertical_mirrors.append(true) catch unreachable;
        }
        for (grid.items) |row| {
            for (0..grid.items[0].items.len-1) |vmirror_i| {
                if (!vertical_mirrors.items[vmirror_i]) {
                    continue;
                }
                for (0..vmirror_i+1) |cell_i| {
                    if (vmirror_i + cell_i + 1 >= row.items.len) {
                        continue;
                    }
                    if (row.items[vmirror_i - cell_i] != row.items[vmirror_i + cell_i + 1]) {
                        vertical_mirrors.items[vmirror_i] = false;
                        break;
                    }
                }
            }
        }

        var horizontal_mirrors = ArrayList(bool).init(allocator);
        for (0..grid.items.len-1) |_| {
            horizontal_mirrors.append(true) catch unreachable;
        }

        for (0..grid.items.len-1) |hmirror_i| {
            for (0..grid.items[0].items.len) |col| {
                for (0..hmirror_i+1) |cell_i| {
                    if (hmirror_i + cell_i + 1 >= grid.items.len) {
                        continue;
                    }
                    if (grid.items[hmirror_i - cell_i].items[col] != grid.items[hmirror_i + cell_i + 1].items[col]) {
                        horizontal_mirrors.items[hmirror_i] = false;
                    }
                }
            }
        }

        // std.debug.print("{any} {any}\n", .{horizontal_mirrors.items, vertical_mirrors.items});

        for (0..horizontal_mirrors.items.len) |h_i| {
            if (horizontal_mirrors.items[h_i]) {
                ret += (h_i+1) * 100;
            }
        }

        for (0..vertical_mirrors.items.len) |v_i| {
            if (vertical_mirrors.items[v_i]) {
                ret += v_i+1;
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
