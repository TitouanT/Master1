rm -rf build
mkdir -p build/img

echo "construction de homme"
fstcompile --isymbols=ascii.isyms --osymbols=map.osyms --keep_isymbols --keep_osymbols homme.txt ./build/homme.fst
fstdraw --portrait ./build/homme.fst | dot -Tsvg > ./build/img/homme.svg
fstprint ./build/homme.fst
xdg-open ./build/img/homme.svg
echo
echo

echo "construction de martien"
fstcompile --isymbols=ascii.isyms --osymbols=map.osyms --keep_isymbols --keep_osymbols martien.txt ./build/martien.fst
fstdraw --portrait ./build/martien.fst | dot -Tsvg > ./build/img/martien.svg
fstprint ./build/martien.fst
# xdg-open ./build/img/martien.svg
echo
echo

echo "construction de mars"
fstcompile --isymbols=ascii.isyms --osymbols=map.osyms --keep_isymbols --keep_osymbols mars.txt ./build/mars.fst
fstdraw --portrait ./build/mars.fst | dot -Tsvg > ./build/img/mars.svg
fstprint ./build/mars.fst
# xdg-open ./build/img/mars.svg
echo
echo

echo "construction du combo minimal deterministe"
fstunion ./build/homme.fst ./build/mars.fst ./build/tmp.fst
fstunion ./build/tmp.fst ./build/martien.fst | fstclosure --closure_plus | fstrmepsilon | fstdeterminize | fstminimize > ./build/combo.fst
rm ./build/tmp.fst
fstdraw --portrait ./build/combo.fst | dot -Tsvg > ./build/img/combo.svg
fstprint ./build/combo.fst
# xdg-open ./build/img/combo.svg
echo
echo

echo "construction de hommeMars"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols hommeMars.txt ./build/hommeMars.fsa
fstdraw --acceptor --portrait ./build/hommeMars.fsa | dot -Tsvg > ./build/img/hommeMars.svg
fstprint --acceptor ./build/hommeMars.fsa
# xdg-open ./build/img/mars.svg
echo
echo

echo "construction de hommeMars rond combo"
fstcompose ./build/hommeMars.fsa ./build/combo.fst | fstproject --project_output > ./build/hommeMarsOcombo.fst
fstdraw --portrait ./build/hommeMarsOcombo.fst | dot -Tsvg > ./build/img/hommeMarsOcombo.svg
fstdraw --acceptor --portrait ./build/hommeMarsOcombo.fst | dot -Tsvg > ./build/img/hommeMarsOcombo.svg
fstprint ./build/hommeMarsOcombo.fst
echo
echo


echo "construction de homme_Mars"
fstcompile --acceptor --isymbols=ascii.isyms --keep_isymbols homme_Mars.txt ./build/homme_Mars.fsa
fstdraw --acceptor --portrait ./build/homme_Mars.fsa | dot -Tsvg > ./build/img/homme_Mars.svg
fstprint --acceptor ./build/homme_Mars.fsa
echo
echo

echo "construction de homme_Mars rond combo"
fstcompose ./build/homme_Mars.fsa ./build/combo.fst | fstproject --project_output > ./build/homme_MarsOcombo.fst
fstdraw --acceptor --portrait ./build/homme_MarsOcombo.fst | dot -Tsvg > ./build/img/homme_MarsOcombo.svg
fstprint ./build/homme_MarsOcombo.fst
echo
echo
# echo "mot reconnus par A"
# fstshortestpath --nshortest=10 --unique ./build/combo.fst ./build/reconnu.fst
# fstdraw --acceptor --portrait ./build/reconnu.fst | dot -Tsvg > ./build/img/reconnu.svg
# fstprint --acceptor ./build/reconnu.fst
# # xdg-open ./build/img/reconnu.svg
# echo
# echo

