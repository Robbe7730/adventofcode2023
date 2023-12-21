const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) usize {

    var i: usize = 0;
    var x: usize = 0;
    var y: usize = 0;

    var points = ArrayList([2]usize).init(allocator);
    var x_filled = ArrayList(bool).init(allocator);
    var y_filled = ArrayList(bool).init(allocator);

    y_filled.append(false) catch unreachable;
    while (i < input.items.len) {
        if (input.items[i] == '\n') {
            x = 0;
            y += 1;
            i += 1;
            if (i < input.items.len) {
                y_filled.append(false) catch unreachable;
            }
            continue;
        }

        if (y == 0) {
            x_filled.append(false) catch unreachable;
        }

        if (input.items[i] == '#') {
            x_filled.items[x] = true;
            y_filled.items[y] = true;
            points.append(.{x, y}) catch unreachable;
        }
        x += 1;
        i += 1;
    }

    var dxs = ArrayList(usize).init(allocator);
    var dx: usize = 0;

    for (x_filled.items) |x_full| {
        if (!x_full) {
            dx += 1;
        }
        dxs.append(dx) catch unreachable;
    }

    var dys = ArrayList(usize).init(allocator);
    var dy: usize = 0;

    for (y_filled.items) |y_full| {
        if (!y_full) {
            dy += 1;
        }
        dys.append(dy) catch unreachable;
    }

    var new_points = ArrayList([2]usize).init(allocator);
    for (points.items) |point| {
        new_points.append(.{
            point[0] + dxs.items[point[0]],
            point[1] + dys.items[point[1]]
        }) catch unreachable;
    }

    //std.debug.print("{any}\n", .{new_points.items});

    var ret: usize = 0;

    for (0..new_points.items.len) |from_i| {
        const from = new_points.items[from_i];
        for (new_points.items[from_i..]) |to| {
            var dx1 = if (from[0] > to[0]) from[0] - to[0] else to[0] - from[0];
            var dy1 = if (from[1] > to[1]) from[1] - to[1] else to[1] - from[1];

            ret += dx1;
            ret += dy1;
        }
    }
    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    var i: usize = 0;
    var x: usize = 0;
    var y: usize = 0;

    var points = ArrayList([2]usize).init(allocator);
    var x_filled = ArrayList(bool).init(allocator);
    var y_filled = ArrayList(bool).init(allocator);

    y_filled.append(false) catch unreachable;
    while (i < input.items.len) {
        if (input.items[i] == '\n') {
            x = 0;
            y += 1;
            i += 1;
            if (i < input.items.len) {
                y_filled.append(false) catch unreachable;
            }
            continue;
        }

        if (y == 0) {
            x_filled.append(false) catch unreachable;
        }

        if (input.items[i] == '#') {
            x_filled.items[x] = true;
            y_filled.items[y] = true;
            points.append(.{x, y}) catch unreachable;
        }
        x += 1;
        i += 1;
    }

    var dxs = ArrayList(usize).init(allocator);
    var dx: usize = 0;

    for (x_filled.items) |x_full| {
        if (!x_full) {
            dx += 999999;
        }
        dxs.append(dx) catch unreachable;
    }

    var dys = ArrayList(usize).init(allocator);
    var dy: usize = 0;

    for (y_filled.items) |y_full| {
        if (!y_full) {
            dy += 999999;
        }
        dys.append(dy) catch unreachable;
    }

    var new_points = ArrayList([2]usize).init(allocator);
    for (points.items) |point| {
        new_points.append(.{
            point[0] + dxs.items[point[0]],
            point[1] + dys.items[point[1]]
        }) catch unreachable;
    }

    //std.debug.print("{any}\n", .{new_points.items});

    var ret: usize = 0;

    for (0..new_points.items.len) |from_i| {
        const from = new_points.items[from_i];
        for (new_points.items[from_i..]) |to| {
            var dx1 = if (from[0] > to[0]) from[0] - to[0] else to[0] - from[0];
            var dy1 = if (from[1] > to[1]) from[1] - to[1] else to[1] - from[1];

            ret += dx1;
            ret += dy1;
        }
    }
    return ret;
}
