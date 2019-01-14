#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>

#include <sens.h>
#include <train.h>
#include <moniteur_voie_unique.h>
// #include <voie_unique_stdio.h>




// #define P(m) pthread_mutex_lock(&(m -> mutex))
// #define V(m) pthread_mutex_unlock(&(m -> mutex))

/*---------- MONITEUR ----------*/


static void entrer(moniteur_voie_unique_t * m)
{
	pthread_mutex_lock(&(m -> mutex));
}

static void sortir(moniteur_voie_unique_t * m) {
	pthread_mutex_unlock(&(m -> mutex));
}

extern moniteur_voie_unique_t * moniteur_voie_unique_creer(const train_id_t nb) {
	moniteur_voie_unique_t * moniteur = malloc(sizeof(moniteur_voie_unique_t));

	/* Creation structure moniteur */
	if (moniteur == NULL) {
		fprintf(stderr, "moniteur_voie_unique_creer: debordement memoire (%lu octets demandes)\n",
		sizeof(moniteur_voie_unique_t));
		return NULL;
	}

	/* Creation de la voie */
	moniteur->voie_unique = voie_unique_creer();
	if (moniteur->voie_unique == NULL) return NULL;

	/* Initialisations du moniteur */
	moniteur->mutex = (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER;
	moniteur->condEO = (pthread_cond_t)PTHREAD_COND_INITIALIZER;
	moniteur->condOE = (pthread_cond_t)PTHREAD_COND_INITIALIZER;
	moniteur->maxTrain = nb;
	moniteur->nbTrainEO = 0;
	moniteur->nbTrainOE = 0;

	/***********/
	/* A FAIRE */
	/***********/

	return moniteur;
}

extern int moniteur_voie_unique_detruire(moniteur_voie_unique_t ** moniteur) {
	int noerr;

	/* Destructions des attribiuts du moniteur */
	pthread_mutex_destroy(&( (*moniteur) -> mutex ));
	pthread_cond_destroy(&( (*moniteur) -> condEO ));
	pthread_cond_destroy(&( (*moniteur) -> condOE ));

	/***********/
	/* A FAIRE */
	/***********/

	/* Destruction de la voie */
	noerr = voie_unique_detruire(&((*moniteur)->voie_unique));
	if (noerr) return noerr;

	/* Destruction de la strcuture du moniteur */
	free(*moniteur);

	(*moniteur)= NULL;

	return 0;
}

extern void moniteur_voie_unique_entree_ouest(moniteur_voie_unique_t * moniteur) {
	entrer(moniteur);
	while (moniteur -> nbTrainEO > 0 || moniteur -> nbTrainOE >= moniteur -> maxTrain) {
		pthread_cond_wait(&(moniteur -> condOE), &(moniteur -> mutex));
	}
	moniteur -> nbTrainOE += 1;
	pthread_cond_signal(&(moniteur -> condOE));
	sortir(moniteur);
}

extern void moniteur_voie_unique_sortie_est(moniteur_voie_unique_t * moniteur) {
	entrer(moniteur);
	moniteur -> nbTrainOE -= 1;
	// if (moniteur -> nbTrainOE == 0) {
		pthread_cond_signal(&(moniteur -> condEO));
	// }
	// if (moniteur -> nbTrainOE == moniteur -> maxTrain-1) {
		pthread_cond_signal(&(moniteur -> condOE));
	// }
	sortir(moniteur);
}

extern void moniteur_voie_unique_entree_est(moniteur_voie_unique_t * moniteur) {
	entrer(moniteur);
	while (moniteur -> nbTrainOE > 0 || moniteur -> nbTrainEO >= moniteur -> maxTrain) {
		pthread_cond_wait(&(moniteur -> condEO), &(moniteur -> mutex));
	}
	moniteur -> nbTrainEO += 1;
	pthread_cond_signal(&(moniteur -> condEO));
	sortir(moniteur);
}

extern void moniteur_voie_unique_sortie_ouest(moniteur_voie_unique_t * moniteur) {
	entrer(moniteur);
	moniteur -> nbTrainEO -= 1;
	if (moniteur -> nbTrainEO == 0) {
		pthread_cond_signal(&(moniteur -> condOE));
	}
	if (moniteur -> nbTrainEO == moniteur -> maxTrain-1) {
		pthread_cond_signal(&(moniteur -> condEO));
	}
	sortir(moniteur);
}

/*
 * Fonctions set/get
 */

extern voie_unique_t * moniteur_voie_unique_get(moniteur_voie_unique_t * const moniteur) {
	return moniteur->voie_unique;
}


extern train_id_t moniteur_max_trains_get(moniteur_voie_unique_t * const moniteur) {
	/***********/
	/* A FAIRE */
	/***********/
	return moniteur -> maxTrain; /* valeur arbitraire ici */
}

extern void moniteur_voie_unique_print(moniteur_voie_unique_t* m, affFunc aff) {
	voie_unique_t * voie = moniteur_voie_unique_get(m);
	entrer(m);
	aff(voie);
	sortir(m);
}

/*
 * Fonction de deplacement d'un train
 */

extern int moniteur_voie_unique_extraire(moniteur_voie_unique_t * moniteur, train_t * train, zone_t zone) {
	entrer(moniteur);
	int r = voie_unique_extraire(
		moniteur->voie_unique,
		(*train),
		zone,
		train_sens_get(train)
	);
	sortir(moniteur);

	return r;
}

extern int moniteur_voie_unique_inserer(moniteur_voie_unique_t * moniteur, train_t * train, zone_t zone) {
	entrer(moniteur);
	int r =  voie_unique_inserer(
		moniteur->voie_unique,
		(*train),
		zone,
		train_sens_get(train)
	);
	sortir(moniteur);

	return r;
}
