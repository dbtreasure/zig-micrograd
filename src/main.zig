const std = @import("std");
const Value = @import("Value.zig").Value;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const a = try Value.init(allocator, 4.0, null, null);
    const b = try Value.init(allocator, 2.0, null, null);
    const c = try Value.init(allocator, 3.0, null, null);
    const d = try (try a.mul(b)).add(c);

    std.debug.print("d: {}\n", .{d});

    // debug print d's children
    std.debug.print("d's children: {any}\n", .{d.prev.items});
    if (d.operator) |op| {
        std.debug.print("d's operator: {s}\n", .{op});
    }
}
