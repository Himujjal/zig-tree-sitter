TSV=0.19.2
wget https://github.com/tree-sitter/tree-sitter/archive/v$TSV.tar.gz -O yo.tar.gz
tar -xf yo.tar.gz
zig translate-c -lc tree-sitter-$TSV/lib/include/tree_sitter/api.h > src/api.zig
cd tree-sitter-$TSV
make libtree-sitter.a CC="zig cc" CFLAGS="-Wall -O3"
cp libtree-sitter.a ../libtree-sitter.a
cd ..

git clone https://github.com/Himujjal/tree-sitter-svelte --depth=1
zig cc ./tree-sitter-svelte/src/scanner.c -I./tree-sitter-svelte/src -c
zig cc ./tree-sitter-svelte/src/parser.c -I./tree-sitter-svelte/src -c
ar rcs libtree-sitter-svelte.a scanner.o parser.o

zig cc src/main.zig libtree-sitter-svelte.a libtree-sitter.a

rm -rf *.o
rm -rf tree-sitter-svelte
rm -rf tree-sitter-$TSV
rm -rf yo.tar.gz

