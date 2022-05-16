%include './lib64.asm'

section .data
    message db "Submit a string, please", 0x0a,
    msg_len equ $ - message
    separator db ", "

section .bss
    input resb 256
    output resb 32

section .text

global _start

_start:
    ; output a message
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, msg_len
    syscall

    ; input a string
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 256
    syscall

    ; iterate over the string
    
    mov al, 0                   ; current letter
    mov dl, 0                   ; currently first letter
    mov rbx, input              ; string pointer
    mov rcx, 0                  ; occurrence counter
    str_iter:
        mov al, [rbx]
        cmp dl, 0
        je redefine_first_letter
        cmp al, ' '
        je drop_first_letter
        cmp al, dl
        je increment
        after_checks:
        inc rbx
        cmp al, 0x0a
        jne str_iter

    ; output last result
    mov rax, rcx
    mov rsi, output
    call IntToStr64
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    ; call exit
    mov rax, 60
    mov rdi, 0
    syscall

redefine_first_letter:
    mov dl, al
    mov rcx, 1
    jmp after_checks

drop_first_letter:
    ; output result
    mov rax, rcx
    mov rsi, output
    call IntToStr64
    mov rdx, rax
    dec rdx             ; disable newline at the end
    mov rax, 1
    mov rdi, 1
    syscall

    ; put a comma
    mov rax, 1
    mov rdi, 1
    mov rdx, 2
    mov rsi, separator
    syscall

    ; dl = 0 is a flag to redefine the word on the next letter
    mov dl, 0
    jmp after_checks

increment:
    inc rcx
    jmp after_checks