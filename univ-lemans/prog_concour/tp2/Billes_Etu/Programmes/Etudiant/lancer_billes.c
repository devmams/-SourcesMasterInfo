/*  Nom : DIALLO
    Prenom : Mamadou
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <ecran.h>
#include <pthread.h>
#include <sys/ipc.h>
#include <sys/types.h>


booleen_t fini = FAUX ;
static void arret( int sig )
{
  static int cpt = 0 ;

  cpt++ ;

  switch( cpt )
    {
    case 1 :
      break ;
    case 2 :
      break ;
    case 3 :
      fini = VRAI ;
      break ;
    default :
      break  ;
    }
  return ;
}

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
aire_t * A  = NULL ;
ecran_t * ecran  = NULL ;
err_t cr = OK ;

char mess[ECRAN_LG_MESS];

static void fonc(bille_t *bille){

  /* Deplacements des billes l'une apres l'autre */
    pthread_mutex_lock(&mutex);
	  /* Deplacement d'une bille */
	  if( ecran_bille_deplacer( ecran , A, bille ) ){
      ecran_message_pause_afficher( ecran , mess ) ;
      ecran_stderr_afficher( ecran ) ;
    }
    pthread_mutex_unlock(&mutex);

	  if( bille_active(bille) ){
      /* Arret sur image de ce mouvement pendant une duree inversement proportionnelle a sa vitesse */
      ecran_bille_temporiser(bille) ;
    }
	  else{
      pthread_mutex_lock(&mutex);
      /* Desintegration de la bille */
      ecran_message_afficher( ecran , mess ) ;
      ecran_bille_desintegrer( ecran , bille ) ;

      /* On enleve cette bille de l'aire */
      if( aire_bille_enlever( A , bille ) ){
		    ecran_message_pause_afficher( ecran , mess ) ;
		    ecran_stderr_afficher( ecran ) ;
		  }
      if( bille_detruire( &bille ) ){
	      ecran_message_pause_afficher( ecran , mess ) ;
	      ecran_stderr_afficher( ecran ) ;
	    }
      pthread_mutex_unlock(&mutex);

    }

} //end_fonc


int
main( int argc , char * argv[] )
{

  signal( SIGINT , arret ) ;

  printf("\n\n\n\t===========Debut %s==========\n\n" , argv[0] );

  if( argc != 4 )
    {
      printf( " Programme de test sur l'affichage de l'aire avec plusieurs billes\n" );
      printf( " usage : %s <Hauteur de l'aire> <Largeur de l'aire> <nb billes>\n" , argv[0] );
      exit(0);
    }

  int Hauteur  = atoi( argv[1] ) ;
  int Largeur  = atoi( argv[2] ) ;
  int NbBilles = atoi( argv[3] ) ;
  printf( " \nTest sur une aire de %dX%d et %d billes\n" , Hauteur , Largeur , NbBilles );

  srand( getpid() ) ;

  /* Creation et affichage de l'aire */
  printf("Creation de l'aire %dX%d\n" , Hauteur , Largeur ) ;
  if( ( A = aire_creer( Hauteur , Largeur ) ) == AIRE_NULL )
    {
      printf("Pb creation aire\n");
      exit(-1) ;
    }

  aire_afficher(A) ;

  /* Creation et affichage de l'ecran */
  if( ( ecran = ecran_creer(A) ) == ECRAN_NULL )
    {
      printf("Pb creation ecran\n");
      exit(-1) ;
    }

  ecran_afficher(  ecran , A )  ;
  ecran_message_afficher( ecran , "Envoyez un signal pour continuer" ) ;
  pause() ;

  /* Creation des billes */
  sprintf( mess , "Creation des %d billes\n" , NbBilles) ;
  ecran_message_pause_afficher( ecran , mess );

  bille_t ** tab_billes = (bille_t **)malloc( sizeof(bille_t *) * NbBilles ) ;
  int b ;
  for( b=0 ; b<NbBilles ; b++ ){
      if( ( tab_billes[b] = bille_creer( direction_random() ,
           rand()%BILLE_VITESSE_MAX ,
           COORD_NULL ,
           '*' ) ) == BILLE_NULL ){
           sprintf( mess , "Pb creation bille bille %d\n" , b );
           ecran_message_pause_afficher( ecran , mess  ) ;
           exit(-1) ;
       }
  }

  /* Positionnements et affichages des billes */
  ecran_message_pause_afficher( ecran , "Positionnements des billes sur l'ecran" ) ;
  for( b=0 ; b<NbBilles ; b++ )
    {
      sprintf( mess , "Pose de la bille %d\n" , b ) ;
      ecran_message_afficher( ecran , mess ) ;
      if( ( cr = ecran_bille_positionner( ecran , A , tab_billes[b] ) ) ){
        sprintf( mess , "Pb lors de la pose de la bille %d" , b ) ;
        ecran_message_pause_afficher( ecran , mess ) ;
        erreur_afficher(cr) ;
        ecran_stderr_afficher(ecran) ;
        exit(-1) ;
      }
    }

    ecran_message_afficher( ecran , "Envoyez un signal pour continuer" ) ;
    pause() ;

    /* Deplacements des billes l'une apres l'autre */
    ecran_message_pause_afficher( ecran , "Test deplacement des billes, (Deplacements jusqu'a un signal)" ) ;

    // Tread

    liste_t * liste_billes = LISTE_NULL ;
    liste_id_t nb_billes = 0 ;
    bille_t * bille = BILLE_NULL ;
    while( ! aire_vide(A) ){
      liste_billes = aire_billes_lire(A) ;
      nb_billes = liste_taille(liste_billes) ;

      sprintf( mess ,  "Nombre de billes detectees dans l'aire : %ld", nb_billes ) ;
      ecran_message_afficher( ecran , mess ) ;
      pthread_attr_t attr;
      pthread_t thread_id[nb_billes];
      pthread_attr_init(&attr);
      pthread_attr_setscope(&attr, PTHREAD_SCOPE_SYSTEM);
      pthread_setconcurrency(nb_billes);
      for( b=0 ; b<nb_billes ; b++ ){
        bille = liste_acceder( liste_billes ,b) ;
        pthread_create(&thread_id[b], &attr, (void *)fonc, bille);
      }
      for(int i=0; i<nb_billes; i++){
        pthread_join(thread_id[i],NULL);
      }
    }

  ecran_message_pause_afficher( ecran , "Arret" ) ;
  ecran_message_pause_afficher( ecran , "Destruction de la structure ecran" ) ;
  ecran_detruire(&ecran)  ;
  printf("\nDestruction aire\n" ) ;
  aire_detruire( &A)  ;
  printf("\n\n\t===========Fin %s==========\n\n" , argv[0] );
  pthread_mutex_destroy(&mutex);
  return(0) ;
}
