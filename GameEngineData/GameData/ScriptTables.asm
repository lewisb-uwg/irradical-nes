;; *************** ScriptTables.asm ***************
;; Script link export. Thursday, November 29, 2018 1:34:14 PM
ScriptAddressLo:
	.db #<Script00, #<Script01, #<Script02, #<Script03, #<Script04, #<Script05, #<Script06, #<Script07, #<Script08, #<Script09
ScriptAddressHi:
	.db #>Script00, #>Script01, #>Script02, #>Script03, #>Script04, #>Script05, #>Script06, #>Script07, #>Script08, #>Script09

TargetScriptBank:
	.db #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1

;;=======================PRESSED=======================
DefinedInputs_Pressed:
	.db #%10000000, #%00000000, #%01000000, #%00010000, #%00100000

DefinedScriptGameStates_Pressed:
	.db #GS_MainGame, #GS_MainGame, #GS_MainGame, #GS_MainGame, #GS_MainGame

DefinedTargetObjects_Pressed:
	.db #$00, #$00, #$00, #$00, #$00

TargetState_Pressed:
	.db #$00, #$00, #$00, #$00, #$00

DefinedTargetScripts_Pressed:
	.db #$04, #$00, #$03, #$05, #$02

;;=======================RELEASE=======================
DefinedInputs_Released:
	.db #%10000000, #%01000000, #%00010000, #%00100000

DefinedScriptGameStates_Released:
	.db #GS_MainGame, #GS_MainGame, #GS_MainGame, #GS_MainGame

DefinedTargetObjects_Released:
	.db #$00, #$00, #$00, #$00

TargetState_Released:
	.db #$00, #$00, #$00, #$00

DefinedTargetScripts_Released:
	.db #$08, #$07, #$09, #$06

;;=======================HOLD=======================
DefinedInputs_Held:
	.db #%10000000, #%01000000, #%00010000, #%00100000

DefinedScriptGameStates_Held:
	.db #GS_MainGame, #GS_MainGame, #GS_MainGame, #GS_MainGame

DefinedTargetObjects_Held:
	.db #$00, #$00, #$00, #$00

TargetState_Held:
	.db #$00, #$00, #$00, #$00

DefinedTargetScripts_Held:
	.db #$04, #$03, #$05, #$02

