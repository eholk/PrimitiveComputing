ORG 0x7C00

mov ax, cs
mov ds, ax

begin_game:

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
je player_2_point
;; if (ball_x == 21 || ball_x == 19) && ball_y >= p1_pos && ball_y < p1_pos + 50
cmp [ball_x], word 21
je .check_vertical_bounds_p1
cmp [ball_x], word 19
je .check_vertical_bounds_p1
jmp .check_paddle2
.check_vertical_bounds_p1:
mov bx, [ball_y]
sub bx, [p1_pos]
jl .check_paddle2
cmp bx, 50
jl .flip_x

.check_paddle2:
;; Check against right paddle
;; if (ball_x == 299 || ball_x == 301) && ball_y >= p2_pos && ball_y < p2_pos + 50
cmp [ball_x], word 299
je .check_vertical_bounds_p2
cmp [ball_x], word 301
je .check_vertical_bounds_p2
jmp .right_wall
.check_vertical_bounds_p2:
mov bx, [ball_y]
sub bx, [p2_pos]
jl .right_wall
cmp bx, 50
jge .right_wall

.flip_x:
imul ax, -1
mov [ball_dx], ax
jmp .top
.right_wall:
cmp [ball_x], word 318
je player_1_point
;imul ax, -1
;mov [ball_dx], ax
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
mov dx, 0x0010
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

player_1_message: db 'Player 1 scores!', 0
player_2_message: db 'Player 2 scores!', 0

player_1_point:
mov si, player_1_message
jmp draw_string

player_2_point:
mov si, player_2_message

draw_string:
xor ax, ax
mov al, 3
int 10h

mov ax, 0xB800
mov ax, es

mov di, 12 * 80

.string_loop:
mov al, [si]
mov ah, 15
jz .exit_loop
mov [es:di], ax
add di, 2
add si, 1
jmp .string_loop
.exit_loop:

mov si, press_any_key
mov di, 14 * 80

.string_loop2:
mov al, [si]
jz .exit_loop2
mov [es:di], al
add di, 2
add si, 1
jmp .string_loop2
.exit_loop2:

;; wait for a keystroke
mov ah, 0
int 16h

mov [ball_x], word 160
mov [ball_y], word 100
jmp begin_game

press_any_key: db 'Press any key to continue', 0

ball_x: dw 160
ball_y: dw 100
ball_dx: dw 1
ball_dy: dw 1

p1_pos: dw 25
p2_pos: dw 75

SECTION .bootsignature start=0x7C00+510
db 0x55, 0xAA