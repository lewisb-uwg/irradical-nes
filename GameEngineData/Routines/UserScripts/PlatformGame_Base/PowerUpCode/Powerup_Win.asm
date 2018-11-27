;cpx player1_object
;BNE dontWintGame_idol
	LDA #STATE_WIN_GAME
	STA change_state
	LDA #$01
	STA newScreen
	
dontWintGame_idol
	