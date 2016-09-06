#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
    char* name = "pruebas.txt";
    FILE *pFile = fopen( name, "a" );

    char* mio = "salida.caso.grande.txt";
    FILE *pFile = fopen(miomio, "a");

    char* cat = "Catedra.salida.caso.chico.txt";
    FILE *pFile = fopen(catcat, "a");

    ctTree* arbol = NULL;
    ctTree** pArbol = &(arbol);
    ct_new(pArbol);
    ct_add(*(pArbol),10);
    ct_add(*(pArbol),50);
    ct_add(*(pArbol),30);
    ct_add(*(pArbol),5);
    ct_add(*(pArbol),20);
    ct_add(*(pArbol),40);
    ct_add(*(pArbol),60);
    ct_add(*(pArbol),19);
    ct_add(*(pArbol),39);
    ct_add(*(pArbol),4);

//Prueba print:
 ct_print(arbol,pFile);

//ctIter* iter=ctIter_new(arbol);
//ctIter_next(iter);
//printf("%i\n",arbol->size);
//ctIter* iter = ctIter_new(*(pArbol));
//printf("%i\n",ctIter_valid(iter));
//ctIter_first(iter);
//printf("%i\n",ctIter_valid(iter));

//for(uint32_t i = 0; i<arbol->size;i++){
	//printf("%i\n",ctIter_get(iter));
//	ctIter_next(iter);
	//printf("%i\n",ctIter_valid(iter));	
//}

//printf("%i\n",ctIter_valid(iter));
 // ctIter_delete(iter);

  
    ct_delete(pArbol);

    fprintf(pFile,"-\n");

    fclose( pFile );
    return 0;
}
