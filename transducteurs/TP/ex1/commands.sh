rm -rf build
mkdir -p build/img
echo "construction de A"
fstcompile --acceptor --isymbols=abE.isyms --keep_isymbols A.txt ./build/A.fsa
fstdraw --acceptor --portrait ./build/A.fsa | dot -Tsvg > ./build/img/A.svg
fstprint --acceptor ./build/A.fsa
xdg-open ./build/img/A.svg
echo
echo

echo "construction de B"
fstcompile --acceptor --isymbols=abE.isyms --keep_isymbols B.txt ./build/B.fsa
fstdraw --acceptor --portrait ./build/B.fsa | dot -Tsvg > ./build/img/B.svg
fstprint --acceptor ./build/B.fsa
# xdg-open ./build/img/B.svg
echo
echo

echo "construction de A union B"
fstunion ./build/A.fsa ./build/B.fsa ./build/AuB.fsa
fstdraw --acceptor --portrait ./build/AuB.fsa | dot -Tsvg > ./build/img/AuB.svg
fstprint --acceptor ./build/AuB.fsa
# xdg-open ./build/img/AuB.svg
echo
echo

echo "construction de A inter B"
fstintersect ./build/A.fsa ./build/B.fsa ./build/AnB.fsa
fstdraw --acceptor --portrait ./build/AnB.fsa | dot -Tsvg > ./build/img/AnB.svg
fstprint --acceptor ./build/AnB.fsa
# xdg-open ./build/img/AnB.svg
echo
echo


echo "construction de concat A B"
fstconcat ./build/A.fsa ./build/B.fsa ./build/AB.fsa
fstdraw --acceptor --portrait ./build/AB.fsa | dot -Tsvg > ./build/img/AB.svg
fstprint --acceptor ./build/AB.fsa
# xdg-open ./build/img/AB.svg
echo
echo


echo "construction de la fermeture de Kleen de A"
fstclosure ./build/A.fsa ./build/KA.fsa
fstdraw --acceptor --portrait ./build/KA.fsa | dot -Tsvg > ./build/img/KA.svg
fstprint --acceptor ./build/KA.fsa
# xdg-open ./build/img/KA.svg
echo
echo


echo "construction de la fermeture de Kleen de B"
fstclosure ./build/B.fsa ./build/KB.fsa
fstdraw --acceptor --portrait ./build/KB.fsa | dot -Tsvg > ./build/img/KB.svg
fstprint --acceptor ./build/KB.fsa
# xdg-open ./build/img/KB.svg
echo
echo


echo "determinisation de A union B"
fstrmepsilon ./build/AuB.fsa | fstdeterminize > ./build/deterAuB.fsa
fstdraw --acceptor --portrait ./build/deterAuB.fsa | dot -Tsvg > ./build/img/deterAuB.svg
fstprint --acceptor ./build/deterAuB.fsa
# xdg-open ./build/img/deterAuB.svg
echo
echo


echo "construction de minAvant"
fstcompile --acceptor --isymbols=abE.isyms --keep_isymbols minAvant.txt ./build/minAvant.fsa
fstdraw --acceptor --portrait ./build/minAvant.fsa | dot -Tsvg > ./build/img/minAvant.svg
fstprint --acceptor ./build/minAvant.fsa
# xdg-open ./build/img/minAvant.svg
echo
echo


echo "construction de minApres"
fstminimize --allow_nondet ./build/minAvant.fsa ./build/minApres.fsa
fstdraw --acceptor --portrait ./build/minApres.fsa | dot -Tsvg > ./build/img/minApres.svg
fstprint --acceptor ./build/minApres.fsa
# xdg-open ./build/img/minApres.svg
echo
echo


echo "mot reconnus par A"
fstshortestpath --nshortest=4 --unique ./build/A.fsa ./build/Areconnu.fsa
fstdraw --acceptor --portrait ./build/Areconnu.fsa | dot -Tsvg > ./build/img/Areconnu.svg
fstprint --acceptor ./build/Areconnu.fsa
# xdg-open ./build/img/minApres.svg
echo
echo


