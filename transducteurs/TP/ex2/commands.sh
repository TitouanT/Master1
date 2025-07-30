rm -rf build
mkdir -p build/img
echo "construction de homme"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols homme.txt ./build/homme.fsa
fstdraw --acceptor --portrait ./build/homme.fsa | dot -Tsvg > ./build/img/homme.svg
fstprint --acceptor ./build/homme.fsa
xdg-open ./build/img/homme.svg
echo
echo

echo "construction de Mars"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols Mars.txt ./build/Mars.fsa
fstdraw --acceptor --portrait ./build/Mars.fsa | dot -Tsvg > ./build/img/Mars.svg
fstprint --acceptor ./build/Mars.fsa
# xdg-open ./build/img/Mars.svg
echo
echo

echo "construction de Martien"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols Martien.txt ./build/Martien.fsa
fstdraw --acceptor --portrait ./build/Martien.fsa | dot -Tsvg > ./build/img/Martien.svg
fstprint --acceptor ./build/Martien.fsa
# xdg-open ./build/img/Martien.svg
echo
echo


echo "construction du combo minimal deterministe"
fstunion ./build/homme.fsa ./build/Mars.fsa ./build/tmp.fsa
fstunion ./build/tmp.fsa ./build/Martien.fsa | fstclosure --closure_plus | fstrmepsilon | fstdeterminize | fstminimize > ./build/combo.fsa
rm ./build/tmp.fsa
fstdraw --acceptor --portrait ./build/combo.fsa | dot -Tsvg > ./build/img/combo.svg
fstprint --acceptor ./build/combo.fsa
# xdg-open ./build/img/combo.svg
echo
echo

echo "mot reconnus par A"
fstshortestpath --nshortest=10 --unique ./build/combo.fsa ./build/reconnu.fsa
fstdraw --acceptor --portrait ./build/reconnu.fsa | dot -Tsvg > ./build/img/reconnu.svg
fstprint --acceptor ./build/reconnu.fsa
# xdg-open ./build/img/reconnu.svg
echo
echo
