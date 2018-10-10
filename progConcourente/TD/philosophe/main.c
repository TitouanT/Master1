#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/wait.h>

#define N 5
#define REP 10
#define TEMPS_PENSER 5
#define TEMPS_MANGER 5

enum {PENSE, MANGE, ATTENDSEM, FINI};

int sem;
int * shm;
int shmid;


void penser(int p) {
	int t = random()%TEMPS_PENSER + 1;
	// printf("%d pense  (%d sec)\n", p, t);
	shm[p] = PENSE;
	sleep(t);
	shm[p] = ATTENDSEM;
}

void manger(int p) {
	int t = random()%TEMPS_MANGER + 1;
	// printf("%d MANGE  (%d sec)\n", p, t);
	shm[p] = MANGE;
	sleep(t);
	shm[p] = ATTENDSEM;
}

void monitor() {
	printf("Penser = ' '\nManger = '|'\nEn attente sur un semaphore = '-'\n");
	while(shm[N] != FINI) {
		printf("#");
		for (int i = 0; i < N; i++) {
			switch(shm[i]) {
				case PENSE:      printf("   "); break;
				case MANGE:      printf(" | "); break;
				case ATTENDSEM:  printf(" + "); break;
				case FINI:       printf("..."); break;
			}
		}
		printf("#\n");
		sleep(1);
	}
}


void philosophe(int p) {
	srandom(getpid());
	const int f1 = p;
	const int f2 = (p+1)%N;
	struct sembuf op_P[] = {
		{f1, -1, 0},
		{f2, -1, 0},
	};

	struct sembuf op_V[] = {
		{f1, 1, 0},
		{f2, 1, 0},
	};

	for (int i = 0; i < REP; i++) {
		penser(p);
		semop(sem, op_P, 2);
		manger(p);
		semop(sem, op_V, 2);
	}
	shm[p] = FINI;
}

int main(int argc, char const *argv[]) {

	/*
	Segment de memoire partagé
	*/
	shmid = shmget(IPC_PRIVATE, (N+1) * sizeof(int), IPC_CREAT | 0666);
	shm = shmat(shmid, 0,0);
	for (int i = 0; i <= N; i++) shm[i] = ATTENDSEM;

	/*
	initialisation des semaphores
	*/

	sem = semget(IPC_PRIVATE, N, IPC_CREAT | 0666);
	if (sem == -1) {
		perror("Pb semget: ");
		exit(-1);
	}

	for (int i = 0; i < N; i++) {
		semctl(sem, i, SETVAL, 1);
	}


	for (int i = 0; i < N; i++) {
		switch (fork()) {
			case 0: philosophe(i); exit(0);
		}
	}

	switch(fork()) {
		case 0: monitor(); exit(0);
	}


	for (int i = 0; i < N; i++) wait(NULL);
	shm[N] = FINI;

	semctl(sem, 0, IPC_RMID, 0);
	shmctl(shmid, IPC_RMID, NULL);
	return 0;
}
