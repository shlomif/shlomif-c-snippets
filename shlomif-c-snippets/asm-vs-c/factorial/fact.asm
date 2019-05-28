extern  printf
extern  malloc
extern  free
extern  puts
global main

    section .text
main:
    mov ecx, [esp+8]  ; argv
    push ebp      ; STORE ebp
    mov ebp, esp  ; STORE esp safely in ebp
    sub esp, 16        ; make space for some values:
        ; ebp-4 - n ( eax )
        ; ebp-8 - len ( ebx )
        ; ebp-12 - digit_idx ( edx )
        ; ebp-16 - result ( edi )
top:
    xor eax, eax ; eax = 0
    xor ebx, ebx ; ebx = 0
    mov edi, 10
    add ecx, 4  ; argv[1]
    mov ecx, [ecx] ; &argv[1][0]
calc_n_loop_start:
    mov bl, byte [ecx] ; bl = *edx
    cmp bl, 0
    je eax_is_now_n ; if bl == 0 goto eax_is_now_n
    sub bl, '0'
    mul edi
    add eax, ebx
    add ecx, 1
    jmp calc_n_loop_start

eax_is_now_n:

n_loop_start:

    ; eax is n.


    mov ebx, eax ;
    add ebx, 1
    shl ebx, 2
    ; ebx = (eax+1) * sizeof(int)

    mov dword [ebp-4], eax ; STORE eax

    push ebx   ; FArg
    call malloc
    mov edi, eax
    add esp, 4   ; FUnarg

    ; Restore the registers
    mov eax, dword [ebp-4] ; RESTORE eax

    ; edi holds result
    ; ebx is len.
    mov ebx, 1          ; len = 1
    mov dword [edi], 1  ; result[0] = 1

i_loop_start:
    mov dword [ebp-4], eax ; STORE eax
    ; ecx is r
    ; edx is digit_idx
    xor ecx, ecx ; r = 0
    xor edx, edx ; digit_idx = 0

digit_idx_loop_start:
    mov dword [ebp-8], ebx ; STORE ebx.
    mov ebx, dword [edi+edx*4] ; ebx = result[digit_idx]
    mov dword [ebp-4], eax  ; STORE eax in the stack
    mov dword [ebp-12], edx ; STORE edx in the stack
    mul ebx      ; edx:eax = ebx * i
    mov ebx, eax ; ebx *= i
    add ecx, ebx   ; r += i*result[digit_idx]
    mov ebx, ecx   ; ebx = r
    mov eax, ebx
    xor edx, edx
    div dword [ten_thousand]
    mov ebx, edx ; ebx = r % 10000
    mov ecx, eax ; r /= 10000
    mov edx, dword [ebp-12]  ; RESTORE edx from the stack
    mov dword [edi+edx*4], ebx
    mov eax, dword [ebp-4]   ; RESTORE eax.

    add edx, 1      ; digit_idx++
    mov ebx, dword [ebp-8] ; RESTORE ebx.
    cmp edx, ebx
    jne digit_idx_loop_start ; while (digit_idx != len)

    mov eax, ecx
while_r_loop:
    cmp eax, 0               ; while (r != 0)
    je after_while_r_loop

    xor edx, edx
    div dword [ten_thousand]            ; edx = r % 10,000 ; r /= 10,000
    mov dword [edi+ebx*4], edx  ; result[len] = r % 10,000
    add ebx, 1 ; len++

    jmp while_r_loop

after_while_r_loop:

    mov eax, dword [ebp-4]   ; RESTORE eax
    dec eax
    cmp eax, 1
    jne i_loop_start

end_of_i_loop:

    ; Now to display the number.

    dec ebx
    mov eax, dword [edi+ebx*4] ; eax = &result[len-1]

    mov dword [ebp-16], edi   ; STORE edi
    mov dword [ebp-8], ebx ; STORE ebx.

    push    eax        ; FArg - the argument string to display
    push    format            ; FArg - the format string
    call    printf
    add    esp, 8            ; FUnarg - remove the two parameters
                        ; FUnarg

printf_loop_start:
    mov ebx, dword [ebp-8] ; RESTORE ebx.

    mov edi, dword [ebp-16]  ; RESTORE edi
    dec ebx
    cmp ebx, -1
    je after_printf_loop

    mov eax, dword [edi+ebx*4] ; eax = &result[len-1]

    mov dword [ebp-16], edi  ; STORE edi
    mov dword [ebp-8], ebx ; STORE ebx.



    push eax          ; FArg
    push format_04    ; FArg
    call printf
    add esp, 8        ; FUnarg
                      ; FUnarg
    jmp printf_loop_start

after_printf_loop:

    mov dword [ebp-16], edi ; STORE edi

    push empty_string  ; FArg
    call puts
    add esp, 4         ; FUnarg

    mov edi, dword [ebp-16]  ; RESTORE edi
    push edi     ; FArg
    call free
    add esp, 4    ; FUnarg

    add esp, 16   ; release the space for the values.
    pop ebp      ; RESTORE ebp
    ret
format:
    db '%d', 0
format_04:
    db '%04d'
empty_string:
    db 0

ten_thousand: dd 10000
