#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <sens.h>
#include <train.h>
#include <moniteur_voie_unique.h>

/*---------- MONITEUR ----------*/

extern moniteur_voie_unique_t * moniteur_voie_unique_creer( const train_id_t nb )
{
  moniteur_voie_unique_t * moniteur = NULL ; 

  /* Creation structure moniteur */
  if( ( moniteur = malloc( sizeof(moniteur_voie_unique_t) ) ) == NULL  )
    {
      fprintf( stderr , "moniteur_voie_unique_creer: debordement memoire (%lu octets demandes)\n" , 
	       sizeof(moniteur_voie_unique_t) ) ;
      return(NULL) ; 
    }

  /* Creation de la voie */
  if( ( moniteur->voie_unique = voie_unique_creer() ) == NULL )
    return(NULL) ; 
  
  /* Initialisations du moniteur */
  pthread_mutex_init(&moniteur->mutex, NULL);

  pthread_cond_init(&moniteur->cond_vide, NULL);
  pthread_cond_init(&moniteur->cond_plein, NULL);
  pthread_cond_init(&moniteur->cond_est_ouest, NULL);
  pthread_cond_init(&moniteur->cond_ouest_est, NULL);

  moniteur->cpt_ouest = 0;
  moniteur->cpt_est = 0;
  moniteur->cpt = 0;
  moniteur->max_train = nb;
  moniteur->sens_actuel = OUEST_EST;


  return(moniteur) ; 
}

extern int moniteur_voie_unique_detruire( moniteur_voie_unique_t ** moniteur )
{
  int noerr ; 

  /* Destructions des attribiuts du moniteur */

  //destruction du mutex
  pthread_mutex_destroy(&(*moniteur)->mutex);

  //destruction des variables de condition
  pthread_cond_destroy(&(*moniteur)->cond_vide);
  pthread_cond_destroy(&(*moniteur)->cond_plein);
  pthread_cond_destroy(&(*moniteur)->cond_est_ouest);
  pthread_cond_destroy(&(*moniteur)->cond_ouest_est);


  /* Destruction de la voie */
  if( ( noerr = voie_unique_detruire( &((*moniteur)->voie_unique) ) ) )
    return(noerr) ;

  /* Destruction de la strcuture du moniteur */
  free( (*moniteur) );

  (*moniteur) = NULL ; 

  return(0) ; 
}

extern void moniteur_voie_unique_entree_ouest( moniteur_voie_unique_t * moniteur ) 
{
  bool continuer = true;

  //verrouillage du mutex
  pthread_mutex_lock(&moniteur->mutex);

  //si aucun train n'est en attente pour entrer dans l'autre sens, on change le sens
  if (moniteur->cpt_est == 0 && moniteur->sens_actuel == EST_OUEST) {
    moniteur->sens_actuel = OUEST_EST;
  }

  //mise a jour du nombre de train souhaitant entrer
  moniteur->cpt_ouest++;

  //on utilise une boucle while et non un if car lorsqu'il y a de la place sur la voie, la condition du sens peut avoir changée avant le réveil.
  while (continuer) {
    continuer = false;
    //si le sens est opposé, on met en attente le processus, puis on réveil en cascade
    if (moniteur->sens_actuel == EST_OUEST) {
      pthread_cond_wait(&moniteur->cond_ouest_est, &moniteur->mutex);
      pthread_cond_signal(&moniteur->cond_ouest_est);
      continuer = true;
    }
    //si la voie est pleine, mise en sommeil du processus
    if (moniteur->cpt == moniteur->max_train) {
      pthread_cond_wait(&moniteur->cond_plein, &moniteur->mutex);
      continuer = true;
    }
  }

  //mise à jour du nombre total de trains
  moniteur->cpt++;

  //si un seul train est sur la voie, on réveil la sortie
  if (moniteur->cpt == 1) {
    pthread_cond_signal(&moniteur->cond_vide);
  }

  //deverrouillage du mutex sur le moniteur
  pthread_mutex_unlock(&moniteur->mutex);
}

