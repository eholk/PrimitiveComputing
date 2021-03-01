;; Prints a number in decimal at the current cursor position.
;;
;; Arguments:
;; ax - number to print
print_number:
;; save all the registers we use
push bp
push ax
push bx
push cx
push dx
push es
mov bp, sp

xor cx, cx
test ax, ax
jz .print_zero
mov bx, 10
.div_loop:
xor dx, dx
div bx  ;; divides dx:ax by bx, stores quotient in ax, remainder in dx
add dx, '0'
mov dh, 7h
push dx ;; Save current digit to the stack
add cx, 1
test ax, ax
jnz .div_loop
jmp .print_stack

.print_zero:
mov dh, 7h
mov dl, '0'
push dx
mov cx, 1

.print_stack:
;; Get cursor position
push cx
mov ah, 3h
xor bx, bx
int 10h
;; now dh, dl has the cursor position
pop cx

;; Print a string with int 10h
mov ax, ss
mov es, ax
mov ax, bp
mov bp, sp
push ax
mov ah, 13h
mov al, 3 ;; 0x1: update cursor after writing, 0x2: two bytes per character in input 
mov bl, 7h
int 10h
pop bp

;; Fix the stack and return
.exit:
mov sp, bp
pop es
pop dx
pop cx
pop bx
pop ax
pop bp
ret
