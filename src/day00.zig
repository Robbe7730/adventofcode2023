const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stdin = std.io.getStdIn();
    var reader = stdin.reader();

    var input: ArrayList(u8) = ArrayList(u8).init(allocator);
    try reader.readAllArrayList(&input, std.math.maxInt(usize));

    std.debug.print("part 1: {any}\n", .{part1(input)});
    std.debug.print("part 2: {any}\n", .{part2(input)});
}

fn part1(input: ArrayList(u8)) !usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}

fn part2(input: ArrayList(u8)) !usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
