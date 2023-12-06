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
    var ret: usize = 1;

    const times_distances = parse(input);
    const times = times_distances[0];
    const distances = times_distances[1];


    var time: usize = 0;

    for (times.items) |time_part| {
        const num_digits = std.math.log10_int(time_part)+1;
        time *= std.math.pow(usize, 10, num_digits);
        time += time_part;
    }

    var distance: usize = 0;

    for (distances.items) |distance_part| {
        const num_digits = std.math.log10_int(distance_part)+1;
        distance *= std.math.pow(usize, 10, num_digits);
        distance += distance_part;
    }

    std.debug.print("{} {}\n", .{time, distance});


    for (0..time) |hold_time| {
        if ((time - hold_time) * hold_time > distance) {
            ret += 1;
        }
    }

    // 27563422 --> Too High
    // No clue where the -1 comes from, but it works...
    return ret - 1;
}
