const std = @import("std");
const download = @import("download");

const TS_VERSION = "0.19.4";
const URL = "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v" ++ TS_VERSION ++ ".tar.gz";

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-tree-sitter", "src/main.zig");
    lib.setBuildMode(mode);

    const path = try download.tar.gz(b.allocator, b.cache_root, URL, .{ .name = "tree-sitter" });
    defer b.allocator.free(path);

    const sep = std.fs.path.sep;
    const src = try std.fmt.allocPrint(b.allocator, "{s}{c}lib{c}src", .{ path, sep, sep });
    const include = try std.fmt.allocPrint(b.allocator, "{s}{c}lib{c}include", .{ path, sep, sep });
    const libC = try std.fmt.allocPrint(b.allocator, "{s}{c}lib.c", .{ src, sep });

    lib.addIncludeDir(src);
    lib.addIncludeDir(include);
    // lib.setLibCFile(libC);
    // const CFile = [1]([_]u8){""};
    // lib.addCSourceFile(libC, [_][_]{""});
    lib.install();

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
