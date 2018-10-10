#include <stdio.h>

#define N 5



int main(int argc, char const *argv[]) {
	/*
	initialisation des shm
	*/

	const void * states = shmget(IPC_PRIVATE, N * sizeof(State), IPC_CREAT | 0666);


	/*
	initialisation des semaphores
	*/

	const int sEtats = semget(IPC_PRIVATE, N, IPC_CREAT);
	if (sEtats == -1) {
		perror("semget: ");
		exit(-1);
	}
	return 0;
}
