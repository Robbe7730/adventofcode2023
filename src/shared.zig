const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

pub fn read_and_call(
    T: anytype,
    part1: *const fn (input: ArrayList(u8)) T,
    part2: *const fn (input: ArrayList(u8)) T
) void {
    const stdin = std.io.getStdIn();
    var reader = stdin.reader();

    var input: ArrayList(u8) = ArrayList(u8).init(allocator);
    reader.readAllArrayList(&input, std.math.maxInt(usize)) catch unreachable;

    var args = std.process.args();
    _ = args.skip();

    const part = args.next();

    var run_1 = false;
    var run_2 = false;

    if (part == null) {
        run_1 = true;
        run_2 = true;
    } else if (part.?[0] == '1') {
        run_1 = true;
    } else if (part.?[0] == '2') {
        run_2 = true;
    }

    if (run_1) {
        std.debug.print("part 1: {any}\n", .{part1(input)});
    }
    if (run_2) {
        std.debug.print("part 2: {any}\n", .{part2(input)});
    }
}
