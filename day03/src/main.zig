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

fn is_symbol(x: isize, y: isize, len: usize, input: ArrayList(u8)) bool {
    if (x >= 0 and y >= 0 and x < len and y < len) {
        const i: usize = @as(usize, @intCast(x)) + @as(usize, @intCast(y)) * (len+1);
        // std.debug.print("{c}: {}\n", .{input.items[i], !(input.items[i] == '.' or (
        //     input.items[i] >= '0' and
        //     input.items[i] <= '9'
        // ))});
        return !(input.items[i] == '.' or (
            input.items[i] >= '0' and
            input.items[i] <= '9'
        ));
    }
    // std.debug.print("false", .{});
    return false;
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 0;

    // Find line length
    var len: usize = 0;
    while (input.items[len] != '\n') {
        len += 1;
    }

    var i: usize = 0;
    var curr_num: usize = 0;
    var curr_num_symbol: bool = false;
    while (i < input.items.len) {
        if (input.items[i] >= '0' and input.items[i] <= '9') {
            curr_num = curr_num * 10 + (input.items[i] - '0');

            // std.debug.print("{}\n", .{curr_num});

            const x: isize = @as(isize, @intCast(i % (len+1)));
            const y: isize = @as(isize, @intCast(i / (len+1)));

            curr_num_symbol = curr_num_symbol or (
                is_symbol(x-1, y-1, len, input) or
                is_symbol(x-1, y, len, input) or
                is_symbol(x-1, y+1, len, input) or
                is_symbol(x, y-1, len, input) or
                // is_symbol(x, y, len, input) or
                is_symbol(x, y+1, len, input) or
                is_symbol(x+1, y-1, len, input) or
                is_symbol(x+1, y, len, input) or
                is_symbol(x+1, y+1, len, input)
            );

            // std.debug.print("{}\n", .{curr_num_symbol});
        } else if (curr_num != 0) {
            if (curr_num_symbol) {
                ret += curr_num;
            }
            curr_num = 0;
            curr_num_symbol = false;
        }

        i += 1;
    }

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    _ = input;
    var ret: usize = 0;
    return ret;
}
