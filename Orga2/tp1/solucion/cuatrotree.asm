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
  %define tamanio_0 			0

  %define pointer_SIZE 			8
  %define double_int_SIZE		4		
  %define str_arbol_SIZE 		12
  %define str_iter_SIZE			21
  %define str_node_SIZE			53

  %define arbol_root_OFFSET 	0
  %define arbol_size_OFFSET		8
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
			mov dword [rdi + arbol_size_OFFSET], tamanio_0
			mov r9, rdi
		pop rbp
        ret

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
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
			mov rbx, rdi
			mov rdi, str_iter_SIZE
			xor rax, rax
			call malloc
			mov qword [rax + iter_tree_OFFSET], rbx
			mov qword [rax + iter_node_OFFSET], tamanio_0
			mov byte  [rax + iter_current_OFFSET], tamanio_0
			mov dword [rax + iter_count_OFFSET], tamanio_0

		pop rbp
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
		push rbp
		mov rsp, rbp
			free rdi
		pop rbp
        ret

; =====================================
; void ctIter_first(ctIter* ctIt);
ctIter_first:
        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
ctIter_next:
        ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
        ret



