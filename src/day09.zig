const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const read_and_call = @import("shared.zig").read_and_call;
const skip_spaces = @import("shared.zig").skip_spaces;
const read_num_signed = @import("shared.zig").read_num_signed;

pub fn main() void {
    read_and_call(isize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) isize {
    var ret: isize = 0;

    var i: usize = 0;

    while (i < input.items.len) {
        var line = ArrayList(isize).init(allocator);
        defer line.deinit();
        while (input.items[i] != '\n') {
            skip_spaces(&i, input);
            
            const num = read_num_signed(&i, input);
            line.append(num) catch unreachable;
        }
        i += 1;

        var all_zero = false;
        var lasts = ArrayList(isize).init(allocator);
        defer lasts.deinit();

        while (!all_zero) {
            // std.debug.print("{any} \n", .{line.items});
            all_zero = true;
            lasts.insert(0, line.items[line.items.len-1]) catch unreachable;
            var delta_line = ArrayList(isize).init(allocator);

            for (1..line.items.len) |x| {
                const diff = line.items[x] - line.items[x-1];
                if (diff != 0) {
                    all_zero = false;
                }
                delta_line.append(diff) catch unreachable;
            }

            line = delta_line;
        }

        // std.debug.print("{any} \n", .{lasts.items});

        var curr_val: isize = 0;
        for (0..lasts.items.len) |x| {
            curr_val = lasts.items[x] + curr_val;
            // std.debug.print("{} ", .{curr_val});
        }
        // std.debug.print("\n", .{});

        ret += curr_val;
    }

    return ret;
}

fn part2(input: ArrayList(u8)) isize {
    _ = input;
    var ret: isize = 0;
    return ret;
}
