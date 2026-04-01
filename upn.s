.intel_syntax noprefix
.global evaluate_upn_asm
.extern step_dump

.section .text

evaluate_upn_asm:
    push rbp
    mov rbp, rsp

    push rbx
    push r12
    push r13
    push r14
    push r15

    mov rbx, rdi
    mov r12d, esi
    mov r13, rdx

    mov rdx, rsp
    sub rsp, 8200
    mov [rsp], rdx

    lea r15, [rsp + 8]
    lea r14, [r15 + 8192]
    lea rsp, [r15 + 4096]

.parse_loop:
    movzx eax, byte ptr [rbx]
    test al, al
    je .end_of_input

    cmp al, ' '
    je .next_char
    cmp al, 9
    je .next_char
    cmp al, 10
    je .next_char
    cmp al, 13
    je .next_char

    cmp al, '0'
    jb .check_plus
    cmp al, '9'
    ja .check_plus

    cmp rsp, r15
    jbe .reject

    sub rsp, 8
    movzx eax, byte ptr [rbx]
    sub eax, '0'
    mov qword ptr [rsp], rax

    cmp r12d, 1
    jne .next_char
    jmp call_step_dump

.check_plus:
    cmp al, '+'
    je .do_add
    cmp al, '*'
    je .do_mul
    jmp .reject

.do_add:
    lea rax, [r15 + 4096 - 16]
    cmp rsp, rax
    jg .reject

    mov rcx, [rsp]
    add rsp, 8
    mov rax, [rsp]
    add rsp, 8
    add rax, rcx

    cmp rsp, r15
    jbe .reject
    sub rsp, 8
    mov [rsp], rax

    cmp r12d, 1
    jne .next_char
    jmp call_step_dump

.do_mul:
    lea rax, [r15 + 4096 - 16]
    cmp rsp, rax
    jg .reject

    mov rcx, [rsp]
    add rsp, 8
    mov rax, [rsp]
    add rsp, 8
    imul rax, rcx

    cmp rsp, r15
    jbe .reject
    sub rsp, 8
    mov [rsp], rax

    cmp r12d, 1
    jne .next_char
    jmp call_step_dump

call_step_dump:
    xchg rsp, r14

    sub rsp, 8
    lea rdx, [rsp + 8]
    mov [rsp], rdx

    mov rdi, r14
    lea rsi, [r15 + 4096]
    call step_dump

    mov rsp, [rsp]
    xchg rsp, r14
    jmp .next_char

.next_char:
    inc rbx
    jmp .parse_loop

.end_of_input:
    lea rax, [r15 + 4096 - 8]
    cmp rsp, rax
    jne .reject

    mov rax, [rsp]
    mov [r13], rax
    mov eax, 1
    jmp .finish

.reject:
    xor eax, eax

.finish:
    lea rdx, [r15 - 8]
    mov rsp, [rdx]

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
