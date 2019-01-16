#include <stdio.h>
#include <stdlib.h>

#include <ligne_ncurses.h>
#include <voie_unique.h>


/*
 * Affichage d'une ligne
 */
extern void
ligne_wprint( ecran_t * const ecran ,			/* Ecran sur lequel on affiche                */
	      const ligne_t * const ligne ,		/* Section a voie unique a afficher           */
	      const train_id_t nb_total_trains )	/* Nb total de trains circulant sur la ligne  */

{

  pthread_mutex_init(&ecran->mutex_ecran, NULL);
  pthread_mutex_lock(&ecran->mutex_ecran);

  int i ;
  moniteur_voie_unique_id_t nb_sections = ligne->nb ;
  int x_debut = 0;

  // int * x_debut ;
  /*----------*/
  x_debut = 2 ;
  pthread_t tid_ecran[nb_sections];
  struct_print_t * struct_p = NULL;
  // if( ( moniteur = malloc( sizeof(moniteur_voie_unique_t) ) ) == NULL  )

  struct_p = malloc(sizeof(struct_print_t));

  for( i=0 ; i < nb_sections ; i++ )
    {
      struct_p->ecran = ecran;
      struct_p->voie_unique = moniteur_voie_unique_get(ligne->moniteurs[i]);
      struct_p->nb_total_trains = nb_total_trains;
      struct_p->nb_max_trains = moniteur_max_trains_get(ligne->moniteurs[i]);
      struct_p->x_debut = &x_debut;

      pthread_create(&tid_ecran[i], NULL, (void *)voie_unique_wprint, struct_p);
      // voie_unique_wprint( &struct_p ) ;
      // voie_unique_wprint( ecran ,
      //   moniteur_voie_unique_get(ligne->moniteurs[i]) ,
      //   nb_total_trains ,
      //   moniteur_max_trains_get(ligne->moniteurs[i]),
      //   &x_debut ) ;
    }

    // terminaison des fils
    for(i=0 ; i < nb_sections ; i++ )
      pthread_join(tid_ecran[i],NULL);

  /* Rafraichissement ecran */
  wrefresh( ecran_ligne_get(ecran) ) ;

  pthread_mutex_unlock(&ecran->mutex_ecran);
}
