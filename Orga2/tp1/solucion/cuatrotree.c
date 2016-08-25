#include "cuatrotree.h"

void ct_add(ctTree* ct, uint32_t newVal) {
	//agregamos un elemento a un nodo del arbol o creamos un nodo con ese elem
	//faltan func de iter
	ctNode *raiz = ct->root;

	ctNode aRellenar = ct_aux_search(raiz,*null,newVal);

}

//busca un nodo donde agregar el elemento y lo devuelve, si no lo genera, lo conecta y devuelve
		/*
		typedef struct ctNode_t {
		  struct ctNode_t* father;
		  uint32_t value[NODESIZE];
		  uint8_t len;
		  struct ctNode_t* child[NODESIZE+1];
		} __attribute__((__packed__)) ctNode;
	*/
	ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){
		if (&currNode->len!=3) return &currNode;
		for(int i=0;i<3;i++){
			if(&currNode->value[i]>newVal){
				if(&currNode->value[i]!=null){
					ct_aux_search(&currNode->value[i],&currNode,newVal);	
				}else{
					ctNode nuevo = malloc(sizeof(ctNode));
					nuevo->father = currNode;
					nuevo.value[0]=0;
					nuevo.value[1]=0;
					nuevo.value[2]=0;
					nuevo.len =0;
					nuevo.child[0]= null;
					nuevo.child[1]= null;
					nuevo.child[2]= null;
					nuevo.child[3]= null;
					&currNode->value[i] = nuevo;
					return nuevo;
				}
				
			}
			if(&currNode->value[i]<newVal){
				if(&currNode->value[i+1]!=null){
					ct_aux_search(&currNode->value[i+1],&currNode,newVal);
				}else{
					ctNode nuevo = malloc(sizeof(ctNode));
					nuevo->father = currNode;
					nuevo.value[0]=0;
					nuevo.value[1]=0;
					nuevo.value[2]=0;
					nuevo.len =0;
					nuevo.child[0]= null;
					nuevo.child[1]= null;
					nuevo.child[2]= null;
					nuevo.child[3]= null;
					&currNode->value[i+1] = nuevo;
					return nuevo;

				}
			}
		
		}
	}	

	void ct_aux_fill(ctNode* currNode, uint32_t newVal){
		//dado un nodo, agrega ordenadamente el valor haciendo los movimientos necesarios y aumentando el tam del nodo
		for(int i=0;i<2;i++){
			if(currNode.value[i]<newVal){
				for(int j=3;j!=i;j--){
					currNode.value[j-1]=currNode.value[j-2];
					currNode.child[j]=currNode.child[j-1];
				}
				currNode.child[i+1]=currNode.child[i];
				currNode.value[i]=newVal;
			}
			if(currNode.value[i]>newVal){
				for(int j=3;j!=i;j--){
					currNode.value[j-1]=currNode.value[j-2];
					currNode.child[j]=currNode.child[j-1];
				}
				currNode.value[i]=newVal;
			}
		}
	}


/*
		typedef struct ctNode_t {
		  struct ctNode_t* father;
		  uint32_t value[NODESIZE];
		  uint8_t len;
		  struct ctNode_t* child[NODESIZE+1];
		} __attribute__((__packed__)) ctNode;
	*/










