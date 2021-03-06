;;; Increase Health code for player.
;;; works with variable myHealth
;;; works with HUD variable HUD_myHealth.
	TXA
	STA tempx
	;;;you may want to test against a MAX HEALTH.
	;;; this could be a static number in which case you could just check against that number
	;;; or it could be a variable you set up which may change as you go through the game.
	LDA #$08
	STA myHealth
	
	LDX player1_object
	STA Object_health,x

	;;; we also need to set up the routine to update the HUD
	;; for this to work right, health must be a "blank-then-draw" type element.
	STA hudElementTilesToLoad
		LDA #$00
		STA hudElementTilesMax
		LDA DrawHudBytes
		ORA #HUD_myHealth
		STA DrawHudBytes
	
	LDX tempx