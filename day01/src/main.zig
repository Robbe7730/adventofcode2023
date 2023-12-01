const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stdin = std.io.getStdIn();
    var reader = stdin.reader();

    var input: ArrayList(u8) = ArrayList(u8).init(allocator);
    try reader.readAllArrayList(&input, 9999999);

    std.debug.print("part 1: {}\n", .{part1(input)});
    std.debug.print("part 2: {}\n", .{part2(input)});
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 0;
    const NO_DIGIT = 10;
    var first_digit: u8 = NO_DIGIT;
    var last_digit: u8 = NO_DIGIT;
    for (input.items) |char| {
        if ((char >= '0') and (char <= '9')) {
            if (first_digit == NO_DIGIT) {
                first_digit = char - '0';
            }
            last_digit = char - '0';
        }
        if (char == '\n') {
            ret += first_digit * 10 + last_digit;
            first_digit = NO_DIGIT;
        }
    }

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    var ret: usize = 0;
    const NO_DIGIT = 10;
    var first_digit: u8 = NO_DIGIT;
    var last_digit: u8 = NO_DIGIT;
    var word_buffer: [5]u8 = .{ 0, 0, 0, 0, 0 };
    for (input.items) |char| {
        for (1..5) |i| {
            word_buffer[i - 1] = word_buffer[i];
        }

        word_buffer[4] = char;

        var curr_digit: u8 = NO_DIGIT;
        if ((char >= '0') and (char <= '9')) {
            curr_digit = char - '0';
        } else if (std.mem.eql(u8, word_buffer[2..], "one")) {
            curr_digit = 1;
        } else if (std.mem.eql(u8, word_buffer[2..], "two")) {
            curr_digit = 2;
        } else if (std.mem.eql(u8, word_buffer[0..], "three")) {
            curr_digit = 3;
        } else if (std.mem.eql(u8, word_buffer[1..], "four")) {
            curr_digit = 4;
        } else if (std.mem.eql(u8, word_buffer[1..], "five")) {
            curr_digit = 5;
        } else if (std.mem.eql(u8, word_buffer[2..], "six")) {
            curr_digit = 6;
        } else if (std.mem.eql(u8, word_buffer[0..], "seven")) {
            curr_digit = 7;
        } else if (std.mem.eql(u8, word_buffer[0..], "eight")) {
            curr_digit = 8;
        } else if (std.mem.eql(u8, word_buffer[1..], "nine")) {
            curr_digit = 9;
        }

        if (curr_digit != NO_DIGIT) {
            if (first_digit == NO_DIGIT) {
                first_digit = curr_digit;
            }
            last_digit = curr_digit;
        }

        if (char == '\n') {
            // std.debug.print("{}{}\n", .{ first_digit, last_digit });
            ret += first_digit * 10 + last_digit;
            first_digit = NO_DIGIT;
            word_buffer = .{ 0, 0, 0, 0, 0 };
        }
    }

    return ret;
}
