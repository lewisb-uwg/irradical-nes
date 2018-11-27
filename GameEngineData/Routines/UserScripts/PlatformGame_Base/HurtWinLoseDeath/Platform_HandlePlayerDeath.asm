HandlePlayerDeath:
	TXA
	STA tempx
	TYA 
	STA tempy
	
	;;;;;;;;;;;;;;;;;;;
	LDX player1_object
	LDA Object_x_hi,x
	STA temp
	LDA Object_y_hi,x
	STA temp1
	CreateObject temp, temp1, #$08, #$00
	;; need to do this redundantly, otherwise, the death object will be in same slot as player
	LDA #$00
	SEC
	SBC #$06
	STA Object_v_speed_hi,x
	LDX player1_object
	DeactivateCurrentObject
	;;;;;;;;;;;;;;;;;;;
	StopSound
	
	LDA #$FF
	STA player1_object
	
	
	LDX tempx
	LDY tempy
RTS