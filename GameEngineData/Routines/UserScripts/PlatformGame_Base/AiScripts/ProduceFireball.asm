;;; null
TXA
STA tempx
LDA Object_x_hi,x
STA temp
LDA Object_y_hi,x
STA temp1
CreateObject temp, temp1, #$0A, #$00 ;; fireball
LDA #$00
SEC
SBC #$08
STA Object_v_speed_hi,x
LDX tempx

RTS