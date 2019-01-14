TPS = 2 3 4 5 6

all:
	ghc -w -dynamic --make tester.hs

clean:
	rm -f *.hi *.o

$(TPS): all
	./tester $@

test: all $(TPS)
