debug: dev
	./debug

dev: west.c
	gcc -DDEBUG west.c -o debug


play: west
	./west

west: west.c
	gcc west.c -o west

clean:
	rm -rf west debug
