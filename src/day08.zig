const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) usize {
    var i: usize = 0;

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
        // std.debug.print("{s}\n", .{curr_pos});

        ret += 1;
    }

    return ret;
}

fn contains(path: ArrayList([4]usize), pos: [4]usize) usize {
    var i: usize = 0;
    while (i < path.items.len) {
        const item = path.items[i];
        if (item[0] == pos[0] and
            item[1] == pos[1] and
            item[2] == pos[2] and
            item[3] == pos[3]
        ) {
            return i;
        }
        i += 1;
    }
    return std.math.maxInt(usize);
}

fn part2(input: ArrayList(u8)) usize {
    var i: usize = 0;

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
    var start_nodes = ArrayList([3]u8).init(allocator);
    defer start_nodes.deinit();

    // Read paths
    while (i < input.items.len) {
        const from = input.items[i..][0..3];
        const to_l = input.items[i..][7..10];
        const to_r = input.items[i..][12..15];

        if (from[2] == 'A') {
            start_nodes.append(from.*) catch unreachable;
        }

        connections.put(from.*, .{to_l.*, to_r.*}) catch unreachable;

        i += 17;
    }

    var positions = start_nodes;
    var ret: usize = 1;

    for (positions.items) |start_pos| {
        var step: usize = 0;
        var curr_pos = start_pos;
        var path = ArrayList([4]usize).init(allocator);
        defer path.deinit();
        var z_pos: usize = 0;
        while (true) {
            const instruction = instructions.items[step % instructions.items.len];

            const pos_and_instruction = .{
                step % instructions.items.len,
                curr_pos[0],
                curr_pos[1],
                curr_pos[2]
            };
            const cycle_i = contains(path, pos_and_instruction);
            if (cycle_i != std.math.maxInt(usize)) {
                // std.debug.print("{s}: Found cycle after {} steps at {s} ({})\n", .{start_pos, step, curr_pos, cycle_i});

                const pre = z_pos;
                const cycle_len = step - cycle_i;

                // In input, pre == cycle_len
                if (pre != cycle_len) {
                    std.debug.panic(":('", .{});
                }

                ret = (pre * ret) / std.math.gcd(pre, ret);

                // std.debug.print("pre: {}, cycle_len: {}\n", .{pre, cycle_len});
                break;
            }
            path.append(pos_and_instruction) catch unreachable;


            if (curr_pos[2] == 'Z') {
                // std.debug.print("{s}: Found Z after {} steps\n", .{start_pos, step});
                // In input, Z only appears once per cycle
                if (z_pos == 0) {
                    z_pos = step;
                }
            }

            const new_pos = connections.get(curr_pos).?[if (instruction) 1 else 0];
            curr_pos = new_pos;
            if ((step % instructions.items.len) == 0 and std.mem.eql(u8, &curr_pos, &start_pos)) {
                break;
            }
            
            step += 1;
        }
    }

    // 5000000 --> too low
    // 500000000 --> too low
    // 50000000000 --> too low
    // 5000000000000 --> incorrect
    return ret;
}
