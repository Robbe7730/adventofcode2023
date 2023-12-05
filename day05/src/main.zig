const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stdin = std.io.getStdIn();
    var reader = stdin.reader();

    var input: ArrayList(u8) = ArrayList(u8).init(allocator);
    try reader.readAllArrayList(&input, 9999999);

    std.debug.print("part 1: {any}\n", .{part1(input)});
    std.debug.print("part 2: {any}\n", .{part2(input)});
}

fn read_num(i: *usize, input: ArrayList(u8)) usize {
    var ret: usize = 0;

    while (input.items[i.*] >= '0' and input.items[i.*] <= '9') {
        ret = ret * 10 + (input.items[i.*] - '0');
        (i.*) += 1;
    }

    return ret;
}

fn part1(input: ArrayList(u8)) !usize {
    var ret: usize = 999999999999;

    var i: usize = 0;
    var seeds: ArrayList(usize) = ArrayList(usize).init(allocator);

    // Skip "seeds:"
    i += 6;

    // Read seeds
    while (input.items[i] != '\n') {
        // Skip space
        i += 1;

        try seeds.append(read_num(&i, input));
    }

    // Skip newline
    i += 1;

    var maps: ArrayList(ArrayList([3]usize)) = ArrayList(ArrayList([3]usize)).init(allocator);

    while (i < input.items.len) {
        // Skip newline
        i += 1;

        // Skip title
        while (input.items[i] != '\n') {
            i += 1;
        }
        i += 1;

        var map: ArrayList([3]usize) = ArrayList([3]usize).init(allocator);
        // Read numbers
        while (i < input.items.len and input.items[i] != '\n') {
            const dest_start = read_num(&i, input);
            i += 1;
            const src_start = read_num(&i, input);
            i += 1;
            const len = read_num(&i, input);
            i += 1;

            try map.append(.{dest_start, src_start, len});

        }
        try maps.append(map);
        i += 1;
    }

    for (seeds.items) |seed| {
        var dest: usize = seed;
        for (maps.items) |map| {
            for (map.items) |rule| {
                const dest_start = rule[0];
                const src_start = rule[1];
                const len = rule[2];
                if (dest >= src_start and dest < src_start + len) {
                    dest = dest_start + (dest - src_start);
                    break;
                }
            }
            // std.debug.print("{}\n", .{dest});
        }
        // std.debug.print("---> {}\n", .{dest});
        if (dest < ret) {
            ret = dest;
        }
    }

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
