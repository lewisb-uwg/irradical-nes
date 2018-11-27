LDX player1_object
LDA Object_status,x
AND #%00000100
BEQ +
LDA #$00
SEC
SBC #$06  
STA Object_v_speed_hi,x
LDA Object_status,x
AND #%11111011
STA Object_status,x
ChangeObjectState #$02, #$02
PlaySound #SFX_PLAYER_JUMP
+
RTS