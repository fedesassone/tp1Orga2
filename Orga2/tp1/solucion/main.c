#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

int main (void){
    char* name = "pruebas.txt";
    FILE *pFile = fopen( name, "a" );
    
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

	ctIter* iter = ctIter_new(*(pArbol));
    ctIter_first(iter);
    //fprintf(stdout, "%i\n",ctIter_get(iter));
    printf("%i\n",ctIter_get(iter));
    //ct_print(*(arbol),pFile);
    ct_delete(pArbol);

    fprintf(pFile,"-\n");
        
    fclose( pFile );
    return 0;    
}