const std = @import("std");

pub fn main() !void {
    const Value = struct {
        data: f64,
        prev: std.ArrayList(@This()),
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator, data: f64, _children: ?std.ArrayList(@This())) !@This() {
            var prevList = std.ArrayList(@This()).init(allocator);
            if (_children) |children| {
                for (children.items) |*child| { // Access items as a property, not a function
                    try prevList.append(child.*); // Dereference the pointer
                }
            }
            return .{
                .data = data,
                .prev = prevList,
                .allocator = allocator,
            };
        }

        pub fn format(
            self: @This(),
            comptime fmt: []const u8,
            options: std.fmt.FormatOptions,
            writer: anytype,
        ) !void {
            _ = fmt;
            _ = options;
            try writer.print("{d:.2}", .{self.data});
        }

        pub fn add(self: @This(), other: @This()) !@This() {
            var children = std.ArrayList(@This()).init(self.allocator);
            try children.append(self);
            try children.append(other);
            return @This().init(self.allocator, self.data + other.data, children);
        }

        pub fn mul(self: @This(), other: @This()) !@This() {
            var children = std.ArrayList(@This()).init(self.allocator);
            try children.append(self);
            try children.append(other);
            return @This().init(self.allocator, self.data * other.data, children);
        }
    };

    const allocator = std.heap.page_allocator;
    const a = try Value.init(allocator, 4.0, null);
    const b = try Value.init(allocator, 2.0, null);
    const c = try Value.init(allocator, 3.0, null);
    const d = try (try a.mul(b)).add(c);

    std.debug.print("d: {}\n", .{d});
}
