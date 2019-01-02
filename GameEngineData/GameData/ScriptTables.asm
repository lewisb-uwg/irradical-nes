;; *************** ScriptTables.asm ***************
;; Script link export. Wednesday, January 2, 2019 10:38:30 AM
ScriptAddressLo:
	.db #<Script00, #<Script01, #<Script02, #<Script03, #<Script04, #<Script05, #<Script06, #<Script07, #<Script08, #<Script09
ScriptAddressHi:
	.db #>Script00, #>Script01, #>Script02, #>Script03, #>Script04, #>Script05, #>Script06, #>Script07, #>Script08, #>Script09

TargetScriptBank:
	.db #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1, #DATABANK1

;;=======================PRESSED=======================
DefinedInputs_Pressed:


DefinedScriptGameStates_Pressed:


DefinedTargetObjects_Pressed:


TargetState_Pressed:


DefinedTargetScripts_Pressed:


;;=======================RELEASE=======================
DefinedInputs_Released:
	.db #%10000000

DefinedScriptGameStates_Released:
	.db #GS_MainGame

DefinedTargetObjects_Released:
	.db #$00

TargetState_Released:
	.db #$00

DefinedTargetScripts_Released:
	.db #$02

;;=======================HOLD=======================
DefinedInputs_Held:
	.db #%10000000

DefinedScriptGameStates_Held:
	.db #GS_MainGame

DefinedTargetObjects_Held:
	.db #$00

TargetState_Held:
	.db #$00

DefinedTargetScripts_Held:
	.db #$06

