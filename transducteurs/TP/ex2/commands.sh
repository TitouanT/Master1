rm -rf build
mkdir -p build/img
echo "construction de homme"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols homme.txt ./build/homme.fsa
fstdraw --acceptor --portrait ./build/homme.fsa | dot -Tpng > ./build/img/homme.png
fstprint --acceptor ./build/homme.fsa
xdg-open ./build/img/homme.png
echo
echo

echo "construction de Mars"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols Mars.txt ./build/Mars.fsa
fstdraw --acceptor --portrait ./build/Mars.fsa | dot -Tpng > ./build/img/Mars.png
fstprint --acceptor ./build/Mars.fsa
# xdg-open ./build/img/Mars.png
echo
echo

echo "construction de Martien"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols Martien.txt ./build/Martien.fsa
fstdraw --acceptor --portrait ./build/Martien.fsa | dot -Tpng > ./build/img/Martien.png
fstprint --acceptor ./build/Martien.fsa
# xdg-open ./build/img/Martien.png
echo
echo


echo "construction du combo minimal deterministe"
fstunion ./build/homme.fsa ./build/Mars.fsa ./build/tmp.fsa
fstunion ./build/tmp.fsa ./build/Martien.fsa | fstclosure | fstrmepsilon | fstdeterminize | fstminimize > ./build/combo.fsa
rm ./build/tmp.fsa
fstdraw --acceptor --portrait ./build/combo.fsa | dot -Tpng > ./build/img/combo.png
fstprint --acceptor ./build/combo.fsa
# xdg-open ./build/img/combo.png
echo
echo

echo "mot reconnus par A"
fstshortestpath --nshortest=10 --unique ./build/combo.fsa ./build/reconnu.fsa
fstdraw --acceptor --portrait ./build/reconnu.fsa | dot -Tpng > ./build/img/reconnu.png
fstprint --acceptor ./build/reconnu.fsa
# xdg-open ./build/img/reconnu.png
echo
echo
