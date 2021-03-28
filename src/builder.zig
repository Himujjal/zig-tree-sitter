const std = @import("std");

const Builder = std.build.Builder;
const Mode = std.build.Mode;
const LibExeObjStep = std.build.LibExeObjStep;

pub fn prepareTreeSitter(b: *Builder, mode: Mode, path: []const u8) *LibExeObjStep {
    const lib = b.addStaticLibrary("tree_sitter", null);
    lib.setBuildMode(mode);
    lib.addIncludeDir(path ++ "/pkg/lib/include");
    lib.addIncludeDir(path ++ "/pkg/lib/src");
    lib.addCSourceFiles(&.{
        tree_sitter_base ++ "/pkg/lib/src/lib.c",
    }, &.{});

    lib.linkLibC();
    return lib;
}
