#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>

#include "liste.h"
#include "piste.h"

#define keyListe 10
#define keyPiste 20
#define droit IPC_CREAT|0666

int main() {
	int semid;
	semid = semget(keyListe, 1, droit);
	semctl(semid, 0, SETVAL, 1);
	shmget(keyListe, sizeof(liste_t), droit);

	semid = semget(keyPiste, PISTE_LONGUEUR, droit);
	for (int i = 0; i < PISTE_LONGUEUR; i++)
		semctl(semid, i, SETVAL, 1);
	shmget(keyPiste, sizeof(piste_t), droit);


}
