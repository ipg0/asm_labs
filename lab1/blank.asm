section .data
  a db 5
  b db 7
section .bss

section .text

global _start

_start:
  mov ax, [a]
  add ax, [b]
  mov rax, 60
  mov rdi, 0
  syscall
  
