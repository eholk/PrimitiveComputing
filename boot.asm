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
mov al, 2   ;; number of sectors to read
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
TOKEN_IF  equ -3

;; Main program
SECTION .main vstart=0x8000

jmp beginning

test_token1: db '1', 0          ;; 1
test_token1_len: equ $ - test_token1
test_token2: db '42'            ;; 42
test_token2_len: equ $ - test_token2
test_token3: db '     123'      ;; 123
test_token3_len: equ $ - test_token3
test_case1: db '+ 1 2'          ;; 3
test_case1_len: equ $ - test_case1
test_case2: db '* 2 3'          ;; 6
test_case2_len: equ $ - test_case2
test_case3: db '+ 12 34'        ;; 46
test_case3_len: equ $ - test_case3
test_case4: db '* + 1 2 + 3 4 '  ;; 21
test_case4_len: equ $ - test_case4
test_case5: db 'if 0 1 2 '       ;; 1
test_case5_len: equ $ - test_case5
test_case6: db 'if 3 1 2 '       ;; 2
test_case6_len: equ $ - test_case6

;; String representation (fat pointers)
;;
;; (16 bits: pointer to buffer, 16 bits: length)

;; Test case representation
;;
;; (input expression as string, expected value as 16 bit int)
all_tests:
dw test_token1, test_token1_len, 1
dw test_token2, test_token2_len, 42
dw test_token3, test_token3_len, 123
dw test_case1, test_case1_len, 3
dw test_case2, test_case2_len, 6
dw test_case3, test_case3_len, 46
dw test_case4, test_case4_len, 21
dw test_case5, test_case5_len, 1
dw test_case6, test_case6_len, 2
dw 0 ;; end

beginning:

;; for each test case case:
;;   print test case
;;   evaluate
;;   print if successful

mov di, all_tests
mov ax, ds 
mov es, ax

test_loop:
mov bp, [di]
test bp, bp
jz empty_loop

mov ax, begin_test_string
call print_string
mov ax, di
call print_string
mov ax, end_test_string
call print_string


mov ax, [di]
call set_token_buffer
call compute
call print_number
cmp ax, [di+4] ;; compare result with expected answer
je .continue

mov ax, failure_string
call print_string

;; advance to next test case
.continue:
add di, 6
jmp test_loop

begin_test_string_data: db 10, 13, 'Test: `'
begin_Test_string_len: equ $ - begin_test_string_data
begin_test_string: dw begin_test_string_data, begin_Test_string_len
end_test_string_data: db '` => '
end_test_string_len: equ $ - end_test_string_data
end_test_string: dw end_test_string_data, end_test_string_len        
failure_string_data: db 10, 13, '  FAIL'
failure_string_len: equ $ - failure_string_data
failure_string: dw failure_string_data, failure_string_len

empty_loop:
jmp empty_loop

%include "print_number.asm"
%include "get_token.asm"
%include "compute.asm"
%include "print_string.asm"
%include "match_token.asm"
