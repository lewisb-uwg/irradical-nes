;;; Increase Score
;;; works with variable myScore
;;; works with HUD variable HUD_myScore.
	TXA
	STA tempx
	
	AddValue #$08, myScore, #$01
	
	

	;;; we also need to set up the routine to update the HUD
	;; for this to work right, health must be a "blank-then-draw" type element.
	;STA hudElementTilesToLoad
	;	LDA #$00
	;	STA hudElementTilesMax
		LDA DrawHudBytes
		ora #%01000000 ;#HUD_myScore
		STA DrawHudBytes
	
	LDX tempx