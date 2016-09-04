#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

/** Estructuras **/

#define NODESIZE 3

typedef struct ctTree_t {
  struct ctNode_t* root;
  uint32_t size;
} __attribute__((__packed__)) ctTree;

typedef struct ctNode_t {
  struct ctNode_t* father;
  uint32_t value[NODESIZE];
  uint8_t len;
  struct ctNode_t* child[NODESIZE+1];
} __attribute__((__packed__)) ctNode;

typedef struct ctIter_t {
  ctTree* tree;
  struct ctNode_t* node;
  uint8_t current;
  uint32_t count;
} __attribute__((__packed__)) ctIter;


/** Funciones de CuatroTree **/

void ct_new(ctTree** pct);

void ct_delete(ctTree** pct);

void ct_add(ctTree* ct, uint32_t value);

void ct_print(ctTree* ct, FILE *pFile);

void ct_borrarNodo(ctNode* nodo);

ctNode* ct_nuevoNodo(ctNode* padre);

//auxiliares add

ctNode* ct_aux_search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal);

void ct_aux_fill(ctNode* currNode, uint32_t newVal);


/** Funciones de Iterador de CuatroTree **/

ctIter* ctIter_new(ctTree* ct);

void ctIter_delete(ctIter* ctIt);

void ctIter_first(ctIter* ctIt);

void ctIter_next(ctIter* ctIt);

uint32_t ctIter_get(ctIter* ctIt);

uint32_t ctIter_valid(ctIter* ctIt);

//auxiliares next

void ctIter_aux_down(ctIter* ctIt);

void ctIter_aux_up(ctIter* ctIt);

uint32_t ctIter_aux_isIn(ctNode* current, ctNode* father);
