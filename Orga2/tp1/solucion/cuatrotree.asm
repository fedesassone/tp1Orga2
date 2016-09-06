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
  
section .rodata

format: 			DB '%i', 10
section .text

; Se preservan RBX; R12, R13, R14 y R15
; Entran por, en orden: rdi, rsi, rdx, rcx, r8, r9, pila.

; =====================================
; void ct_new(ctTree** pct);
ct_new:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
			mov rbx, rdi;guardo el **tree
      mov rdi, str_tree_SIZE
			call malloc
			mov r12, rax
			mov qword [r12 + tree_root_OFFSET], null
			mov dword [r12 + tree_size_OFFSET], null
      mov [rbx], r12
		pop r12
		pop rbx
		pop rbp
        ret

; =====================================
; void ct_delete(ctTree** pct);
ct_delete:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
			mov rbx, rdi ; rbx=**tree
			mov r12, [rbx];r12=*tree
			cmp qword [r12+tree_root_OFFSET], null
			je .fin
			mov rdi, [r12 + tree_root_OFFSET];raiz
			call ct_borrarNodo
			.fin:
			mov rdi, r12
			call free
		pop r12
		pop rbx
		pop rbp
        ret

;void ct_borrarNodo(ctNode* nodo);
ct_borrarNodo:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
			mov rbx, rdi
			xor r12, r12
			.prim:
			cmp qword [rbx + nodo_hijo0_OFFSET], null
			je .noPrim
			jmp .borrarPrim
			.noPrim:
			cmp qword [rbx + nodo_hijo1_OFFSET], null
			je .noSeg 
			jmp .borrarSeg
			.noSeg:
			cmp qword [rbx + nodo_hijo2_OFFSET], null
			je .noTer
			jmp .borrarTer
			.noTer:
			cmp qword [rbx + nodo_hijo3_OFFSET], null 	
			je .finSubHijos
			jmp .borrarCuar
			.borrarPrim:
			mov rdi, [rbx + nodo_hijo0_OFFSET]
			call ct_borrarNodo
			jmp .noPrim
			.borrarSeg:
			mov rdi, [rbx + nodo_hijo1_OFFSET]
			call ct_borrarNodo
			jmp .noSeg
			.borrarTer:
			mov rdi, [rbx + nodo_hijo2_OFFSET]
			call ct_borrarNodo
			jmp .noTer
			.borrarCuar:
			mov rdi, [rbx + nodo_hijo3_OFFSET]
			call ct_borrarNodo
			.finSubHijos:
			mov rdi, rbx
			call free


		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

; ; =====================================
; ;void ct_print(ctTree* ct, FILE *pFile);
ct_print:
;rdi = ẗree
;rsi = *pfile
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
			mov rbx, rdi; el puntero a arbol
			mov r12, rsi; el *pfile
			call ctIter_new
			mov r13, rax; el iter nuevo
			mov rdi, r13
			call ctIter_first;tengo en r13 el iter en la primer pos
			.ciclo:
			cmp qword [r13 + iter_node_OFFSET], null
			je .invalido
			mov r14, [r13 + iter_node_OFFSET]
			xor rax, rax
			mov al, [r13 + iter_current_OFFSET]
			lea r14, [r14 + nodo_value0_OFFSET]
			shl rax, 2
			mov edx, [r14 + rax];lo muevo valueSize*current veces
			mov rdi, r12 ; el pFile
			mov rsi, format
			mov rax, 0
			call fprintf
			mov rdi, r13
			call ctIter_next
			jmp .ciclo
			.invalido:
			mov rdi, r13
			call ctIter_delete
		pop r14
		pop r13;
		pop r12
		pop rbx
		pop rbp
        ret
; =====================================
; ctIter* ctIter_new(ctTree* ct);
ctIter_new:
		push rbp
		mov rbp, rsp
		push rbx
		sub rsp, tamanio_ajustar_pila
			mov rbx, rdi
			mov rdi, str_iter_SIZE
			call malloc
			mov [rax + iter_tree_OFFSET], rbx
			mov qword [rax + iter_node_OFFSET], null
			mov byte  [rax + iter_current_OFFSET], 0
			mov dword [rax + iter_count_OFFSET], 0
		add rsp, tamanio_ajustar_pila
		pop rbx
		pop rbp
        ret

; =====================================
; void ctIter_delete(ctIter* ctIt);
ctIter_delete:
		push rbp
		mov rbp, rsp
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
		mov rbp, rsp
		push rbx
		push r12
			mov rbx, rdi ; guardo el iter
			cmp qword [rbx + iter_tree_OFFSET], null
			je .fin
			mov r12, [rbx + iter_tree_OFFSET]; el arbol en r12
			cmp qword [r12 + tree_root_OFFSET], null
			je .fin 
			mov r12, [r12 + tree_root_OFFSET]; rn r12 el nodo raiz del tree
			.cicloBuscoMenor:
			cmp qword [r12 + nodo_hijo0_OFFSET], null
			je .menorNodo
			mov r12,  [r12 + nodo_hijo0_OFFSET]
			jmp .cicloBuscoMenor
			.menorNodo: ; entramos aca si estamos en el nodo de abajo a la izq de todo
			mov [rbx + iter_node_OFFSET], r12 ; el nodo
			mov byte  [rbx + iter_current_OFFSET], 0; el current (es 0 la primer posicion)
			mov dword [rbx + iter_count_OFFSET], 1 ;contador, al posicionar el primero es 1
		.fin:
		pop r12
		pop rbx
		pop rbp
        ret

