const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
