const std = @import("std");
const download = @import("download");

const TS_VERSION = "0.19.4";
const TS_URL = "https://github.com/tree-sitter/tree-sitter/archive/v" ++ TS_VERSION ++ ".tar.gz";

fn prepareTS(b: *std.build.Builder, lib: *std.build.LibExeObjStep) !void {
    const path = try download.tar.gz(b.allocator, b.cache_root, TS_URL, .{ .name = "tree-sitter" });

    const join = std.fs.path.join;
    const clibpath = try join(b.allocator, &[_][]const u8{ path, "lib", "src", "lib.c" });

    lib.linkLibC();
    lib.addCSourceFile(clibpath, &[_][]const u8{});
    lib.addIncludeDir(try join(b.allocator, &[_][]const u8{ path, "lib", "include" }));
    lib.addIncludeDir(try join(b.allocator, &[_][]const u8{ path, "lib", "src" }));
}

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("zig-tree-sitter", "src/lib.zig");
    lib.setBuildMode(mode);
    lib.install();

    try prepareTS(b, lib);

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
