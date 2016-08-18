; FUNCIONES de C
  extern malloc
  extern free
  extern fprintf
   
; FUNCIONES
  global ct_new
  global ct_delete
  global ct_print
  global ctIter_new
  global ctIter_delete
  global ctIter_first
  global ctIter_next
  global ctIter_get
  global ctIter_valid

; DEFINES
  %define null					0
  %define tamanio_ajustar_pila	8

  %define pointer_SIZE 			8
  %define double_int_SIZE		4		
  %define str_arbol_SIZE 		12
  %define str_iter_SIZE			21
  %define str_node_SIZE			53

  %define arbol_root_OFFSET 	0
  %define arbol_size_OFFSET		8
  %define nodo_padre_OFFSET		0
  %define nodo_value0_OFFSET	8
  %define nodo_value1_OFFSET	12
  %define nodo_value2_OFFSET	16
  %define nodo_len_OFFSET		20
  %define nodo_hijo0_OFFSET		21
  %define nodo_hijo1_OFFSET		29
  %define nodo_hijo2_OFFSET		37
  %define nodo_hijo3_OFFSET		45

  %define iter_tree_OFFSET		0
  %define iter_node_OFFSET		8
  %define iter_current_OFFSET 	16
  %define iter_count_OFFSET		17
  

section .text


; Se preservan RBX; R12, R13, R14 y R15
; Entran por, en orden: rdi, rsi, rdx, rcx, r8, r9, pila.

; =====================================
; void ct_new(ctTree** pct);
ct_new:
		push rbp
		mov rsp, rbp
			mov r9, rdi; **tree
			mov rdi, str_arbol_SIZE
			xor rax, rax
			call malloc
			mov rdi, rax ; rdi = puntero a memoria para el str_arbol_SIZE
			mov qword [rdi + arbol_root_OFFSET], null
			mov dword [rdi + arbol_size_OFFSET], null
			mov r9, rdi
		pop rbp
        ret

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
		push rbp
		mov rsp, rbp
		push rbx
		push r12
		push r13
		push r14
			mov rbx, rdi ; rbx=**tree
			mov r12, [rbx];r12=*tree
			cmp qword [r12+arbol_root_OFFSET], null
			je .fin
			mov r9, [r8 + arbol_root_OFFSET]

			.fin:
			mov rdi, r8
			call free
		pop rbp
        ret

; ; =====================================
; ; void ct_aux_print(ctNode* node);
ct_aux_print:
        ret

; ; =====================================
; ; void ct_print(ctTree* ct);
ct_print:
        ret

; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:
		push rbp
		mov rsp, rbp
		push rbx
		sub rsp, tamanio_ajustar_pila
			xor rbx, rbx
			mov rbx, rdi
			mov rdi, str_iter_SIZE
			xor rax, rax
			call malloc
			mov [rax + iter_tree_OFFSET], rbx
			mov qword [rax + iter_node_OFFSET], null
			mov byte  [rax + iter_current_OFFSET], null
			mov dword [rax + iter_count_OFFSET], null
		add rsp, tamanio_ajustar_pila
		pop rbx	
		pop rbp
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
		push rbp
		mov rsp, rbp
			call free 
		pop rbp
        ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
		;tengo en rdi el puntero al iter de la forma: |*arbol|*nodo actual|byte valorActual|double Count|
		; arbol es de la forma: |nodo* raiz|double tamanio|
		; nodo es: |nodo* padre| double[3] valores | byte longitud | nodo*[4] hijos|
		push rbp
		mov rsp, rbp
		push rbx
		push r12
			cmp qword [rdi + iter_tree_OFFSET], null
			je .fin
			mov rbx, [rdi+ iter_tree_OFFSET]; en rbx el puntero al arbol
			cmp qword [rdi + arbol_root_OFFSET], null
			je .fin 
			mov r12, [rbx + arbol_root_OFFSET]; rn r12 el nodo raiz del arbol
			cmp byte [r12 + nodo_len_OFFSET], null
			je .fin
			.cicloBuscoMenor:
			;xor rsi, rsi
			;mov esi, [r12 + nodo_value0_OFFSET]; tomamos el menor valor
			cmp qword [r12 + nodo_hijo0_OFFSET], null
			je .menorNodo
			mov r12,  [r12 + nodo_hijo0_OFFSET]
			jmp .cicloBuscoMenor
			.menorNodo: ; entramos aca si estamos en el nodo de abajo a la izq de todo
			mov [rdi + iter_tree_OFFSET], rbx ; el arbol 
			mov [rdi + iter_node_OFFSET], r12 ; el nodo
			mov byte  [rdi + iter_current_OFFSET], null; el current 
			mov dword [rdi + iter_count_OFFSET], null ;contador 
		.fin:
		pop r12
		pop rbx	
		pop rbp
        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
        ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
		push rbp
		mov rsp, rbp
			xor rax, rax
			xor rcx, rcx
			mov r8, [rdi + iter_node_OFFSET]
			mov cl, [rdi + iter_current_OFFSET]
			lea r9, [r8 + nodo_value0_OFFSET]
			add r9, rcx
			mov rax, r9
		pop rbp
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
		push rbp
		mov rsp, rbp
			cmp qword [rdi + iter_node_OFFSET], null
			je .notValid
			mov rax, 1
			jmp .fin
			.notValid:
			xor rax, rax
			.fin:
		pop rbp
        ret