extern void moniteur_voie_unique_sortie_est( moniteur_voie_unique_t * moniteur ) 
{
  //verrouillage du mutex sur le moniteur
  pthread_mutex_lock(&moniteur->mutex);

  //si la voie est vide, on attend
  if (moniteur->cpt == 0) {
    pthread_cond_wait(&(moniteur->cond_vide), &(moniteur->mutex));
  }

  //mise a jour des compteurs
  moniteur->cpt_ouest--;
  moniteur->cpt--;

  //si la voie n'est pas pleine, on reveil une entrée
  if (moniteur->cpt == moniteur->max_train - 1) {
    pthread_cond_signal(&moniteur->cond_plein);
  }

  //si plus aucun train ne souhaite entrer, on change le sens et on réveille les trains dans le sens opposé
  if (moniteur->cpt_ouest == 0) {
    moniteur->sens_actuel = EST_OUEST;
    pthread_cond_signal(&moniteur->cond_est_ouest);
  } else {//reveil d'un train dans notre sens
    pthread_cond_signal(&moniteur->cond_ouest_est);
  }

  pthread_mutex_unlock(&moniteur->mutex);
}

extern void moniteur_voie_unique_entree_est( moniteur_voie_unique_t * moniteur ) 
{
  bool continuer = true;

  //verrouillage du mutex sur le moniteur
  pthread_mutex_lock(&moniteur->mutex);

  //si aucun train n'est en attente pour entrer dans l'autre sens, on change le sens
  if (moniteur->cpt_ouest == 0) {
    moniteur->sens_actuel = EST_OUEST;
  }

  //mise à jour du nombre de train souhaitant entrer
  moniteur->cpt_est++;

  //on utilise une boucle while et non un if car lorsqu'il y a de la place sur la voie, la condition du sens peut avoir changée avant le réveil.
  while (continuer) {
    continuer = false;
    //si le sens est opposé, on met en attente le processus, puis on réveil en cascade
    if (moniteur->sens_actuel == OUEST_EST) {
      pthread_cond_wait(&moniteur->cond_est_ouest, &moniteur->mutex);
      pthread_cond_signal(&moniteur->cond_est_ouest);
      continuer = true;
    }
    //si la voie est pleine, mise en sommeil du processus
    if (moniteur->cpt == moniteur->max_train) {
      pthread_cond_wait(&moniteur->cond_plein, &moniteur->mutex);
      continuer = true;
    }
  }

  //mise à jour du nombre total de trains
  moniteur->cpt++;

  //si un seul train est sur la voie, on réveil la sortie
  if (moniteur->cpt == 1) {
    pthread_cond_signal(&moniteur->cond_vide);
  }

  //deverrouillage du mutex sur le moniteur
  pthread_mutex_unlock(&moniteur->mutex);
}

extern void moniteur_voie_unique_sortie_ouest( moniteur_voie_unique_t * moniteur ) 
{
  //verrouillage du mutex sur le moniteur
  pthread_mutex_lock(&moniteur->mutex);

  //si la voie est vide, on attend
  if (moniteur->cpt == 0) {
    pthread_cond_wait(&(moniteur->cond_vide), &(moniteur->mutex));
  }

  //mise à jour des compteurs
  moniteur->cpt_est--;
  moniteur->cpt--;

  //si la voie n'est pas pleine, on reveil une entrée
  if (moniteur->cpt == moniteur->max_train - 1) {
    pthread_cond_signal(&(moniteur->cond_plein));
  }

  //si plus aucun train ne souhaite entrer, on change le sens et on réveille les trains dans le sens opposé
  if (moniteur->cpt_est == 0) {
    moniteur->sens_actuel = OUEST_EST;
    pthread_cond_signal(&moniteur->cond_ouest_est);
  } else {//reveil d'un train dans notre sens
    pthread_cond_signal(&moniteur->cond_est_ouest);
  }

  //deverrouillage du mutex sur le moniteur
  pthread_mutex_unlock(&moniteur->mutex);
}

/*
 * Fonctions set/get 
 */

extern 
voie_unique_t * moniteur_voie_unique_get( moniteur_voie_unique_t * const moniteur )
{
  return( moniteur->voie_unique ) ; 
}


extern 
train_id_t moniteur_max_trains_get( moniteur_voie_unique_t * const moniteur )
{
  return( moniteur->max_train ) ; /* valeur arbitraire ici */
}

/*
 * Fonction de deplacement d'un train 
 */

extern
int moniteur_voie_unique_extraire( moniteur_voie_unique_t * moniteur , train_t * train , zone_t zone  ) 
{
  return( voie_unique_extraire( moniteur->voie_unique, 
				(*train), 
				zone , 
				train_sens_get(train) ) ) ; 
}

extern
int moniteur_voie_unique_inserer( moniteur_voie_unique_t * moniteur , train_t * train , zone_t zone ) 
{ 
  return( voie_unique_inserer( moniteur->voie_unique, 
			       (*train), 
			       zone, 
			       train_sens_get(train) ) ) ;
}
