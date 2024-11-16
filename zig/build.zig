const std = @import("std");

var _raylib_lib_cache: ?*std.Build.Step.Compile = null;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "breakout",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const raylib = if (_raylib_lib_cache) |lib| lib else blk: {
        const raylib = b.dependency("raylib", .{
            .target = target,
            .optimize = optimize,
        });
        const lib = raylib.artifact("raylib");
        b.installArtifact(lib);
        _raylib_lib_cache = lib;
        break :blk lib;
    };

    exe.linkLibrary(raylib);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