; =====================================
; void ctIter_next(ctIter* ctIt);
;iter de la forma: |*tree|*nodo actual|byte valorActual|double Count|
ctIter_next:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
			mov rbx, rdi; guardo el iter en rbx
			.chequeoValido:
			xor rax, rax
			xor rdx, rdx
			cmp qword [rbx + iter_node_OFFSET], null
			je .fin 
			mov eax, [rbx + iter_count_OFFSET]
			mov r12, [rbx + iter_tree_OFFSET]
			mov edx, [r12 + tree_size_OFFSET]
			cmp eax, edx
			jge .invalidar
			.incrementoCurr:
			xor rcx, rcx
			mov cl, [rbx + iter_current_OFFSET]
			inc cl
			mov [rbx + iter_current_OFFSET], cl
			mov r13, rcx ;guardo el current
			.chequeoHijosSinRecorrer:
			mov r12, [rbx + iter_node_OFFSET]; el nodo en r12
			lea r14, [r12 + nodo_hijo0_OFFSET]; r14= direcc del array de hijos
			shl r13, 3  ;multiplico cl (current)* 8 (tam de cada pos del array)
			cmp qword [r14 + r13], null ; me fijo si el hijo de current a la derecha es null
			je .noHijosSinRec
			jmp .hijosSinRec
			.noHijosSinRec:
			shr r13, 3 ; current
			xor rcx, rcx
			mov cl, [r12 + nodo_len_OFFSET]
			mov r14, rcx
			cmp r13, r14 ;comparo Current con Len
			jge .calleoUp ; si es mas grande me voy arriba si no estoy en el ultimo
			jmp .aumentoCount
			.calleoUp:
			mov rdi, rbx
			call ctIter_aux_up
			jmp .aumentoCount
			.hijosSinRec:
			mov r14, [r14 + r13]; el hijo de current
			mov [rbx + iter_node_OFFSET], r14
			mov rdi, rbx
			call ctIter_aux_down
			.aumentoCount:
			xor rsi, rsi
			mov esi, [rbx + iter_count_OFFSET]
			inc esi
			mov [rbx + iter_count_OFFSET], esi ;aumento el count en 1
			jmp .fin 
			.invalidar:
			mov qword [rbx + iter_node_OFFSET], null
			.fin:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
        ret

; =====================================
; uint32_t ctIter_get(ctIter* ctIt);
ctIter_get:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
			mov rbx, rdi; iter en rdx
			mov r12, [rbx + iter_node_OFFSET]
			xor rdx, rdx
			mov dl, [rbx + iter_current_OFFSET]
			shl rdx, 2
			lea r12, [r12 + nodo_value0_OFFSET]
			mov eax, [r12 + rdx]
		pop r12
		pop rbx
		pop rbp
        ret

; =====================================
; uint32_t ctIter_valid(ctIter* ctIt);
ctIter_valid:
		push rbp
		mov rbp, rsp
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
		mov rbp, rsp
		push rbx
		push r12
			mov rbx, rdi ; el iter
			mov r12, [rbx + iter_node_OFFSET]; el nodo
			.ciclo:
			cmp qword[r12 + nodo_hijo0_OFFSET], null
			je .llegue
			mov r12, [r12 + nodo_hijo0_OFFSET]
			jmp .ciclo
			.llegue:
			mov qword [rbx + iter_node_OFFSET], r12
			mov byte [rbx + iter_current_OFFSET], 0
		pop r12
		pop rbx
		pop rbp
		ret

; =====================================
;void ctIter_aux_up(ctIter* ctIt);

ctIter_aux_up:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
			mov r14, rdi; guado iter
			.inicio:
			mov r12, [r14 + iter_node_OFFSET];nodo actual
			.soyRaiz?:
			cmp qword [r12 + nodo_padre_OFFSET], null
			je .invalidar
			mov r13, [r12 + nodo_padre_OFFSET];padre actual
			mov bl, [r13 + nodo_len_OFFSET];long de padre
			mov rdi, r12
			mov rsi, r13
			call ctIter_aux_isIn
			cmp al, bl ; veo si son =
			je .sigoSubiendo ;si son iguales, recorrí a todos los elem del nodo
			mov [r14 + iter_node_OFFSET], r13; paso al padre
			mov byte [r14 +iter_current_OFFSET], al
			jmp .fin
			.sigoSubiendo:
			mov [r14 + iter_node_OFFSET], rsi;paso el padre y sigo sub..
			jmp .inicio
			.invalidar:
			mov qword [r14 + iter_node_OFFSET], null
		.fin:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

; =====================================
;uint32_t ctIter_aux_isIn(ctNode* current, ctNode* father);
;rdi = *current
;rsi = *padre
ctIter_aux_isIn:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
			xor r12, r12
			lea rbx,[rsi + nodo_hijo0_OFFSET] ; array de hijos
			.ciclo:
			cmp [rbx], rdi
			je .encontrado
			inc r12
			lea rbx, [rbx + 8]
			jmp .ciclo
			.encontrado:
			xor rax, rax
			mov rax, r12
		pop r12
		pop rbx
		pop rbp
		ret
