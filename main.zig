const std = @import("std");

pub fn main() !void {
    const Value = struct {
        data: f64,
        pub fn init(data: f64) @This() {
            return .{
                .data = data,
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

        pub fn add(self: @This(), other: @This()) @This() {
            return @This().init(self.data + other.data);
        }

        pub fn mul(self: @This(), other: @This()) @This() {
            return @This().init(self.data * other.data);
        }
    };

    const a = Value.init(4.0);
    const b = Value.init(2.0);
    const c = Value.init(3.0);
    const d = (a.mul(b)).add(c);

    std.debug.print("d: {}\n", .{d});
}
