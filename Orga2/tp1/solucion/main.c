#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
//ejercicio 2
    char* name = "pruebas.txt";
    FILE *pFile = fopen( name, "a" );
//1
    ctTree* arbol = NULL;
    ctTree** pArbol = &(arbol);
    ct_new(pArbol);
//2
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
//3
    ctIter* iter=ctIter_new(arbol);
//4
    ctIter_first(iter);
    for(uint32_t i = 0; i<arbol->size;i++){
	   fprintf(pFile,"%i\n",ctIter_get(iter));
	   ctIter_next(iter);
    }
//5
    ctIter_delete(iter);
//6 
    ct_delete(pArbol);

    fprintf(pFile,"-\n");

    fclose( pFile );
    return 0;
}
