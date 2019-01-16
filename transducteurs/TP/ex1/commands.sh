rm -rf build
mkdir -p build/img
echo "construction de A"
fstcompile --acceptor --isymbols=abE.isyms --keep_isymbols A.txt ./build/A.fsa
fstdraw --acceptor --portrait ./build/A.fsa | dot -Tpng > ./build/img/A.png
fstprint --acceptor ./build/A.fsa
xdg-open ./build/img/A.png
echo
echo

echo "construction de B"
fstcompile --acceptor --isymbols=abE.isyms --keep_isymbols B.txt ./build/B.fsa
fstdraw --acceptor --portrait ./build/B.fsa | dot -Tpng > ./build/img/B.png
fstprint --acceptor ./build/B.fsa
# xdg-open ./build/img/B.png
echo
echo

echo "construction de A union B"
fstunion ./build/A.fsa ./build/B.fsa ./build/AuB.fsa
fstdraw --acceptor --portrait ./build/AuB.fsa | dot -Tpng > ./build/img/AuB.png
fstprint --acceptor ./build/AuB.fsa
# xdg-open ./build/img/AuB.png
echo
echo

echo "construction de A inter B"
fstintersect ./build/A.fsa ./build/B.fsa ./build/AnB.fsa
fstdraw --acceptor --portrait ./build/AnB.fsa | dot -Tpng > ./build/img/AnB.png
fstprint --acceptor ./build/AnB.fsa
# xdg-open ./build/img/AnB.png
echo
echo


echo "construction de concat A B"
fstconcat ./build/A.fsa ./build/B.fsa ./build/AB.fsa
fstdraw --acceptor --portrait ./build/AB.fsa | dot -Tpng > ./build/img/AB.png
fstprint --acceptor ./build/AB.fsa
# xdg-open ./build/img/AB.png
echo
echo


echo "construction de la fermeture de Kleen de A"
fstclosure ./build/A.fsa ./build/KA.fsa
fstdraw --acceptor --portrait ./build/KA.fsa | dot -Tpng > ./build/img/KA.png
fstprint --acceptor ./build/KA.fsa
# xdg-open ./build/img/KA.png
echo
echo


echo "construction de la fermeture de Kleen de B"
fstclosure ./build/B.fsa ./build/KB.fsa
fstdraw --acceptor --portrait ./build/KB.fsa | dot -Tpng > ./build/img/KB.png
fstprint --acceptor ./build/KB.fsa
# xdg-open ./build/img/KB.png
echo
echo


echo "determinisation de A union B"
fstrmepsilon ./build/AuB.fsa | fstdeterminize > ./build/deterAuB.fsa
fstdraw --acceptor --portrait ./build/deterAuB.fsa | dot -Tpng > ./build/img/deterAuB.png
fstprint --acceptor ./build/deterAuB.fsa
# xdg-open ./build/img/deterAuB.png
echo
echo


echo "construction de minAvant"
fstcompile --acceptor --isymbols=abE.isyms --keep_isymbols minAvant.txt ./build/minAvant.fsa
fstdraw --acceptor --portrait ./build/minAvant.fsa | dot -Tpng > ./build/img/minAvant.png
fstprint --acceptor ./build/minAvant.fsa
# xdg-open ./build/img/minAvant.png
echo
echo


echo "construction de minApres"
fstminimize --allow_nondet ./build/minAvant.fsa ./build/minApres.fsa
fstdraw --acceptor --portrait ./build/minApres.fsa | dot -Tpng > ./build/img/minApres.png
fstprint --acceptor ./build/minApres.fsa
# xdg-open ./build/img/minApres.png
echo
echo


echo "mot reconnus par A"
fstshortestpath --nshortest=4 --unique ./build/A.fsa ./build/Areconnu.fsa
fstdraw --acceptor --portrait ./build/Areconnu.fsa | dot -Tpng > ./build/img/Areconnu.png
fstprint --acceptor ./build/Areconnu.fsa
# xdg-open ./build/img/minApres.png
echo
echo


