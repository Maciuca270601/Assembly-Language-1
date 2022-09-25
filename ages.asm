; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc


section .data
    ok dd 0; Ok can take two values 0 or 1

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

    ; Swap all_ages and len registry values
    xchg edx, ecx

    ; Ok == 0 => present.year - dates.year
    ; Ok == 1 => present.year - dates.year - 1
    dec ecx
for:
    ; Set ok = 0 for every date initially
    mov ebx, 0
    mov dword[ok], ebx
    
    ; Compare months
    mov ax, [esi + my_date.month]
    mov bx, [edi + 8 * ecx + my_date.month]
    cmp ax, bx
    jl month_lower
    je check_if_month_equal
    jg after_checks

; If lower then set ok = 1 and jump to the algorithm after all the checks
month_lower:
    mov ebx, 1
    mov dword[ok], ebx
    jmp after_checks

; If equal than check days
check_if_month_equal:
    mov ax, [esi + my_date.day]
    mov bx, [edi + 8 * ecx + my_date.day]
    cmp ax, bx
    ; If greater jump to the algorithm after all the checks
    jl day_lower
    jmp after_checks

; If lower then set ok = 1 and jump to the algorithm after all the checks
day_lower:
    mov ebx, 1
    mov dword[ok], ebx
    jmp after_checks

; Check if ok is 1 or 0. If it is 1 then decrement year 
after_checks:
    mov eax, [esi + my_date.year]
    sub eax, [edi + 8 * ecx + my_date.year] 
    mov ebx, dword[ok]
    cmp ebx, 1
    jl dont_decrement
    dec eax

dont_decrement:
    cmp eax, 0
    ; If year is not a positive value, set it to 0
    jg year_is_positive
    mov eax, 0
year_is_positive:
    ; Load year in eax registry
    mov [edx + 4 * ecx], eax
    dec ecx
    cmp ecx, 0
jge for

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
