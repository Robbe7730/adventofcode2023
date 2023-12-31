const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 0;

    var i: usize = 0;
    var hash: u8 = 0;
    while (i < input.items.len) {
        if (input.items[i] == '\n') {
            break;
        }
        if (input.items[i] == ',') {
            // std.debug.print("{d}\n", .{hash});
            ret += hash;
            hash = 0;
            i += 1;
            continue;
        }
        hash += input.items[i];
        hash *= 17;
        i += 1;
    }

    // std.debug.print("{d}\n", .{hash});
    ret += hash;

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
