const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) usize {
    var i:usize = 0;

    var instructions = ArrayList(bool).init(allocator);
    defer instructions.deinit();

    // Read instructions
    while (input.items[i] != '\n') {
        instructions.append(input.items[i] == 'R') catch unreachable;
        i += 1;
    }

    // Skip two newlines
    i += 2;

    var connections = std.AutoArrayHashMap([3]u8, [2][3]u8).init(allocator);
    defer connections.deinit();

    // Read paths
    while (i < input.items.len) {
        const from = input.items[i..][0..3];
        const to_l = input.items[i..][7..10];
        const to_r = input.items[i..][12..15];

        connections.put(from.*, .{to_l.*, to_r.*}) catch unreachable;

        i += 17;
    }

    var ret: usize = 0;
    var curr_pos: [3]u8 = .{65, 65, 65};
    var target: [3]u8 = .{90, 90, 90};

    while (!std.mem.eql(u8, &curr_pos, &target)) {
        const instruction = instructions.items[ret % instructions.items.len];

        curr_pos = connections.get(curr_pos).?[if (instruction) 1 else 0];
        std.debug.print("{s}\n", .{curr_pos});

        ret += 1;
    }

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
