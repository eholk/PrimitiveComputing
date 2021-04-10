;; Evaluate prefix arithmetic expression
;;
;; Call set_token_buffer to set the expression to evaluate
;;
;; Arguments:
;; none
compute:
push bx
push dx

call get_token

cmp ax, TOKEN_IF
jne .check_add
call compute  ;; evaluate test
mov bx, ax
call compute  ;; evaluate consequent
push ax
call compute  ;; evaluate alternate

test bx, bx
jz .if_false

;; if is true
pop ax
jmp .exit

.if_false:
add sp, 2
jmp .exit

.check_add:
cmp ax, TOKEN_ADD
jne .check_mul
call compute
mov bx, ax
call compute
add ax, bx
jmp .exit

.check_mul:
cmp ax, TOKEN_MUL
jne .exit ;; fall through and return token as a number
call compute
mov bx, ax
call compute
mul bx

.exit:
pop dx
pop bx
ret
