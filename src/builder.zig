const std = @import("std");
const download = @import("download");

const TS_VERSION = "0.19.4";
const URL = "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v" ++ TS_VERSION ++ ".tar.gz";

allocator: *std.mem.Allocator,
base_path: []const u8,
src_dir: []const u8,
include_dir: []const u8,
lib_src_path: []const u8,

const Self = @This(); // refers to the struct that corresponds to the current file

pub fn init(b: *std.build.Builder) !Self {
    const base_path = try donwload.tar.gz(b.allocator, b.cache_root, URL, .{ .name = "tree-sitter-" ++ version });
    errdefer b.allocator.free(base_path); // errdefer only runs if the block exits with an error

    const src_dir = try std.fs.path.join(b.allocator, &[_][]const u8{ base_path, "lib", "src" });
    errdefer b.allocator.free(src_dir);

    const include_dir = try std.fs.path.join(b.allocator, &[_][]const u8{ base_path, "lib", "include" });
    errdefer b.allocator.free(include_dir);

    const lib_src_path = try std.fs.path.join(b.allocator, &[_][]const u8{ src_dir, "lib.c" });
    errdefer b.allocator.free(lib_src_path);

    return Self{ .allocator = b.allocator, .base_path = base_path, .src_path = src_path, .include_dir = include_dir, .lib_src_path = lib_src_path };
}

pub fn deinit(self: *Self) void {
    self.allocator.free(base_path); // errdefer only runs if the block exits with an error
    self.allocator.free(src_dir); // errdefer only runs if the block exits with an error
    self.allocator.free(include_dir); // errdefer only runs if the block exits with an error
    self.allocator.free(lib_src_path); // errdefer only runs if the block exits with an error
}

pub fn link(self: Self, obj: *std.build.LibExeObjStep) void {
    obj.addCSourceFile(self.lib_src_path, &[_][]const u8{});
    obj.addIncludeDir(self.include_dir);
    obj.addIncludeDir(self.src_dir);
    obj.linkLibC();
}
