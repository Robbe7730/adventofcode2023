const std = @import("std");

const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;
const Tuple = std.meta.Tuple;

const read_and_call = @import("shared.zig").read_and_call;
const read_num = @import("shared.zig").read_num;

const HandType = enum(usize) {
    FiveOfAKind  = 0x60000000000,
    FourOfAKind  = 0x50000000000,
    FullHouse    = 0x40000000000,
    ThreeOfAKind = 0x30000000000,
    TwoPair      = 0x20000000000,
    OnePair      = 0x10000000000,
    HighCard     = 0x00000000000,
};

fn card_idx(card: u8, jokers: bool) usize {
    return switch (card) {
        'A' => 14,
        'K' => 13,
        'Q' => 12,
        'J' => if (!jokers) 11 else 0,
        'T' => 10,
        '9' => 9,
        '8' => 8,
        '7' => 7,
        '6' => 6,
        '5' => 5,
        '4' => 4,
        '3' => 3,
        '2' => 2,
        '1' => 1,
        else => unreachable,
    };
}

fn grade(hand: []u8) HandType {
    var counts = ArrayList(usize).init(allocator);
    defer counts.deinit();

    var max_count: usize = 0;
    var card_types: usize = 0;

    for (0..14) |_| {
        counts.append(0) catch unreachable;
    }

    for (hand) |card| {
        const card_i = card_idx(card, false);
        if (counts.items[card_i-1] == 0) {
            card_types += 1;
        }
        counts.items[card_i-1] += 1;
        if (counts.items[card_i-1] > max_count) {
            max_count = counts.items[card_i-1];
        }
    }

    if (max_count == 5) {
        return HandType.FiveOfAKind;
    }
    if (max_count == 4) {
        return HandType.FourOfAKind;
    }
    if (card_types == 2) {
        return HandType.FullHouse;
    }
    if (max_count == 3) {
        return HandType.ThreeOfAKind;
    }
    if (card_types == 3) {
        return HandType.TwoPair;
    }
    if (max_count == 2) {
        return HandType.OnePair;
    }
    return HandType.HighCard;
}

fn sort_cards(context: @TypeOf({}), lhs:[2]usize, rhs:[2]usize)bool {
    return std.sort.asc(usize)(context, lhs[0], rhs[0]);

}

pub fn main() void {
    read_and_call(usize, &part1, &part2);
}

fn part1(input: ArrayList(u8)) usize {
    var ret: usize = 0;

    var i: usize = 0;
    var cards = ArrayList([2]usize).init(allocator);

    while (i < input.items.len) {
        const hand: []u8 = input.items[i..i+5];
        i += 5;

        // Skip " "
        i+=1;

        const score = read_num(&i, input);

        const hand_score: usize = (
            @intFromEnum(grade(hand)) +
            card_idx(hand[0], false) * 0x0100000000 + 
            card_idx(hand[1], false) * 0x0001000000 + 
            card_idx(hand[2], false) * 0x0000010000 + 
            card_idx(hand[3], false) * 0x0000000100 + 
            card_idx(hand[4], false) * 0x0000000001
        );
        cards.append(.{hand_score, score}) catch unreachable;

        // Skip newline
        i+=1;
    }

    std.mem.sort([2]usize, cards.items, {}, sort_cards);

    for (0..cards.items.len) |j| {
        ret += cards.items[j][1] * (j+1);
    }

    return ret;
}

fn part2(input: ArrayList(u8)) usize {
    var ret: usize = 0;

    var i: usize = 0;
    var cards = ArrayList([2]usize).init(allocator);
    defer cards.deinit();
    var card_types = "AKQT987654321";

    var old_hand: []u8 = allocator.alloc(u8, 5) catch unreachable;
    defer allocator.free(old_hand);

    while (i < input.items.len) {
        const hand: []u8 = input.items[i..i+5];
        std.mem.copy(u8, old_hand, hand);
        i += 5;

        // Skip " "
        i+=1;

        const score = read_num(&i, input);

        // Skip newline
        i+=1;

        var max_hand_score: usize = 0;

        for (card_types) |j1| {
            if (old_hand[0] == 'J') {
                hand[0] = j1;
            }
            for (card_types) |j2| {
                if (old_hand[1] == 'J') {
                    hand[1] = j2;
                }
                for (card_types) |j3| {
                    if (old_hand[2] == 'J') {
                        hand[2] = j3;
                    }
                    for (card_types) |j4| {
                        if (old_hand[3] == 'J') {
                            hand[3] = j4;
                        }
                        for (card_types) |j5| {
                            if (old_hand[4] == 'J') {
                                hand[4] = j5;
                            }

                            const hand_score: usize = (
                                @intFromEnum(grade(hand)) +
                                card_idx(old_hand[0], true) * 0x0100000000 + 
                                card_idx(old_hand[1], true) * 0x0001000000 + 
                                card_idx(old_hand[2], true) * 0x0000010000 + 
                                card_idx(old_hand[3], true) * 0x0000000100 + 
                                card_idx(old_hand[4], true) * 0x0000000001
                            );
                            if (hand_score > max_hand_score) {
                                max_hand_score = hand_score;
                            }

                            // std.debug.print("{s} {s} {x} {x}\n", .{hand, old_hand, hand_score, max_hand_score});

                            if (old_hand[4] != 'J') {
                                break;
                            }
                        }
                        if (old_hand[3] != 'J') {
                            break;
                        }
                    }
                    if (old_hand[2] != 'J') {
                        break;
                    }
                }
                if (old_hand[1] != 'J') {
                    break;
                }
            }
            if (old_hand[0] != 'J') {
                break;
            }
        }

        // std.debug.print("{}/{}\n", .{i, input.items.len});
        cards.append(.{max_hand_score, score}) catch unreachable;

    }

    std.mem.sort([2]usize, cards.items, {}, sort_cards);

    for (0..cards.items.len) |j| {
        ret += cards.items[j][1] * (j+1);
    }

    // 248844298 --> too high
    // 248859461 --> too high (obviously)
    return ret;
}
