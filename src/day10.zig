const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn find_ds(dx: isize, dy: isize, tile: u8) [2]isize {
    if (tile == '|') {
        if (dx == 0) {
            return .{dx, dy};
        }
    }
    if (tile == '-') {
        if (dy == 0) {
            return .{dx, dy};
        }
    }

    if (tile == 'L') {
        if (dx == -1 and dy == 0) {
            return .{0, -1};
        } else if (dx == 0 and dy == 1) {
            return .{1, 0};
        }
    }
    if (tile == 'F') {
        if (dx == -1 and dy == 0) {
            return .{0, 1};
        } else if (dx == 0 and dy == -1) {
            return .{1, 0};
        }
    }
    if (tile == '7') {
        if (dx == 1 and dy == 0) {
            return .{0, 1};
        } else if (dx == 0 and dy == -1) {
            return .{-1, 0};
        }
    }
    if (tile == 'J') {
        if (dx == 1 and dy == 0) {
            return .{0, -1};
        } else if (dx == 0 and dy == 1) {
            return .{-1, 0};
        }
    }

    std.debug.panic("Invalid move: ({}, {}) {c}", .{dx, dy, tile});
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 0;
    var grid = ArrayList(ArrayList(u8)).init(allocator);
    defer grid.deinit();
    var new_line = ArrayList(u8).init(allocator);

    var start_pos: [2]usize = .{0, 0};
    var x: usize = 0;
    var y: usize = 0;

    for (input.items) |tile| {
        if (tile == 'S') {
            start_pos = .{x, y};
        }

        if (tile == '\n') {
            grid.append(new_line) catch unreachable;
            new_line = ArrayList(u8).init(allocator);
            x = 0;
            y += 1;
        } else {
            new_line.append(tile) catch unreachable;
            x += 1;
        }
    }

    x = start_pos[0];
    y = start_pos[1];

    var dx: isize = 0;
    var dy: isize = 0;

    if (
        grid.items[y-1].items[x] == '|' or
        grid.items[y-1].items[x] == 'F' or
        grid.items[y-1].items[x] == '7'
    ) {
        // Move north
        dy = -1;
    } else if (
        grid.items[y].items[x+1] == '-' or
        grid.items[y].items[x+1] == 'J' or
        grid.items[y].items[x+1] == '7'
    ) {
        // Move east
        dx = 1;
    } else if (
        grid.items[y+1].items[x] == '|' or
        grid.items[y+1].items[x] == 'J' or
        grid.items[y+1].items[x] == 'L'
    ) {
        // Move south
        dy = 1;
    } else if (
        grid.items[y].items[x-1] == '-' or
        grid.items[y].items[x-1] == 'L' or
        grid.items[y].items[x-1] == 'F'
    ) {
        // Move west
        dx = -1;
    }

    x =  @as(usize, @intCast(@as(isize, @intCast(x)) + dx));
    y =  @as(usize, @intCast(@as(isize, @intCast(y)) + dy));

    while (x != start_pos[0] or y != start_pos[1]) {
        const new_ds = find_ds(dx, dy, grid.items[y].items[x]);

        dx = new_ds[0];
        dy = new_ds[1];

        ret += 1;

        x =  @as(usize, @intCast(@as(isize, @intCast(x)) + dx));
        y =  @as(usize, @intCast(@as(isize, @intCast(y)) + dy));

    }

    return (ret+1)/2;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
