rm -rf build
mkdir -p build/img

echo "construction de today"
fstcompile --isymbols=./alpha/entree.syms --osymbols=./alpha/pron.full.syms --keep_isymbols --keep_osymbols ./words/today.txt ./build/today.fst
fstdraw --portrait ./build/today.fst | dot -Tsvg > ./build/img/today.svg
xdg-open ./build/img/today.svg
echo
echo

echo "construction de is"
fstcompile --isymbols=./alpha/entree.syms --osymbols=./alpha/pron.full.syms --keep_isymbols --keep_osymbols ./words/is.txt ./build/is.fst
fstdraw --portrait ./build/is.fst | dot -Tsvg > ./build/img/is.svg
echo
echo
echo "construction de the"
fstcompile --isymbols=./alpha/entree.syms --osymbols=./alpha/pron.full.syms --keep_isymbols --keep_osymbols ./words/the.txt ./build/the.fst
fstdraw --portrait ./build/the.fst | dot -Tsvg > ./build/img/the.svg
echo
echo
echo "construction de last"
fstcompile --isymbols=./alpha/entree.syms --osymbols=./alpha/pron.full.syms --keep_isymbols --keep_osymbols ./words/last.txt  ./build/last.fst
fstdraw --portrait ./build/last.fst | dot -Tsvg > ./build/img/last.svg
echo
echo
echo "construction de day"
fstcompile --isymbols=./alpha/entree.syms --osymbols=./alpha/pron.full.syms --keep_isymbols --keep_osymbols ./words/day.txt  ./build/day.fst
fstdraw --portrait ./build/day.fst | dot -Tsvg > ./build/img/day.svg
echo
echo
echo "construction de for"
fstcompile --isymbols=./alpha/entree.syms --osymbols=./alpha/pron.full.syms --keep_isymbols --keep_osymbols ./words/for.txt ./build/for.fst
fstdraw --portrait ./build/for.fst | dot -Tsvg > ./build/img/for.svg
echo
echo
echo "construction de automata"
fstcompile --isymbols=./alpha/entree.syms --osymbols=./alpha/pron.full.syms --keep_isymbols --keep_osymbols ./words/automata.txt ./build/automata.fst
fstdraw --portrait ./build/automata.fst | dot -Tsvg > ./build/img/automata.svg
echo
echo


echo "construction du transducteur permettant de traduire"
fstunion ./build/today.fst ./build/is.fst ./build/tmp.fst
fstunion ./build/tmp.fst ./build/the.fst ./build/tmp.fst
fstunion ./build/tmp.fst ./build/last.fst ./build/tmp.fst
fstunion ./build/tmp.fst ./build/day.fst ./build/tmp.fst
fstunion ./build/tmp.fst ./build/for.fst ./build/tmp.fst
fstunion ./build/tmp.fst ./build/automata.fst ./build/tmp.fst

fstclosure --closure_plus ./build/tmp.fst | fstrmepsilon | fstdeterminize | fstminimize > ./build/traducteur.fst
# fstclosure --closure_plus ./build/tmp.fst > ./build/traducteur.fst # non opti
rm ./build/tmp.fst
fstdraw --portrait ./build/traducteur.fst | dot -Tsvg > ./build/img/traducteur.svg
echo
echo

# on fait une composition puis une projection pour voir si on reconnait bien
