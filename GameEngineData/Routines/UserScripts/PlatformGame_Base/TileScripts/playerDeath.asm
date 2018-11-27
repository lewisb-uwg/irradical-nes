	CPX player1_object
	BNE isNotPlayerDeath_forTileCollision
	LDA Object_type,x

	JSR HandlePlayerDeath
	JMP donePlayerDeath_forTileCollision
isNotPlayerDeath_forTileCollision
	;;; if monster runs into spike
	DeactivateCurrentObject
	
donePlayerDeath_forTileCollision: