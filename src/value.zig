const std = @import("std");

pub const Value = struct {
    data: f64,
    prev: std.ArrayList(@This()),
    allocator: std.mem.Allocator,
    operator: ?[]const u8,

    pub fn init(allocator: std.mem.Allocator, data: f64, _children: ?std.ArrayList(@This()), operator: ?[]const u8) !@This() {
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
            .operator = operator,
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
        return @This().init(self.allocator, self.data + other.data, children, "+");
    }

    pub fn mul(self: @This(), other: @This()) !@This() {
        var children = std.ArrayList(@This()).init(self.allocator);
        try children.append(self);
        try children.append(other);
        return @This().init(self.allocator, self.data * other.data, children, "*");
    }
};
