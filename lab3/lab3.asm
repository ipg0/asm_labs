%include "../lib64.asm"

section .data
  prompt_a db 'a: '
  prompt_b db 'b: '
  prompt_c db 'c: '
  prompt_len equ $ - prompt_c
  error_msg db 'Error!', 0x0a
  error_len equ $ - error_msg

section .bss
  buffer resb 16
  buffer_len equ $ - buffer
  a resd 1
  b resd 1

section .text

global _start

_start:
  mov rax, 1
  mov rdi, 1
  mov rsi, prompt_a
  mov rdx, prompt_len
  syscall

  mov rax, 0
  mov rdi, 0
  mov rsi, buffer
  mov rdx, buffer_len
  syscall

  mov rsi, buffer
  call StrToInt64
  cmp rbx, 0
  jne error
  mov [a], eax

  mov rax, 1
  mov rdi, 1
  mov rsi, prompt_b
  mov rdx, prompt_len
  syscall

  mov rax, 0
  mov rdi, 0
  mov rsi, buffer
  mov rdx, buffer_len
  syscall

  mov rsi, buffer
  call StrToInt64
  cmp rbx, 0
  jne error
  mov [b], eax

  mov eax, [a]
  imul dword [b]
  cmp eax, 0
  jng case2

case1:
	mov eax, [a]
	add eax, [b]
	mov ebx, [a]
	sub ebx, [b]
	idiv ebx
	jmp output

case2:
	mov ebx, eax
	mov eax, -120
	idiv ebx

output:
	push rax
	
	mov rax, 1
	mov rdi, 1
	mov rsi, prompt_c
	mov rdx, prompt_len
	syscall

	pop rax

	mov rsi, buffer
	call IntToStr64

	mov rdx, rax
	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	syscall

exit:
  mov rax, 0x3c
  xor rdi, rdi
  syscall

error:
  mov rax, 1
  mov rdi, 1
  mov rsi, error_msg
  mov rdx, error_len
  syscall
  jmp exit