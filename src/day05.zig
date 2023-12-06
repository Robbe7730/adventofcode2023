const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn read_num(i: *usize, input: ArrayList(u8)) usize {
    var ret: usize = 0;

    while (input.items[i.*] >= '0' and input.items[i.*] <= '9') {
        ret = ret * 10 + (input.items[i.*] - '0');
        (i.*) += 1;
    }

    return ret;
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 999999999999;

    var i: usize = 0;
    var seeds: ArrayList(usize) = ArrayList(usize).init(allocator);

    // Skip "seeds:"
    i += 6;

    // Read seeds
    while (input.items[i] != '\n') {
        // Skip space
        i += 1;

        seeds.append(read_num(&i, input)) catch unreachable;
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

            map.append(.{dest_start, src_start, len}) catch unreachable;

        }
        maps.append(map) catch unreachable;
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
    var i: usize = 0;
    var seeds: ArrayList(usize) = ArrayList(usize).init(allocator);

    // Skip "seeds:"
    i += 6;

    // Read seeds
    while (input.items[i] != '\n') {
        // Skip space
        i += 1;

        seeds.append(read_num(&i, input)) catch unreachable;
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

            map.append(.{dest_start, src_start, len}) catch unreachable;

        }
        maps.append(map) catch unreachable;
        i += 1;
    }

    var ranges: ArrayList([2]usize) = ArrayList([2]usize).init(allocator);

    var s: usize = 0;
    while (s < seeds.items.len) {
        ranges.append(.{seeds.items[s], seeds.items[s+1]}) catch unreachable;
        s += 2;
    }

    // std.debug.print("{any}\n", .{ranges.items});

    for (maps.items) |map| {
        var mapped_ranges: ArrayList([2]usize) = ArrayList([2]usize).init(allocator);
        for (map.items) |rule| {
            const dest_start = rule[0];
            const src_start = rule[1];
            const len = rule[2];
            const src_end = src_start + len;

            var new_ranges: ArrayList([2]usize) = ArrayList([2]usize).init(allocator);
            for (ranges.items) |range| {
                const range_start = range[0];
                const range_len = range[1];
                const range_end = range_start + range_len;

                if (range_start >= src_end or src_start >= range_end) {
                    new_ranges.append(.{range_start, range_len}) catch unreachable;
                    continue;
                }

                // Difference left
                if (range_start < src_start) {
                    // AC x
                    // std.log.debug("AC x", .{});
                    new_ranges.append(.{range_start, src_start - range_start}) catch unreachable;
                } else {
                    // CA skip
                    // std.log.debug("CA skip", .{});
                }

                // TODO Intersect (map)
                var intersect_start = if (src_start > range_start) src_start else range_start;
                var intersect_end = if (src_end < range_end) src_end else range_end;

                var intersect_start_mapped = dest_start + (intersect_start - src_start);

                mapped_ranges.append(.{intersect_start_mapped, intersect_end - intersect_start}) catch unreachable;

                // Difference right
                if (range_end > src_end) {
                    // DB x
                    new_ranges.append(.{src_end, range_end - src_end}) catch unreachable;
                    // std.log.debug("DB x", .{});
                } else {
                    // BD skip
                    // std.log.debug("BD skip", .{});
                }
            }
            var sum: usize = 0;
            for (ranges.items) |range| {
                sum += range[1];
            }

            // std.debug.print("{any} <--> {any} = ({}) {any} / {any}\n", .{ranges.items, rule, sum, new_ranges.items, mapped_ranges.items});
            ranges = new_ranges;

        }
        ranges.appendSlice(mapped_ranges.items) catch unreachable;
        // std.debug.print("{}\n", .{dest});
    }
    // std.debug.print("---> {}\n", .{dest});
    var ret: usize = std.math.maxInt(usize);
    var sum: usize = 0;

    for (ranges.items) |range| {
        if (ret > range[0]) {
            ret = range[0];
        }

        sum += range[1];
    }

    // std.log.debug("{}", .{sum});

    return ret;
}
