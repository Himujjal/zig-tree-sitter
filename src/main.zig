const TS = @import("./api.zig");
const std = @import("std");

const TSParser = TS.TSParser;
const ts_parser_set_language = TS.ts_parser_set_language;
const ts_parser_parse_string = TS.ts_parser_parse_string;
const TSNode = TS.TSNode;
const TSTree = TS.TSTree;
const ts_node_string = TS.ts_node_string;
const TSLanguage = TS.TSLanguage;
const ts_parser_new = TS.ts_parser_new;
const ts_tree_root_node = TS.ts_tree_root_node;

pub extern fn tree_sitter_svelte() ?*TSLanguage;
pub extern fn free(__ptr: ?*c_void) void;

pub fn main() !void {
    var parser: ?*TSParser = ts_parser_new();
    defer TS.ts_parser_delete(parser);

    var res: bool = ts_parser_set_language(parser, tree_sitter_svelte());
    var source_code = "<div>hello</div>";
    var tree: ?*TSTree = ts_parser_parse_string(parser, null, source_code, @bitCast(u32, @truncate(c_uint, source_code.len)));
    defer TS.ts_tree_delete(tree);

    var root_node: TSNode = ts_tree_root_node(tree);
    var string: [*:0]u8 = ts_node_string(root_node);
    defer free(@ptrCast(?*c_void, string));

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Syntax tree: {s}\n", .{string});
}
