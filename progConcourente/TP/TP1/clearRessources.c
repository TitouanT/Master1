#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>

#include "liste.h"
#include "piste.h"

#define keyListe 10
#define keyPiste 20
#define droit 0666

int main() {
	int semid, shmid;
	semid = semget(keyListe, 1, droit);
	semctl(semid, 0, IPC_RMID, 0);
	shmid = shmget(keyListe, sizeof(liste_t), droit);
	shmctl(shmid, IPC_RMID, NULL);

	semid = semget(keyPiste, PISTE_LONGUEUR, droit);
	semctl(semid, 0, IPC_RMID, 0);
	shmget(keyPiste, sizeof(piste_t), droit);
	shmctl(shmid, IPC_RMID, NULL);


}
