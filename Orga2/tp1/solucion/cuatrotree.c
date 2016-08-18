#include "cuatrotree.h"

void ct_add(ctTree* ct, uint32_t newVal) {
	//agregamos un elemento a un nodo del arbol o creamos un nodo con ese elem
	//faltan func de iter
	//ctNode = ct_aux_search()

}

	ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){
		//busca un nodo donde agregar el elemento y lo devuelve, si no lo genera, lo conecta y devuelve
		/*
		typedef struct ctNode_t {
		  struct ctNode_t* father;
		  uint32_t value[NODESIZE];
		  uint8_t len;
		  struct ctNode_t* child[NODESIZE+1];
		} __attribute__((__packed__)) ctNode;
	*/
	}	

	void ct_aux_fill(ctNode* currNode, uint32_t newVal){
		//dado un nodo, agrega ordenadamente el valor haciendo los movimientos necesarios y aumentando el tam del nodo
		
	}
