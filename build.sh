rm -rf lib

TSV=0.19.2
wget https://github.com/tree-sitter/tree-sitter/archive/v$TSV.tar.gz -O yo.tar.gz
tar -xf yo.tar.gz
zig translate-c -lc tree-sitter-$TSV/lib/include/tree_sitter/api.h > src/main.zig
mv tree-sitter-$TSV/lib .

rm -rf tree-sitter-$TSV
rm -rf yo.tar.gz
