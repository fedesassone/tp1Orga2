#include "cuatrotree.h"

void ct_add(ctTree* ct, uint32_t newVal) {
	ctNode *raiz = ct->root;
	ctNode *aRellenar = ct_aux_search(&raiz,NULL,newVal);
	ct_aux_fill(aRellenar, newVal);
	ct->size++;
}
ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){
	
	if ((*currNode)->len!=3) return (*currNode);
	for(int i=0;i<3;i++){
		if((*currNode)->value[i]>newVal){
			if((*currNode)->value[i]!=0){
				return ct_aux_search(&((*currNode)->child[i]),(*currNode),newVal);	
			}else{
				ctNode *nuevo = malloc(sizeof(ctNode));
				nuevo->father = (*currNode);
				nuevo->value[0]=0;
				nuevo->value[1]=0;
				nuevo->value[2]=0;
				nuevo->len =0;
				nuevo->child[0]= NULL;
				nuevo->child[1]= NULL;
				nuevo->child[2]= NULL;
				nuevo->child[3]= NULL;
				(*currNode)->child[i] = nuevo;
				return nuevo;
			}
			
		}
		if((*currNode)->value[i]<newVal){
			if((*currNode)->value[i+1]!=0){
				return ct_aux_search(&((*currNode)->child[i+1]),(*currNode),newVal);
			}else{
				ctNode *nuevo = malloc(sizeof(ctNode));
				nuevo->father = (*currNode);
				nuevo->value[0]=0;
				nuevo->value[1]=0;
				nuevo->value[2]=0;
				nuevo->len =0;
				nuevo->child[0]= NULL;
				nuevo->child[1]= NULL;
				nuevo->child[2]= NULL;
				nuevo->child[3]= NULL;
				(*currNode)->child[i+1] = nuevo;
				return nuevo;

			}
		}
	
	}
	return NULL;
}	

void ct_aux_fill(ctNode* currNode, uint32_t newVal){
	//dado un nodo, agrega ordenadamente el valor haciendo los movimientos necesarios y aumentando el tam del nodo
	for(int i=0;i<2;i++){
		if(currNode->value[i]<newVal){
			for(int j=3;j!=i;j--){
				currNode->value[j-1]=currNode->value[j-2];
				currNode->child[j]=currNode->child[j-1];
			}
			currNode->child[i+1]=currNode->child[i];
			currNode->value[i]=newVal;
		}
		if(currNode->value[i]>newVal){
			for(int j=3;j!=i;j--){
				currNode->value[j-1]=currNode->value[j-2];
				currNode->child[j]=currNode->child[j-1];
			}
			currNode->value[i]=newVal;
		}
	}
}










