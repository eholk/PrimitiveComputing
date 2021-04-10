%line 1 "match_token.asm"
;; Determines whether the input matches a specific token
;;
;; Arguments:
;; ax - input to match against
;; bx - token to try and match (buffer, length)
;;
;; Returns:
;; ax unchanged if token not matched
;; ax points to end of token in input if matched
match_token:
push si
push cx
push dx
push di
push ax

;; load the length of the token
mov cx, [bx+2]
;; load pointer to token buffer
mov si, [bx]
mov di, ax

.loop:
test cx, cx
jz .found

xor dx, dx
mov dl, [di]
push ax
mov ax, dx
call print_number
mov ax, STR_COLON
call print_string
xor ax, ax
mov al, [si]
call print_number
mov ax, STR_PERIOD
call print_string
pop ax

cmp [si], dl
jne .not_found

add di, 1
add si, 1
sub cx, 1

jmp .loop

.not_found:
pop ax
jmp .exit

.found:
add sp, 2
mov ax, di
add ax, 1

.exit:
pop di
pop dx
pop cx
pop si
ret

STR_COLON: dw .data, 1
.data: db ':'
STR_PERIOD: dw .data, 1
.data: db '.'
