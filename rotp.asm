section .data
    string_length dd 0; Stores the length of the string
section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

    ; Stores the length of the string
    mov dword[string_length], ecx
    mov ecx, 0
for:
    ; plaintext[i]
    mov al, byte[esi + ecx]

    ; Calculate len - i - 1 in edx
    mov edx, dword[string_length]
    sub edx, ecx
    sub edx, 1

    ; key[len - i - 1]
    mov bl, byte[edi + edx]

    ; Store result of plaintext[i] ^ key[len - i - 1] in al
    xor al, bl

    ; Restore ciphertext
    mov edx, [ebp + 8]
    ; Store in ciphertext[i] the value extracted in al registry
    mov byte[edx + ecx], al

    inc ecx
    cmp ecx, dword[string_length]
jl for

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY