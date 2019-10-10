#include <stdio.h>
#include <stdlib.h>
#include <sys/msg.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/sem.h>

#define NB_PHILO 5

// creation semaphores
if( ( sem_piste = semget( 11 , NB_PHILO , IPC_CREAT | 0666 )) == -1 ){
  perror("Pb semget");
  return(-1);
}
// Initialisation semaphores
unsigned short tab_sem[PISTE_LONGUEUR];
for(int i=0; i<PISTE_LONGUEUR; i++) tab_sem[i] = 1;
if( semctl( sem_piste , NB_PHILO , SETALL , tab_sem ) == -1 ){
    perror("Pb semctl SETALL");
    return(-1);
}

int philo(int i){
  
}
