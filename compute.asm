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
