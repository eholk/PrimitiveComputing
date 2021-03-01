;; BEGIN BOOT SECTOR

ORG 0x7C00

mov ah, 3h
xor bx, bx
int 10h
;; now dh, dl has the cursor position

mov ah, 13h
mov al, 1
mov bl, 7h
mov cx, [hello_size]
mov bp, hello
int 10h

mov ah, 2h
mov al, 1
xor ch, ch, ;; cylinder number
mov cl, 2   ;; sector number
xor dx, dx  ;; drive zero and head zero

;; set up destination buffer
mov bx, 0x0800
mov es, bx
xor bx, bx

;; read sector
int 13h

;; TODO: check error

;; jump into loaded code
jmp 0x00008000

loop: jmp loop

hello: db 'Hello from the boot sector!', 13, 10
hello_size: dw $ - hello

SECTION .bootsignature start=0x7C00+510
db 0x55, 0xAA

;; END BOOT SECTOR

;; CONSTANTS:
TOKEN_ADD equ -1
TOKEN_MUL equ -2

;; Main program
SECTION .main vstart=0x8000

jmp beginning

test_token1: db '1', 0             ;; 1
test_token2: db '42', 0            ;; 42
test_token3: db '     123', 0      ;; 123
test_case1: db '+ 1 2', 0          ;; 3
test_case2: db '* 2 3', 0          ;; 6
test_case3: db '+ 12 34', 0        ;; 46
test_case4: db '* + 1 2 + 3 4', 0  ;; 21

beginning:
mov ax, cs
mov ds, ax

mov ax, test_case4
call set_token_buffer
call compute
call print_number

main_loop:
jmp main_loop

%include "print_number.asm"
%include "get_token.asm"
%include "compute.asm"
