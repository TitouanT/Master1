#!/usr/bin/python
w = input("mot: ")
with open(w+".txt", "w") as f:
    for i, l in enumerate(w):
        f.write("{} {} {}\n".format(i+1, i+2, l))
    f.write("{}\n".format(len(w)+1))
