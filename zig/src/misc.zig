const std = @import("std");

pub fn oom(err: std.mem.Allocator.Error) noreturn {
    _ = err catch {};
    @panic("Out of memory");
}
