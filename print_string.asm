;; Prints a string at the current cursor position.
;;
;; Arguments:
;; ax - a pointer to the string (data, len)
print_string:
push ax
push di
push bx
push dx
push bp
push cx
push es

mov di, ax
mov ax, ds
mov es, ax

;; get cursor position
mov ah, 3h
xor bx, bx
int 10h

mov bp, [di] ;; load base
mov cx, [di+2] ;; load size

;; print the string
mov ah, 13h
mov al, 1
mov bl, 7h
int 10h

.exit:
pop es
pop cx
pop bp
pop dx
pop bx
pop di
pop ax
ret