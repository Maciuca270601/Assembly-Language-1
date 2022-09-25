;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS
section .data
    found_tag dd 0; Determine whether a tag was found or not
    to_replace dd 0; Saves the index of the line where I have to store tag and the bytes.
    index dd 0; Determine the index of the line from which I extract the specific byte.

section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE

    ; Swap esi and ecx registry values so I can free ecx as a counter registry
    xchg esi, ecx

    ; Store the index in to_replace
    mov dword[to_replace], edi
    
    ; Solve Offset
    xor edi, edi
    and edx, 0x00000007; Offset = last 3 bits of the address
    mov edi, edx
    
    ; Solve Tag
    mov edx, [ebp + 20]
    shr edx, 3; Delete the offset from the address


    mov ecx, 0
search_tag:
; Compare every tag from tags with my current tag
    cmp dword[ebx], edx
    je found
    jmp not_found

found:
; If the tag was found, set found_tag = 1 and save the index of the line
    mov eax, 1
    mov dword[found_tag], eax
    mov dword[index], ecx
not_found:
; If not found yet, iterate through tags
    add ebx, 4
    add ecx, 1
    cmp ecx, CACHE_LINES
    jl search_tag

    ; found_tag = 1 -> cache_hit / found_tag = 0 -> cache miss
    cmp dword[found_tag], 1
    je cache_hit

    ; CACHE MISS ALGORITHM
    ; Restore tags in ebx
    mov ebx, [ebp + 12]

    ; Check if the first tag is already the one I have been searching for
    mov ecx, 0
    cmp ecx, dword[to_replace]
    ; In this case jump to add_tag, otherwise get to the specific position
    je add_tag

; Get to the specific position
get_to_position:
    add ebx, 4
    add esi, 8
    inc ecx
    cmp ecx, dword[to_replace]
    jl get_to_position

; Add the tag in the tags matrix
add_tag:
    mov [ebx], edx
    shl edx, 3
; Add the bytes in the cache matrix
add_cache:
    xor eax, eax
    mov ecx, 0
for:
    mov al, byte[edx]
    mov byte[esi], al
    inc esi
    inc edx
    inc ecx
    cmp ecx, 8
    jl for

;CACHE HIT ALGORITHM
; If the tag was already in the tags matrix, we have to extract the value from cache
cache_hit:
; Reset the found_tag = 0 for the next test
    mov eax, 0
    mov dword[found_tag], eax
    mov esi, [ebp + 16]
    mov ecx, 0
    cmp ecx, dword[to_replace]
    je get_over_index_cache
get_to_index_cache:
    add esi, 8
    inc ecx
    cmp ecx, dword[index]
    jl get_to_index_cache

get_over_index_cache:
    add esi, edi
    mov ebx, [ebp + 20]
    mov cl, byte[ebx]
    mov eax, [ebp + 8]
    mov byte[eax], cl

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


