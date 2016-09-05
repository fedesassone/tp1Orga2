#include "cuatrotree.h"

void ct_add(ctTree* ct, uint32_t newVal) {
	if(ct->root == NULL){
		ctNode *nuevo = ct_nuevoNodo(NULL);
		nuevo->value[0]= newVal;
		ct->root = nuevo;
		return;
	}
	ctNode *raiz = ct->root;
	ctNode *aRellenar = ct_aux_search(&raiz,NULL,newVal);
	ct_aux_fill(aRellenar, newVal);
	ct->size++;
}

ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){
	ctNode* actual = (*currNode);
	if (actual->len<3) return actual;
	//for(int i=0;i<3;i++){
	if (actual->value[0]>newVal){
		if(actual->child[0]!=NULL)
			return ct_aux_search(&(actual->child[0]),actual,newVal);
		ctNode *nuevo = ct_nuevoNodo(actual);
		actual->child[0]=nuevo;
		return nuevo;
	}
	if(actual->value[0]<newVal && actual->value[1]>newVal){
		if(actual->child[1]!=NULL)
			return ct_aux_search(&(actual->child[1]),actual,newVal);
		ctNode *nuevo = ct_nuevoNodo(actual);
		actual->child[1]=nuevo;
		return nuevo;
	}
	if(actual->value[1]<newVal && actual->value[2]>newVal){
		if(actual->child[2]!=NULL)
			return ct_aux_search(&(actual->child[2]),actual,newVal);
		ctNode *nuevo = ct_nuevoNodo(actual);
		actual->child[2]=nuevo;
		return nuevo;
	}
	if(actual->value[2]<newVal){
		if(actual->child[3]!=NULL)
			return ct_aux_search(&(actual->child[3]),actual,newVal);
		ctNode *nuevo = ct_nuevoNodo(actual);
		actual->child[3]=nuevo;
		return nuevo;
	}
	return NULL;
}

void ct_aux_fill(ctNode* currNode, uint32_t newVal){
	//dado un nodo, agrega ordenadamente el valor haciendo los movimientos necesarios y aumentando el tam del nodo
	if(currNode->len == 0){
		currNode->value[0]=newVal;
		currNode->len++;
		return;
	}
	if(currNode->len ==1){
		if(currNode->value[0]<newVal){
			currNode->value[1]=newVal;
			currNode->len++;
			return;
		}
		currNode->value[1]=currNode->value[0];
		currNode->value[0]=newVal;
		currNode->len++;
		return;
	}
	if(currNode->len==2){
		if(currNode->value[1]<newVal){
			currNode->value[2]=newVal;
			currNode->len++;
			return;
		}
		if(currNode->value[0]>newVal){
			currNode->value[2]=currNode->value[1];
			currNode->value[1]=currNode->value[0];
			currNode->value[0]=newVal;
			currNode->len++;
			return;
		}
		currNode->value[2]=currNode->value[1];
		currNode->value[1]=newVal;
		currNode->len++;
		return;
	}
}

ctNode* ct_nuevoNodo(ctNode* padre){
	ctNode *nuevo = malloc(sizeof(ctNode));
	nuevo->father = padre;
	nuevo->value[0]=0;
	nuevo->value[1]=0;
	nuevo->value[2]=0;
	nuevo->len =0;
	nuevo->child[0]= NULL;
	nuevo->child[1]= NULL;
	nuevo->child[2]= NULL;
	nuevo->child[3]= NULL;
	return nuevo;
}
