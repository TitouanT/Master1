#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

#include <ecran.h>
#define P pthread_mutex_lock(&gMutArea)
#define V pthread_mutex_unlock(&gMutArea)

#include <pthread.h>

booleen_t fini = FAUX;
ecran_t * ecran;
aire_t * aire;
bille_t ** tab_billes;

// static void arret(int sig) {
// 	static int cpt = 0;
//
// 	cpt++;
//
// 	switch(cpt) {
// 		case 1: break;
// 		case 2: break;
// 		default: fini = VRAI; break;
// 	}
// 	return;
// }



pthread_mutex_t gMutArea = PTHREAD_MUTEX_INITIALIZER;

typedef struct {
	// bille_t * bille;
	int id;
}billeLife_t;

// void P() {
// 	pthread_mutex_lock(&gMutArea);
// }
//
// void V() {
// 	pthread_mutex_unlock(&gMutArea);
// }

void * billeLife(void * arg) {
	// printf("newBille\n");
	// signal(SIGINT, arret);
	// billeLife_t * rarg = (billeLife_t*) arg;
	// bille_t * bille = rarg -> bille;
	int * id = (int *)arg;
	// char mess[ECRAN_LG_MESS];
	// while(1) {
		// sleep(5);
		// i++;
		// P;
		// ecran_bille_deplacer(ecran, aire, bille);
		// V;
		// P;
		printf("id:%d\n", *id);
		V;
		// V;
		// if(bille_active(bille)) {
		// 	// P();
		// 	ecran_bille_temporiser(bille);
		// 	// V();
		// }
		// else {
		// 	/* Desintegration de la bille */
		// 	sprintf(mess, "Desintegration de la bille");
		// 	// P();
		// 	// ecran_message_afficher(ecran, mess);
		// 	// ecran_bille_desintegrer(ecran, bille);
		//
		// 	/* On enleve cette bille de l'aire */
		// 	// aire_bille_enlever(aire, bille);
		// 	// V();
		// 	// bille_detruire(&bille);
			pthread_exit(&id);
		// }

	// }
	return (void*) NULL;
}



int main(int argc, char * argv[]) {
	// aire = NULL;
	// err_t cr = OK;
	// ecran = NULL;
	// char mess[ECRAN_LG_MESS];
	//
	// signal(SIGINT, arret);
	//
	// printf("\n\n\n\t===========Debut %s==========\n\n", argv[0]);
	//
	// if (argc != 4) {
	// 	printf(" Programme de test sur l'affichage de l'aire avec plusieurs billes\n");
	// 	printf(" usage: %s <Hauteur de l'aire> <Largeur de l'aire> <nb billes>\n", argv[0]);
	// 	exit(0);
	// }
	//
	// int Hauteur	= atoi(argv[1]);
	// int Largeur	= atoi(argv[2]);
	int NbBilles = atoi(argv[3]);
	// printf(" \nTest sur une aire de %dX%d et %d billes\n", Hauteur, Largeur, NbBilles);
	//
	// srand(getpid());
	//
	// /* Creation et affichage de l'aire */
	// printf("Creation de l'aire %dX%d\n", Hauteur, Largeur);
	// if ((aire = aire_creer(Hauteur, Largeur)) == AIRE_NULL) {
	// 	printf("Pb creation aire\n");
	// 	exit(-1);
	// }
	//
	// aire_afficher(aire);
	//
	// /* Creation et affichage de l'ecran */
	// if ((ecran = ecran_creer(aire)) == ECRAN_NULL) {
	// 	printf("Pb creation ecran\n");
	// 	exit(-1);
	// }
	//
	// ecran_afficher(ecran, aire);
	// ecran_message_afficher(ecran, "Envoyez un signal pour continuer");
	// pause();
	//
	// /* Creation des billes */
	// sprintf(mess, "Creation des %d billes\n", NbBilles);
	// ecran_message_pause_afficher(ecran, mess);
	//
	// tab_billes =(bille_t **)malloc(sizeof(bille_t *) * NbBilles);
	// int b;
	// for (b = 0; b < NbBilles; b++) {
	// 	tab_billes[b] = bille_creer(direction_random(), rand() % BILLE_VITESSE_MAX, COORD_NULL, '*');
	// 	if (tab_billes[b] == BILLE_NULL) {
	// 		sprintf(mess, "Pb creation bille bille %d\n", b);
	// 		ecran_message_pause_afficher(ecran, mess);
	// 		exit(-1);
	// 	}
	// }
	//
	// /* Positionnements et affichages des billes */
	// ecran_message_pause_afficher(ecran, "Positionnements des billes sur l'ecran");
	// for (b = 0; b < NbBilles; b++) {
	// 	sprintf(mess, "Pose de la bille %d\n", b);
	// 	ecran_message_afficher(ecran, mess);
	// 	if ((cr = ecran_bille_positionner(ecran, aire, tab_billes[b]))) {
	// 		sprintf(mess, "Pb lors de la pose de la bille %d", b);
	// 		ecran_message_pause_afficher(ecran, mess);
	// 		erreur_afficher(cr);
	// 		ecran_stderr_afficher(ecran);
	// 		exit(-1);
	// 	}
	// }
	//
	// ecran_message_afficher(ecran, "Envoyez un signal pour continuer");
	// pause();
	//
	// /* Deplacements des billes l'une apres l'autre */
	// ecran_message_pause_afficher(ecran, "Test deplacement des billes,(Deplacements jusqu'a un signal)");

	// liste_t * liste_billes = LISTE_NULL;
	// liste_id_t nb_billes = 0;
	// bille_t * bille = BILLE_NULL;
	pthread_t ids[NbBilles];
	for (int i = 0; i < NbBilles; i++) {
		// billeLife_t arg = {
		// 	// .bille = tab_billes[i],
		// 	.id = i
		// };
		int j = i;
		// pthread_t id;
		pthread_create(ids+i, NULL, billeLife, (void*)&j);
	}
	for (int i = 0; i < NbBilles; i++) {
		int * cr;
		pthread_join(ids[i], (void**)&cr);
		printf("CR%d:%d\n", i, *cr);
	}


// fin:
	// ecran_message_pause_afficher(ecran, "Arret");
	//
	// ecran_message_pause_afficher(ecran, "Destruction de la structure ecran");
	// pause();
	// ecran_detruire(&ecran);
	//
	// printf("\nDestruction aire\n");
	// aire_detruire(&aire);
	//
	// printf("\n\n\t===========Fin %s==========\n\n", argv[0]);

	return 0;
}
