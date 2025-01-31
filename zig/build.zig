const std = @import("std");
// const emcc = @import("emcc.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib_dep = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raylib_math = raylib_dep.module("raylib-math");
    const rlgl = raylib_dep.module("rlgl");
    const raylib_artifact = raylib_dep.artifact("raylib");

    //web exports are completely separate
    // if (target.getOsTag() == .emscripten) {
    //     const exe_lib = emcc.compileForEmscripten(
    //         b,
    //         "raymond",
    //         "src/main.zig",
    //         target,
    //         optimize,
    //     );
    //
    //     exe_lib.linkLibrary(raylib_artifact);
    //     exe_lib.addModule("raylib", raylib);
    //     exe_lib.addModule("raylib-math", raylib_math);
    //
    //     // Note that raylib itself is not actually added to the exe_lib output file, so it also needs to be linked with emscripten.
    //     const link_step = try emcc.linkWithEmscripten(
    //         b,
    //         &[_]*std.Build.Step.Compile{ exe_lib, raylib_artifact },
    //     );
    //
    //     b.getInstallStep().dependOn(&link_step.step);
    //     const run_step = try emcc.emscriptenRunStep(b);
    //     run_step.step.dependOn(&link_step.step);
    //     const run_option = b.step("run", "Run raymond");
    //     run_option.dependOn(&run_step.step);
    //     return;
    // }

    const exe = b.addExecutable(.{
        .name = "raymond",
        .root_source_file = .{ .path = "src/main.zig" },
        .optimize = optimize,
        .target = target,
    });

    exe.linkLibrary(raylib_artifact);
    exe.addModule("raylib", raylib);
    exe.addModule("raylib-math", raylib_math);
    exe.addModule("rlgl", rlgl);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run raymond");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    unit_tests.linkLibrary(raylib_artifact);
    unit_tests.addModule("raylib", raylib);
    unit_tests.addModule("raylib-math", raylib_math);
    unit_tests.addModule("rlgl", rlgl);

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    b.installArtifact(exe);
}
