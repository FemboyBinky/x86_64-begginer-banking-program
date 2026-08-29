global _start

section .data


    newline db 10

    bal dd 1000  ;balance



;DEFINE STRINGS

prompt: db "Enter Something: ", 10
prompt_len: equ $ - prompt

invalid: db "Invalid option", 10
invalid_len: equ $ - invalid

balance: db "balance", 10
balance_len: equ $ - balance

deposit: db "deposit", 10
deposit_len: equ $ - deposit

withdraw: db "withdraw", 10
withdraw_len: equ $ - withdraw

exit: db "exit", 10
exit_len: equ $ - exit

dep: db "Enter The Amount To Deposit", 10
dep_len: equ $ - dep

with: db "Enter the amount you want to withdraw", 10
with_len: equ $ - with

_done: db "Done!", 10
_done_len: equ $ - _done

section .bss

    buf resb 4096 ; USER CHOICE
    buf1 resb 4096 ; DEPOSIT
    buf2 resb 4096 ; WITHDRAW
    buffer resb 11 ;BALANCE
    result resd 1


section .text

_start:

; User input
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buf ;stores users option
    mov rdx, 4096
    syscall

;--Checks user input and jumps if theres a match---
balance1: ;check balance

        mov bx, [balance]
        mov ax, [buf]

        xor ax, bx
        jz check_balane
        jnz deposit1

deposit1: ;deposit

       mov ax, [buf]
       mov bx, [deposit]
       xor ax, bx

       jz depost
       jnz withdraw1

withdraw1: ;withdraw

      mov ax, [buf]
      mov bx, [withdraw]
      xor ax, bx
      jz withdrw
      jnz end_program1

end_program1: ;end program

     mov ax, [buf]
     mov bx, [exit]
     xor ax, bx
     jz end_program
     jnz invlid


invlid: ;Invalid option check

        mov rax, 1
        mov rdi, 1
        mov rsi, invalid
        mov rdx, invalid_len
        syscall



        jmp _start


; ATM options

check_balane:

   mov eax, [bal]
   mov ebx, 10
   xor ecx, ecx
   lea rdi, [buffer + 10]


convert: ; convert int to ascii

    xor edx, edx ;restore edx to 0 for division
    div ebx
    add dl, '0' ;convert digit to ascii
    mov [rdi], dl ;store it into the buffer
    dec rdi
    inc ecx
    test eax, eax ;check if theres anything left to divide
    jnz convert

    inc rdi


    mov rax, 1 ;print balance
    mov rsi, rdi
    mov rdx, rcx
    mov rdi, 1  ;overwrites rdi
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline ;print new line
    mov rdx, 1
    syscall

    jmp _start


depost: ;deposit money

    mov rax, 1
    mov rdi, 1
    mov rsi, dep
    mov rdx, dep_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buf1
    mov rdx, 4096
    syscall

    mov rdi, buf1
    call atoi
    add [bal], eax

    mov rax, 1
    mov rdi, 1
    mov rsi, _done
    mov rdx, _done_len
    syscall


jmp _start


withdrw: ;withdraw


    mov rax, 1
    mov rdi, 1
    mov rsi, with ;prints "Enter the amount you want to withdraw"
    mov rdx, with_len
    syscall


    mov rax, 0
    mov rdi, 0
    mov rsi, buf2 ;stores it buf2
    mov rdx, 4096
    syscall


    mov rdi, buf2   ;move buf2 into rdi then convert to int and subtract from balance
    call atoi
    sub [bal], eax


    mov rax, 1
    mov rdi, 1
    mov rsi, _done
    mov rdx, _done_len
    syscall


    jmp _start




;ATOI
atoi:

    xor eax, eax  ;restore eax to 0


.loop:

    movzx ecx, byte [rdi]  ;load charcter
    cmp ecx, '0'  ;bellow 0 stop
    jl done
    cmp ecx, '9' ;above 0 stop
    jg done

    imul eax, eax, 10 ;shift total left one decimal
    sub ecx, '0' ;convert ascii to its numeric value
    add eax, ecx ;add a new digit

    inc rdi
    jmp .loop

done:
   ret

end_program:
    mov eax, 60      ; sys_exit
    xor edi, edi     ; status = 0
    syscall
