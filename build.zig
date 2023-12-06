const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const DAYS_IMPLEMENTED = 6;

    for (0..(DAYS_IMPLEMENTED+1)) |day| {
        var name: []u8 = "";
        if (day < 10) {
             name = std.fmt.allocPrint(
                allocator,
                "day0{}",
                .{day}
            ) catch unreachable;
        } else {
             name = std.fmt.allocPrint(
                allocator,
                "day{}",
                .{day}
            ) catch unreachable;
        }
        const exe = b.addExecutable(.{
            .name = name,
            .root_source_file = .{
                .path = std.fmt.allocPrint(
                    allocator,
                    "src/{s}.zig",
                    .{name}
                ) catch unreachable
            },
            .target = target,
            .optimize = optimize,
        });
        b.installArtifact(exe);
    }
}
