#include "cuatrotree.h"
//agregar funcionando de diez
void ct_add(ctTree* ct, uint32_t newVal) {
	if(ct->root == NULL){
		ctNode *nuevo = ct_nuevoNodo(NULL);
		nuevo->value[0]= newVal;
		nuevo->len++;
		ct->root = nuevo;
		ct->size++;
		return;
	}
	ctNode *raiz = ct->root;
	ctNode *aRellenar = ct_aux_search(&raiz,NULL,newVal);
	if(aRellenar == NULL)return;
	ct_aux_fill(aRellenar, newVal);
	ct->size++;
}

ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){
	ctNode* actual = (*currNode);
	if(actual->value[0] == newVal || actual->value[1] == newVal || actual->value[2] == newVal) return NULL;
	if (actual->len<3) return actual;
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
		if(currNode->value[0]>newVal){
			currNode->value[1]=currNode->value[0];
			currNode->value[0]=newVal;
			currNode->len++;
			return;
		}
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
		if(currNode->value[0]<newVal && currNode->value[1]>newVal){
			currNode->value[2]=currNode->value[1];
			currNode->value[1]=newVal;
			currNode->len++;
			return;	
		}
	}
}

ctNode* ct_nuevoNodo(ctNode* padre){
	ctNode *nuevo = malloc(sizeof(ctNode));
	nuevo->father = padre;
	nuevo->value[0]=-1;
	nuevo->value[1]=-1;
	nuevo->value[2]=-1;
	nuevo->len =0;
	nuevo->child[0]= NULL;
	nuevo->child[1]= NULL;
	nuevo->child[2]= NULL;
	nuevo->child[3]= NULL;
	return nuevo;
}
