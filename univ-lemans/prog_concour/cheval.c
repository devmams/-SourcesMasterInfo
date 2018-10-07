/* Nom : DIALLO MAMADOU */

#include <stdio.h>
#include <stdlib.h>
#include <sys/msg.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>
#include <commun.h>
#include <liste.h>
#include <piste.h>

int
main( int nb_arg , char * tab_arg[] )
{
  int shmid_piste;
  int shmid_liste;
  int cle_piste ;
  piste_t * piste = NULL;

  int cle_liste ;
  liste_t * liste = NULL;

  int sem_piste;
  struct sembuf op_P = { 0 , -1 , SEM_UNDO };
  struct sembuf op_V = { 0 , +1 , SEM_UNDO };


  // char marque;
  char marque;

  booleen_t fini = FAUX ;
  piste_id_t deplacement = 0 ;
  piste_id_t depart = 0 ;
  piste_id_t arrivee = 0 ;


  cell_t cell_cheval ;
  elem_t elem_cheval ;

  if( nb_arg != 4 )
    {
      fprintf( stderr, "usage : %s <cle de piste> <cle de liste> <marque>\n" , tab_arg[0] );
      exit(-1);
    }

  if( sscanf( tab_arg[1] , "%d" , &cle_piste) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise cle de piste (%s)\n" ,
	       tab_arg[0]  , tab_arg[1] );
      exit(-2);
    }


  if( sscanf( tab_arg[2] , "%d" , &cle_liste) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise cle de liste (%s)\n" ,
	       tab_arg[0]  , tab_arg[2] );
      exit(-2);
    }

  if( sscanf( tab_arg[3] , "%c" , &marque) != 1 )
    {
      fprintf( stderr, "%s : erreur , mauvaise marque de cheval (%s)\n" ,
	       tab_arg[0]  , tab_arg[3] );
      exit(-2);
    }

    /*------- Piste -----------------*/
    if((shmid_piste = shmget(cle_piste, sizeof(piste_t), IPC_CREAT | 0666)) == -1){
      perror("Pb sur shmget");
      exit(-3);
    }
    if((piste = shmat(shmid_piste,NULL,0)) == (piste_t *)-1){
      perror("Pb shmat");
      exit(-4);
    }

    /*------- Sem Piste -------------*/

    // Creation des semaphores
    if( ( sem_piste = semget( cle_piste , PISTE_LONGUEUR , IPC_CREAT | 0666 )) == -1 ){
      perror("Pb semget");
      return(-1);
    }
    // Initialisation des semaphores à 1
    unsigned short tab_sem[PISTE_LONGUEUR];
    for(int i=0; i<PISTE_LONGUEUR; i++) tab_sem[i] = 1;
    if( semctl( sem_piste , PISTE_LONGUEUR , SETALL , tab_sem ) == -1 ){
        perror("Pb semctl SETALL");
        return(-1);
    }

    /*------- Liste -----------------*/
    if((shmid_liste = shmget(cle_liste, sizeof(liste_t), IPC_CREAT | 0666)) == -1){
      perror("Pb sur shmget");
      exit(-3);
    }
    if((liste = shmat(shmid_liste,NULL,0)) == (liste_t *)-1){
      perror("Pb shmat");
      exit(-4);
    }

  /* Init de l'attente */
  commun_initialiser_attentes() ;

  /* Init de la cellule du cheval pour faire la course */
  cell_pid_affecter( &cell_cheval  , getpid());
  cell_marque_affecter( &cell_cheval , marque );

  /* Init de l'element du cheval pour l'enregistrement */
  elem_cell_affecter(&elem_cheval , cell_cheval ) ;
  elem_etat_affecter(&elem_cheval , EN_COURSE ) ;
  elem_sem_creer(&elem_cheval);

  /*
   * Enregistrement du cheval dans la liste
   */
  liste_elem_ajouter(liste,elem_cheval);


  while( ! fini )
    {
      /* Attente entre 2 coup de de */
      commun_attendre_tour() ;

      /*
       * Verif si pas decanille
       */
      if(!elem_decanille(elem_cheval)){

      /*
       * Avancee sur la piste
       */

      /* Coup de de */
      deplacement = commun_coup_de_de() ;
#ifdef _DEBUG_
      printf(" Lancement du De --> %d\n", deplacement );
#endif

      arrivee = depart+deplacement ;
      if( arrivee > PISTE_LONGUEUR-1 )
	{
	  arrivee = PISTE_LONGUEUR-1 ;
	  fini = VRAI ;
	}

      if( depart != arrivee )
	{

	  /*
	   * Si case d'arrivee occupee alors on decanille le cheval existant
	   */
     if(piste_cell_occupee(piste,arrivee)){
       booleen_t ok = FAUX ;
       int ind_elem = -1;
       cell_t cell_rech;
       piste_cell_lire(piste,arrivee,&cell_rech);
       while( ! ok ){ // Recherche de l'element à decaniller dans la liste
         ind_elem++;
         if(cell_marque_lire(elem_cell_lire(liste_elem_lire(liste,ind_elem))) == cell_marque_lire(cell_rech)){
           ok = VRAI;
         }
       }
       elem_t e = liste_elem_lire(liste,ind_elem);
       elem_sem_verrouiller(&e);
       liste_elem_decaniller(liste,ind_elem);
       kill(cell_pid_lire(elem_cell_lire(e)),SIGKILL); //arret du processus ducheval decanille
       liste_elem_supprimer(liste,ind_elem);
       elem_sem_deverrouiller(&e);
     }

	  /*
	   * Deplacement: effacement case de depart, affectation case d'arrivee
	   */

     op_P.sem_num = depart;
     op_V.sem_num = depart;
     if( semop(  sem_piste , &op_P , 1 ) == -1 ){
       perror("elem_sem_verrouiller: Pb semop " );
       return(-1);
     }
     piste_cell_effacer(piste,depart);
     commun_attendre_fin_saut() ;
     piste_cell_affecter(piste,arrivee,cell_cheval);
     if( semop(  sem_piste , &op_V , 1 ) == -1 ){
       perror("elem_sem_verrouiller: Pb semop " );
       return(-1);
     }

#ifdef _DEBUG_
	  printf("Deplacement du cheval \"%c\" de %d a %d\n",
		 marque, depart, arrivee );
#endif


	}
      /* Affichage de la piste  */
      piste_afficher_lig( piste );

      depart = arrivee ;

    }
  } //end_while
    piste_cell_effacer( piste , arrivee) ;
  printf( "Le cheval \"%c\" A FRANCHIT LA LIGNE D ARRIVEE\n" , marque );


  /*
   * Suppression du cheval de la liste
   */
   int ind_suppr;
   if(liste_elem_rechercher(&ind_suppr,liste,elem_cheval)){
     liste_elem_supprimer(liste,ind_suppr);
   }

  elem_sem_detruire(&elem_cheval);
  exit(0);
}
