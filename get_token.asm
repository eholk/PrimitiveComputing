token_buffer: dw 0

;; Sets the buffer used for tokenization
;;
;; Arguments:
;; ax - pointer to new buffer
set_token_buffer:
mov [token_buffer], ax
xor ax, ax
ret

;; Returns the next token in the stream
;;
;; -1 for +
;; -2 for *
;;  n for a number
;;
;; Arguments:
;; none
get_token:
push bx
push cx
push dx

mov bx, [token_buffer]
xor ax, ax

.next:
;; Read first character and advance buffer pointer
mov al, [bx]
add bx, 1

;; check for +
cmp al, '+'
jne .check_mul
mov ax, TOKEN_ADD
jmp .exit

.check_mul:
cmp al, '*'
jne .check_if
mov ax, TOKEN_MUL
jmp .exit

.check_if:
push ax
sub bx, 1
mov ax, bx
push bx
mov bx, .IF_TOKEN
call match_token
pop bx
cmp ax, bx
je .check_num
mov bx, ax
mov ax, TOKEN_IF
add sp, 2   ;; drop bx
jmp .exit

.if_buffer: db 'if'
.IF_TOKEN: dw .if_buffer, 2

.check_num:
add bx, 1
pop ax ;; restore the saved ax from check_if
cmp al, '0'
jl .next
cmp al, '9'
jg .next

sub ax, '0'
xor cx, cx

;; Read digits, accumulate into dx
.read_number:
;; read character
mov cl, [bx]
add bx, 1

cmp cl, '0'
jl .return_num
cmp cl, '9'
jg .return_num

sub cl, '0'
mov dx, 10
mul dx
add ax, cx
jmp .read_number

.return_num:
sub bx, 1

.exit:
mov [token_buffer], bx
pop dx
pop cx
pop bx
ret
