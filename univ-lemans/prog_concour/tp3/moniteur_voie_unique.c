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

  /***********/
  /* A FAIRE */
  /***********/
  pthread_mutex_init(&moniteur->mutex_moniteur, NULL);
  pthread_cond_init(&moniteur->cond_Vide, NULL);
  pthread_cond_init(&moniteur->cond_Pleine, NULL);

  pthread_cond_init(&moniteur->sens_Ouest_Est, NULL);
  pthread_cond_init(&moniteur->sens_Est_Ouest, NULL);

  moniteur->nb_train_ouest_est = 0;
  moniteur->nb_train_est_ouest = 0;
  moniteur->nb_train_entrant = 0;
  moniteur->nb_train_max = nb;
  moniteur->sens_courant = OUEST_EST; //sens par défaut

  return(moniteur) ;
}

extern int moniteur_voie_unique_detruire( moniteur_voie_unique_t ** moniteur )
{
  int noerr ;

  /* Destructions des attribiuts du moniteur */

  /***********/
  /* A FAIRE */
  /***********/
  pthread_mutex_destroy(&((*moniteur)->mutex_moniteur));
  pthread_cond_destroy(&((*moniteur)->cond_Vide));
  pthread_cond_destroy(&((*moniteur)->cond_Pleine));
  pthread_cond_destroy(&((*moniteur)->sens_Ouest_Est));
  pthread_cond_destroy(&((*moniteur)->sens_Est_Ouest));


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
  /***********/
  /* A FAIRE */
  /***********/
  pthread_mutex_lock(&moniteur->mutex_moniteur);

  moniteur->nb_train_ouest_est++;

  while(true){
    if(moniteur->sens_courant == EST_OUEST){
      pthread_cond_wait(&moniteur->sens_Ouest_Est, &moniteur->mutex_moniteur);
      pthread_cond_signal(&moniteur->sens_Ouest_Est);
    }
    else if(moniteur->nb_train_entrant == moniteur->nb_train_max){
      pthread_cond_wait(&moniteur->cond_Pleine, &moniteur->mutex_moniteur);
    }
    else{
      break;
    }
  }
  moniteur->nb_train_entrant++;

  if(moniteur->nb_train_entrant == 1)
    pthread_cond_signal(&moniteur->cond_Vide);

  pthread_mutex_unlock(&moniteur->mutex_moniteur);
}

extern void moniteur_voie_unique_sortie_est( moniteur_voie_unique_t * moniteur )
{
  /***********/
  /* A FAIRE */
  /***********/
  pthread_mutex_lock(&moniteur->mutex_moniteur);

  if(moniteur->nb_train_entrant == 0)
    pthread_cond_wait(&moniteur->cond_Vide, &moniteur->mutex_moniteur);

  moniteur->nb_train_ouest_est--;
  moniteur->nb_train_entrant--;

  if(moniteur->nb_train_entrant == moniteur->nb_train_max)
    pthread_cond_wait(&moniteur->cond_Pleine, &moniteur->mutex_moniteur);

  if(moniteur->nb_train_ouest_est == 0){
    moniteur->sens_courant = EST_OUEST;
    pthread_cond_signal(&moniteur->sens_Est_Ouest);
  }

  pthread_mutex_unlock(&moniteur->mutex_moniteur);

}

extern void moniteur_voie_unique_entree_est( moniteur_voie_unique_t * moniteur )
{
  /***********/
  /* A FAIRE */
  /***********/
  pthread_mutex_lock(&moniteur->mutex_moniteur);

  moniteur->nb_train_est_ouest++;

  while(true){
    if(moniteur->sens_courant == OUEST_EST){
      pthread_cond_wait(&moniteur->sens_Est_Ouest, &moniteur->mutex_moniteur);
      pthread_cond_signal(&moniteur->sens_Ouest_Est);
    }
    else if(moniteur->nb_train_entrant == moniteur->nb_train_max){
      pthread_cond_wait(&moniteur->cond_Pleine, &moniteur->mutex_moniteur);
    }
    else{
      break;
    }
  }
  moniteur->nb_train_entrant++;

  if(moniteur->nb_train_entrant == 1)
    pthread_cond_signal(&moniteur->cond_Vide);

  pthread_mutex_unlock(&moniteur->mutex_moniteur);
}

extern void moniteur_voie_unique_sortie_ouest( moniteur_voie_unique_t * moniteur )
{
  /***********/
  /* A FAIRE */
  /***********/
  pthread_mutex_lock(&moniteur->mutex_moniteur);

  if(moniteur->nb_train_entrant == 0)
    pthread_cond_wait(&moniteur->cond_Vide, &moniteur->mutex_moniteur);

  moniteur->nb_train_est_ouest--;
  moniteur->nb_train_entrant--;

  if(moniteur->nb_train_entrant == moniteur->nb_train_max)
    pthread_cond_wait(&moniteur->cond_Pleine, &moniteur->mutex_moniteur);

  if(moniteur->nb_train_est_ouest == 0){
    moniteur->sens_courant = OUEST_EST;
    pthread_cond_signal(&moniteur->sens_Ouest_Est);
  }

  pthread_mutex_unlock(&moniteur->mutex_moniteur);
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
  /***********/
  /* A FAIRE */
  /***********/
  return( 1 ) ; /* valeur arbitraire ici */
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
