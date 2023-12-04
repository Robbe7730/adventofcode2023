const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stdin = std.io.getStdIn();
    var reader = stdin.reader();

    var input: ArrayList(u8) = ArrayList(u8).init(allocator);
    try reader.readAllArrayList(&input, 9999999);

    std.debug.print("part 1: {any}\n", .{part1(input)});
    std.debug.print("part 2: {}\n", .{part2(input)});
}

fn read_num(i: *usize, input: ArrayList(u8)) usize {
    var ret: usize = 0;

    while (input.items[i.*] >= '0' and input.items[i.*] <= '9') {
        ret = ret * 10 + (input.items[i.*] - '0');
        (i.*) += 1;
    }

    return ret;
}

fn skip_spaces(i: *usize, input: ArrayList(u8)) void {
    while (input.items[i.*] == ' ') {
        (i.*) += 1;
    }
}

fn part1(input: ArrayList(u8)) !usize {
    var ret: usize = 0;
    var i: usize = 0;

    while (i < input.items.len) {
        // Skip "Card"
        i += 5;
        skip_spaces(&i, input);

        const game_id = read_num(&i, input);
        _ = game_id;

        // Skip ":"
        i += 1;

        skip_spaces(&i, input);

        // Read winning numbers
        var winning_numbers: ArrayList(usize) = ArrayList(usize).init(allocator);
        defer winning_numbers.deinit();

        while (input.items[i] != '|') {
            try winning_numbers.append(read_num(&i, input));
            skip_spaces(&i, input);
            // std.debug.print("Winning #: {}", .{winning_numbers.items.len});
        }

        // Skip "|"
        i += 1;

        skip_spaces(&i, input);

        var score: usize = 0;
        while (input.items[i] != '\n') {
            const own_value = read_num(&i, input);
            for (winning_numbers.items) |winner| {
                if (own_value == winner) {
                    if (score == 0) {
                        score = 1;
                    } else {
                        score *= 2;
                    }
                }
            }
            skip_spaces(&i, input);
        }
        ret += score;

        // std.debug.print("Game {}\n", .{game_id});

        // Skip rest of line
        while (input.items[i] != '\n') {
            i += 1;
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
