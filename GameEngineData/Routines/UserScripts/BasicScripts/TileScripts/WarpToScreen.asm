
cpx player1_object
BNE dontDoWarp_tile
LDA warpMap
adc #$01
STA temp
GoToScreen warpToScreen, temp

dontDoWarp_tile
