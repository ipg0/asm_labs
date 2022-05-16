%include "../lib64.asm"

section .data
  submitValuesMsg db "Submit values separated by newline:", 0xa
  submitMsgLen equ $ - submitValuesMsg
  resultMsg db "Result: "
  resultMsgLen equ $ - resultMsg

section .bss
  strBuf resb 64
  a resd 1
  d resd 1
  q resd 1

section .text

global _start

_start:

; write message
  mov rax, 1
  mov rdi, 1
  mov rsi, submitValuesMsg
  mov rdx, submitMsgLen
  syscall

; read a
  mov rax, 0
  mov rdi, 0
  mov rsi, strBuf
  mov rdx, 64
  syscall
  call StrToInt64
  mov [a], eax

; read d
  mov rax, 0
  mov rdi, 0
  mov rsi, strBuf
  mov rdx, 64
  syscall
  call StrToInt64
  mov [d], eax

; read q
  mov rax, 0
  mov rdi, 0
  mov rsi, strBuf
  mov rdx, 64
  syscall
  call StrToInt64
  mov [q], eax

; write result message before calculations
  mov rax, 1
  mov rdi, 1
  mov rsi, resultMsg
  mov rdx, resultMsgLen
  syscall

; calculate
  mov eax, [q]
  imul eax
  mov ebx, 3
  idiv ebx
  add eax, 5
  mov ebx, eax
  mov eax, [a]
  imul dword [d]
  sub ebx, eax
  mov eax, ebx
  mov rsi, strBuf
  call IntToStr64

; output
  mov rdx, rax
  mov rax, 1
  mov rdi, 1
  syscall

; exit
  mov rax, 0x3c
  mov rdx, 0
  syscall
