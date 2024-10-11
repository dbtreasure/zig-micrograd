const std = @import("std");
pub fn main() !void {
    const Value = struct {
        data: u32,
        pub fn init(data: u32) @This() {
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
            try writer.print("{}", .{self.data});
        }
    };

    const myValue = Value.init(10);
    std.debug.print("myValue: {}\n", .{myValue});
}
