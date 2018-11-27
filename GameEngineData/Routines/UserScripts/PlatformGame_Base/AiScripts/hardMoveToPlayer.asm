;; hard moving up and down
	TYA
	Sta tempy
	LDA Object_x_hi,x

	STA temp
	LDA Object_y_hi,x

	STA temp2 ;; why was this temp2
	TXA
	STA tempz ;; store the newly created object's x
	;; shoot at player one - if there are two players, will we randomize somhow?
	LDX player1_object
	LDA Object_x_hi,x
	STA temp1 ;; why was this temp 1?
	LDA Object_y_hi,x
	STA temp3
	LDX tempz ;; restore newly created projectile object.

	JSR MoveTowardsPlayer 
	LDX tempz

	LDA myHvel
	
	STA Object_h_speed_lo,x
	LDA #$00
	STA Object_h_speed_hi,x
	LDA myVvel
	STA Object_v_speed_lo,x
	LDA #$00
	STA Object_v_speed_hi,x
	

	LDY tempy
	
	;JSR MoveTowardsPlayer 
	
	
