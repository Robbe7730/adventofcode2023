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
    var ret: usize = 0;

    var grid = ArrayList(ArrayList(u8)).init(allocator);
    defer grid.deinit();
    var new_line = ArrayList(u8).init(allocator);

    var is_path = ArrayList(ArrayList(bool)).init(allocator);
    defer is_path.deinit();
    var path_line = ArrayList(bool).init(allocator);

    var is_outside = ArrayList(ArrayList(bool)).init(allocator);
    defer is_outside.deinit();
    var outside_line = ArrayList(bool).init(allocator);

    var start_pos: [2]usize = .{0, 0};
    var x: usize = 0;
    var y: usize = 0;

    for (input.items) |tile| {
        if (tile == 'S') {
            start_pos = .{x, y};
        }

        if (tile == '\n') {
            grid.append(new_line) catch unreachable;
            is_path.append(path_line) catch unreachable;
            is_outside.append(outside_line) catch unreachable;

            new_line = ArrayList(u8).init(allocator);
            path_line = ArrayList(bool).init(allocator);
            outside_line = ArrayList(bool).init(allocator);

            x = 0;
            y += 1;
        } else {
            new_line.append(tile) catch unreachable;
            path_line.append(false) catch unreachable;
            outside_line.append(false) catch unreachable;

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

    is_path.items[y].items[x] = true;
    x = @as(usize, @intCast(@as(isize, @intCast(x)) + dx));
    y = @as(usize, @intCast(@as(isize, @intCast(y)) + dy));

    while (x != start_pos[0] or y != start_pos[1]) {
        is_path.items[y].items[x] = true;
        const new_ds = find_ds(dx, dy, grid.items[y].items[x]);

        dx = new_ds[0];
        dy = new_ds[1];

        x =  @as(usize, @intCast(@as(isize, @intCast(x)) + dx));
        y =  @as(usize, @intCast(@as(isize, @intCast(y)) + dy));
    }

    for (0..is_path.items.len) |y1| {
        path_line = is_path.items[y1];
        outside_line = is_outside.items[y1];
        var top_outside = true;
        var bottom_outside = true;

        for (0..path_line.items.len) |x1| {
            if (path_line.items[x1]) {
                const tile = grid.items[y1].items[x1];

                if (tile == 'J' or tile == '|' or tile == 'L'){
                    top_outside = !top_outside;
                }

                if (tile == '7' or tile == '|' or tile == 'F'){
                    bottom_outside = !bottom_outside;
                }
            }

            outside_line.items[x1] = (bottom_outside or top_outside);

            // if (bottom_outside and top_outside) {
            //     std.debug.print("X", .{});
            // } else if (bottom_outside) {
            //     std.debug.print("v", .{});
            // } else if (top_outside) {
            //     std.debug.print("^", .{});
            // } else {
            //     std.debug.print(" ", .{});
            // }
        }
        // std.debug.print("\n", .{});
    }
    // std.debug.print("\n", .{});

    for (0..is_path.items.len) |y1| {
        path_line = is_path.items[y1];
        outside_line = is_outside.items[y1];
        for (0..path_line.items.len) |x1| {
            if (path_line.items[x1]) {
                // std.debug.print(".", .{});
            } else if (outside_line.items[x1]) {
                // std.debug.print("O", .{});
            } else {
                // std.debug.print("I", .{});
                ret += 1;
            }
        }
        // std.debug.print("\n", .{});
    }
    // std.debug.print("\n", .{});

    // 692 --> too high
    // 684 --> too high
    // 435 :)
    return ret;
}
