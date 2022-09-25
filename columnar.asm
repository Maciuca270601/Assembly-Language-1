section .data
    extern len_cheie, len_haystack
    key_index dd 0; Stores the index of the key
    counter dd 0; Stores a counter to determine an index

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE

    mov ecx, 0
key:
; Storing key[key_index] in edx
    mov edx, dword[edi + 4 * ecx]
    mov eax, edx
for:
    ; Searching all elements from haystack from column key[key_index]
    xor ecx, ecx
    mov cl, byte[esi + eax]
    mov edi, dword[counter]
    mov byte[ebx + edi], cl
    inc edi
    mov dword[counter], edi

    mov edi, dword[len_cheie]
    add eax, edi
    mov edi, [ebp + 8]
    cmp eax, dword[len_haystack]
    jl for

    ; Iterate through all key_indexes from key
    mov ecx, dword[key_index]
    inc ecx
    mov dword[key_index], ecx
    cmp ecx, dword[len_cheie]
    jl key

    ; Reset key_index and counter
    mov ecx, 0
    mov dword[key_index], ecx
    mov dword[counter], ecx
    

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY