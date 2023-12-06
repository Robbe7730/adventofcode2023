const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;
const read_num = @import("shared.zig").read_num;
const skip_spaces = @import("shared.zig").skip_spaces;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}
    
fn parse(input: ArrayList(u8)) [2]ArrayList(usize) {
    var i: usize = 0;

    // Skip "Time:"
    i += 5;
    
    var times: ArrayList(usize) = ArrayList(usize).init(allocator);

    // Read times
    while (input.items[i] != '\n') {
        skip_spaces(&i, input);
        times.append(read_num(&i, input)) catch unreachable;
    }
    
    // Skip newline and "Distance:"
    i += 10;
    
    var distances: ArrayList(usize) = ArrayList(usize).init(allocator);

    // Read distances
    while (input.items[i] != '\n') {
        skip_spaces(&i, input);
        distances.append(read_num(&i, input)) catch unreachable;
    }
    return .{times, distances};
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 1;

    const times_distances = parse(input);
    const times = times_distances[0];
    const distances = times_distances[1];

    for (0..times.items.len) |race_num| {
        const time = times.items[race_num];
        const distance = distances.items[race_num];
        var num_beaten: usize = 0;

        for (1..time) |hold_time| {
            if ((time - hold_time) * hold_time > distance) {
                num_beaten += 1;
            }
        }

        ret *= num_beaten;
    }

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
