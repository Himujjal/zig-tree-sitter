const TS = @import("./lib.zig");
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

test {
    const SAMPLE_CODE = "<div>hello</div>";   

    var parser: ?*TS.TSParser = ts_parser_new();
    defer TS.ts_parser_delete(parser);

    var res: bool = TS.ts_parser_set_language(parser, tree_sitter_svelte());
    var tree: ?*TS.TSTree = TS.ts_parser_parse_string(parser, null, SAMPLE_CODE, SAMPLE_CODE.len);
    defer TS.ts_tree_delete(tree);

    var root_node: TSNode = TS.ts_tree_root_node(tree);
    var string: [*:0]u8 = TS.ts_node_string(root_node);
    defer free(@ptrCast(?*c_void, string));

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Syntax tree: {s}\n", .{string});

    std.testing.expect(1 == 1);
}
