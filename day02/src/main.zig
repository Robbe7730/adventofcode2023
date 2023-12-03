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

fn read_num(input: ArrayList(u8), i: *usize) isize {
    var ret: isize = 0;
    while (input.items[i.*] <= '9' and input.items[i.*] >= '0') {
        ret = ret * 10 + (input.items[i.*] - '0');
        (i.*) += 1;
    }
    return ret;
}

// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
fn part1(input: ArrayList(u8)) isize {
    var ret: isize = 0;

    var i: usize = 0;

    while (i < input.items.len) {
        // Skip "Game "
        i += 5;

        // Read ID
        const game_id = read_num(input, &i);
        // std.debug.print("Game {}\n", .{game_id});
        
        // Skip ": "
        i += 2;

        var valid = true;
        var red: isize = 12;
        var green: isize = 13;
        var blue: isize = 14;

        // For rest of line
        while (input.items[i] != '\n') {
            const amount = read_num(input, &i);

            // Skip space
            i += 1;

            // Detect color
            if (input.items[i] == 'r') {
                red -= amount;
            } else if (input.items[i] == 'g') {
                green -= amount;
            } else if (input.items[i] == 'b') {
                blue -= amount;
            }
            // std.debug.print("amount: {}\n", .{amount});
            // std.debug.print("remaining: {} {} {}\n", .{red, green, blue});

            if (red < 0 or green < 0 or blue < 0) {
                valid = false;
            }

            // Skip rest of word
            while (input.items[i] != ',' and input.items[i] != ';' and input.items[i] != '\n') {
                i += 1;
            }

            if (input.items[i] == ';') {
                red = 12;
                green = 13;
                blue = 14;
            }

            // Skip separator and maybe space
            if (input.items[i] != '\n') {
                i += 2;
            }
        }
        // std.debug.print("{c}\n", .{input.items[i]});

        // Skip newline
        i += 1;

        if (valid) {
            ret += game_id;
        }
    }

    return ret;
}

fn part2(input: ArrayList(u8)) isize {
    var ret: isize = 0;

    var i: usize = 0;

    while (i < input.items.len) {
        // Skip "Game "
        i += 5;

        // Read ID
        const game_id = read_num(input, &i);
        _ = game_id;
        // std.debug.print("Game {}\n", .{game_id});
        
        // Skip ": "
        i += 2;

        var red: isize = 0;
        var green: isize = 0;
        var blue: isize = 0;

        // For rest of line
        while (input.items[i] != '\n') {
            const amount = read_num(input, &i);

            // Skip space
            i += 1;

            // Detect color
            if (input.items[i] == 'r') {
                if (amount > red) {
                    red = amount;
                }
            } else if (input.items[i] == 'g') {
                if (amount > green) {
                    green = amount;
                }
            } else if (input.items[i] == 'b') {
                if (amount > blue) {
                    blue = amount;
                }
            }
            // std.debug.print("amount: {}\n", .{amount});
            // std.debug.print("remaining: {} {} {}\n", .{red, green, blue});

            // Skip rest of word
            while (input.items[i] != ',' and input.items[i] != ';' and input.items[i] != '\n') {
                i += 1;
            }

            // Skip separator and maybe space
            if (input.items[i] != '\n') {
                i += 2;
            }
        }
        // std.debug.print("{c}\n", .{input.items[i]});

        // Skip newline
        i += 1;

        ret += red * green * blue;
    }

    return ret;
}
