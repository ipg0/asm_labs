section .data
  A dd -30
  B dd 21

section .bss
  X resd 1

section .text

global _start

_start:
  mov eax, [A]
  add eax, 5
  sub eax, [B]
  mov [X], rax
  mov rax, 60
  mov rdi, 0
  syscall
