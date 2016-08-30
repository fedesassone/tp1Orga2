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
  %define str_tree_SIZE 		12
  %define str_iter_SIZE			21
  %define str_node_SIZE			53

  %define tree_root_OFFSET	 	0
  %define tree_size_OFFSET		8
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
			mov rdi, str_tree_SIZE
			xor rax, rax
			call malloc
			mov rdi, rax ; rdi = puntero a memoria para el str_tree_SIZE
			mov qword [rdi + tree_root_OFFSET], null
			mov dword [rdi + tree_size_OFFSET], null
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
			cmp qword [r12+tree_root_OFFSET], null
			je .fin
			mov r9, [r8 + tree_root_OFFSET]

			.fin:
			mov rdi, r8
			call free
		pop rbp
        ret

; ; =====================================
; ;void ct_print(ctTree* ct, FILE *pFile);
  ; tiene que devolver las claves ordenadas:
  ; idea: ir al primero, printear nodo, subir y printear hojas
  ; int fprintf ( FILE * stream, const char * format, ... );
ct_print:
;rdi = ẗree
;rsi = *pfile
		push rbp
		mov rsp, rbp
		push rbx
		push r12
		push r13
		push r14
			mov rbx, rdi; el puntero a arbol 
			mov r12, rsi; el *pfile
			call ctIter_new
			mov r13, rax
			mov rdi, r13
			call ctIter_first
			;tengo en r13 el iter en la primer pos			
			.ciclo:
			mov r14, [r13 + iter_node_OFFSET]
			xor rax, rax
			mov al, [r13 + iter_current_OFFSET]
			mov r14, [r14+nodo_value0_OFFSET]
			shl rax, 2
			mov edx, [r14 + rax];lo muevo valueSize*current veces
			mov rdi, r12 ; el pFile
			;TODO CONSULTAR FORMATO   mov rsi, formato 
			call fprintf
			mov rdi, r13
			call ctIter_next
			;TODO falta chequear si se anula el iter 
			;SI SE ANULA JMP A .fin
			jmp .ciclo
			.fin:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
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
		;tengo en rdi el puntero al iter de la forma: |*tree|*nodo actual|byte valorActual|double Count|
		; tree es de la forma: |nodo* raiz|double tamanio|
		; nodo es: |nodo* padre| double[3] valores | byte longitud | nodo*[4] hijos|
		push rbp
		mov rsp, rbp
		push rbx
		push r12
			cmp qword [rdi + iter_tree_OFFSET], null
			je .fin
			mov rbx, [rdi+ iter_tree_OFFSET]; en rbx el puntero al tree
			cmp qword [rdi + tree_root_OFFSET], null
			je .fin 
			mov r12, [rbx + tree_root_OFFSET]; rn r12 el nodo raiz del tree
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
			mov [rdi + iter_tree_OFFSET], rbx ; el tree 
			mov [rdi + iter_node_OFFSET], r12 ; el nodo
			mov byte  [rdi + iter_current_OFFSET], null; el current (es 0 la primer posicion)
			mov dword [rdi + iter_count_OFFSET], 1 ;contador, al posicionar el primero es 1 
		.fin:
		pop r12
		pop rbx	
		pop rbp
        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
;iter de la forma: |*tree|*nodo actual|byte valorActual|double Count|
;//Consultar como chequear si es el último
ctIter_next:
		push rbp
		mov rsp, rbp
			xor rcx, rcx
			mov cl, [rdi + iter_current_OFFSET]
			inc cl
			mov [rdi + iter_current_OFFSET], cl
			.hijo?:
			mov r9, [rdi + iter_node_OFFSET]; el nodo en r9
			lea r8, [r9 + nodo_hijo0_OFFSET]; r8= direcc del array de hijos
			shl rcx, 3  ;multiplico cl (current)* 8 (tam de cada pos del array)
			cmp qword [r8 + rcx], null ; me fijo si el hijo de current es null
			je .noHijos
			jmp .hijos
			.noHijos:
			shr rcx, 3
			xor rax, rax
			mov al, [r9 + nodo_len_OFFSET]
			dec al
			cmp cl, al
			jg .calleoUp
			jmp .fin
			.calleoUp:
			call ctIter_aux_up
			jmp .fin
			.hijos:
			mov r8, [r8 + rcx]; el hijo de current 
			mov [rdi + iter_node_OFFSET], r8
			call ctIter_aux_down
			.fin:
			mov esi, [rdi + iter_count_OFFSET]
			inc esi
			mov [rdi + iter_count_OFFSET], esi ;aumento el count en 1
		pop rbp
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

; =====================================Auxiliares ctIter_next
;void ctIter_aux_down(ctIter* ctIt);
ctIter_aux_down:
		push rbp
		mov rsp, rbp
			mov r8, [rdi + iter_node_OFFSET]
			.ciclo:
			cmp qword[r8 + nodo_hijo0_OFFSET], null
			je .llegue
			mov r8, [r8 + nodo_hijo0_OFFSET]
			jmp .ciclo
			.llegue:
			mov qword [rdi + iter_node_OFFSET], r8
			mov byte [rdi + iter_current_OFFSET], 0
		pop rbp
		ret

; =====================================
;void ctIter_aux_up(ctIter* ctIt);

ctIter_aux_up:
		push rbp
		mov rsp, rbp
		push r12
		push r13
			mov r12, rdi; guado iter
			.inicio:
			mov rdi, [r12 + iter_node_OFFSET];nodo actual
			mov rsi, [rdi + nodo_padre_OFFSET];padre actual
			mov dl, [rsi + nodo_len_OFFSET];long de padre 
			inc dl ; long del nodo+1
			call ctIter_aux_isIn
			cmp al, dl ; veo si son =
			jne .sigoSubiendo ;es el ultimo  //Consultar si se hace así 
			mov [r12 + iter_node_OFFSET], rsi; paso al padre 
			jmp .fin
			.sigoSubiendo:
			mov [r12 + iter_node_OFFSET], rsi;paso el padre y sigo sub..
			jmp .inicio
		.fin:	
		pop r13
		pop r12
		pop rbp
		ret

; =====================================
;uint32_t ctIter_aux_isIn(ctNode* current, ctNode* father);
;rdi = *current
;rsi = *padre 
ctIter_aux_isIn:
		push rbp
		mov rsp, rbp
		;rdi = nodo actual
		;rsi = padre
		xor rcx, rcx
		lea r8,[rsi+nodo_hijo0_OFFSET]
		.ciclo:
		cmp [r8], rdi
		je .encontrado
		inc ecx
		lea r8, [r8 + 8]
		jmp .ciclo
		.encontrado:
		xor rax, rax
		mov eax, ecx
		pop rbp
		ret







