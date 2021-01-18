ORG 0x7C00

;; Set video mode
mov ah, 0
mov al, 0x13
int 10h

;; Display memory is at 0xA000 0000
mov ax, 0xA000
mov es, ax

;; Draw a box
;; Draw top line
mov cx, 320
mov di, 0
mov al, 15
rep stosb

;; Draw bottom line
mov cx, 320
mov di, 199 * 320
rep stosb

;; Draw sides
mov di, 319
mov cx, 200
mov ax, 0x0f0f
.loop:
mov [es:di], ax
add di, 320
sub cx, 1
jnz .loop


main_loop:

;; Draw paddles

mov ax, [p1_pos]
imul ax, 320
;; add the horizontal position of the paddle
add ax, 20
mov di, ax
mov [es:di-320], byte 0
;; cx is size of paddle
mov cx, 50
.p1_loop:
mov [es:di], byte 15
add di, 320
sub cx, 1
jnz .p1_loop
mov [es:di], byte 0

;; Draw paddle 2
mov ax, [p2_pos]
imul ax, 320
;; add the horizontal position of the paddle
add ax, 300
mov di, ax
mov [es:di-320], byte 0
;; cx is size of paddle
mov cx, 50
.p2_loop:
mov [es:di], byte 15
add di, 320
sub cx, 1
jnz .p2_loop
mov [es:di], byte 0


;; Draw ball
mov ax, [ball_y]
imul ax, 320
add ax, [ball_x]
mov di, ax

mov [es:di], byte 15

;; Check bounds
;; Check x bounds
mov ax, [ball_dx]
;; left wall
cmp [ball_x], word 1
jne .right_wall
imul ax, -1
mov [ball_dx], ax
jmp .top
.right_wall:
cmp [ball_x], word 318
jne .top
imul ax, -1
mov [ball_dx], ax
.top:
;; Check y bounds
mov ax, [ball_dy]
cmp [ball_y], word 1
jne .bottom
imul ax, -1
mov [ball_dy], ax
jmp .done
.bottom:
cmp [ball_y], word 198
jne .done
imul ax, -1
mov [ball_dy], ax
.done:

;; Check for keystrokes, move paddle
mov ah, 1
int 16h
jz .no_key
;; There was a keystroke, so read the key
mov ah, 0
int 16h
;; al has ASCII code for keystroke
cmp al, 'w'
jne .test_s
sub [p1_pos], word 1
.test_s:
cmp al, 's'
jne .test_i
add [p1_pos], word 1
.test_i:
cmp al, 'i'
jne .test_k
sub [p2_pos], word 1
.test_k:
cmp al, 'k'
jne .no_key
add [p2_pos], word 1

.no_key:

;; Slow things down so we can see it
mov cx, 0xffff
.delay_loop:
mov dx, 0x0040
.delay_loop_inner:
sub dx, 1
jnz .delay_loop_inner
sub cx, 1
jnz .delay_loop

;; erase ball
mov [es:di], byte 0

;; update ball position
mov bx, [ball_dx]
add [ball_x], bx

mov bx, [ball_dy]
add [ball_y], bx


jmp main_loop

ball_x: dw 160
ball_y: dw 100
ball_dx: dw 1
ball_dy: dw 1

p1_pos: dw 25
p2_pos: dw 75

SECTION .bootsignature start=0x7C00+510
db 0x55, 0xAA