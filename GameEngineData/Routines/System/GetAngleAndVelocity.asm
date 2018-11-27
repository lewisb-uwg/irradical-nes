; arg0 = x1 - object/point originating  x
; arg1 = x2 - object/point to move towards x
; arg2 = y1 - object/point originating  y
; arg3 = y2 - object/point to move towards y 


	
	
octant_adjust:
	.db #%00111111
	.db #%00000000
	.db #%11000000
	.db #%11111111
	.db #%01000000
	.db #%01111111
	.db #%10111111
	.db #%10000000
	
	
atan_tab:
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$00,$00,$00
		.db $00,$00,$00,$00,$00,$01,$01,$01
		.db $01,$01,$01,$01,$01,$01,$01,$01
		.db $01,$01,$01,$01,$01,$01,$01,$01
		.db $01,$01,$01,$01,$01,$01,$01,$01
		.db $01,$01,$01,$01,$01,$02,$02,$02
		.db $02,$02,$02,$02,$02,$02,$02,$02
		.db $02,$02,$02,$02,$02,$02,$02,$02
		.db $03,$03,$03,$03,$03,$03,$03,$03
		.db $03,$03,$03,$03,$03,$04,$04,$04
		.db $04,$04,$04,$04,$04,$04,$04,$04
		.db $05,$05,$05,$05,$05,$05,$05,$05
		.db $06,$06,$06,$06,$06,$06,$06,$06
		.db $07,$07,$07,$07,$07,$07,$08,$08
		.db $08,$08,$08,$08,$09,$09,$09,$09
		.db $09,$0a,$0a,$0a,$0a,$0b,$0b,$0b
		.db $0b,$0c,$0c,$0c,$0c,$0d,$0d,$0d
		.db $0d,$0e,$0e,$0e,$0e,$0f,$0f,$0f
		.db $10,$10,$10,$11,$11,$11,$12,$12
		.db $12,$13,$13,$13,$14,$14,$15,$15
		.db $15,$16,$16,$17,$17,$17,$18,$18
		.db $19,$19,$19,$1a,$1a,$1b,$1b,$1c
		.db $1c,$1c,$1d,$1d,$1e,$1e,$1f,$1f


		;;;;;;;; log2(x)*32 ;;;;;;;;

log2_tab:
		.db $00,$00,$20,$32,$40,$4a,$52,$59
		.db $60,$65,$6a,$6e,$72,$76,$79,$7d
		.db $80,$82,$85,$87,$8a,$8c,$8e,$90
		.db $92,$94,$96,$98,$99,$9b,$9d,$9e
		.db $a0,$a1,$a2,$a4,$a5,$a6,$a7,$a9
		.db $aa,$ab,$ac,$ad,$ae,$af,$b0,$b1
		.db $b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9
		.db $b9,$ba,$bb,$bc,$bd,$bd,$be,$bf
		.db $c0,$c0,$c1,$c2,$c2,$c3,$c4,$c4
		.db $c5,$c6,$c6,$c7,$c7,$c8,$c9,$c9
		.db $ca,$ca,$cb,$cc,$cc,$cd,$cd,$ce
		.db $ce,$cf,$cf,$d0,$d0,$d1,$d1,$d2
		.db $d2,$d3,$d3,$d4,$d4,$d5,$d5,$d5
		.db $d6,$d6,$d7,$d7,$d8,$d8,$d9,$d9
		.db $d9,$da,$da,$db,$db,$db,$dc,$dc
		.db $dd,$dd,$dd,$de,$de,$de,$df,$df
		.db $df,$e0,$e0,$e1,$e1,$e1,$e2,$e2
		.db $e2,$e3,$e3,$e3,$e4,$e4,$e4,$e5
		.db $e5,$e5,$e6,$e6,$e6,$e7,$e7,$e7
		.db $e7,$e8,$e8,$e8,$e9,$e9,$e9,$ea
		.db $ea,$ea,$ea,$eb,$eb,$eb,$ec,$ec
		.db $ec,$ec,$ed,$ed,$ed,$ed,$ee,$ee
		.db $ee,$ee,$ef,$ef,$ef,$ef,$f0,$f0
		.db $f0,$f1,$f1,$f1,$f1,$f1,$f2,$f2
		.db $f2,$f2,$f3,$f3,$f3,$f3,$f4,$f4
		.db $f4,$f4,$f5,$f5,$f5,$f5,$f5,$f6
		.db $f6,$f6,$f6,$f7,$f7,$f7,$f7,$f7
		.db $f8,$f8,$f8,$f8,$f9,$f9,$f9,$f9
		.db $f9,$fa,$fa,$fa,$fa,$fa,$fb,$fb
		.db $fb,$fb,$fb,$fc,$fc,$fc,$fc,$fc
		.db $fd,$fd,$fd,$fd,$fd,$fd,$fe,$fe
		.db $fe,$fe,$fe,$ff,$ff,$ff,$ff,$ff	
		
		
		
		
AngleToHVelLo:
		.db #$fe , #$fe , #$fe , #$fe , #$fd , #$fd , #$fd , #$fc , #$fc , #$fb , #$fa , #$f9 , #$f9 , #$f8 , #$f7 , #$f5 , #$f4 , #$f3 , #$f2 , #$f0 , #$ef , #$ee , #$ec , #$ea , #$e9 , #$e7 , #$e5 , #$e3 , #$e1 , #$df , #$dd , #$db , #$d9 , #$d7 , #$d4 , #$d2 , #$d0 , #$cd , #$cb , #$c8 , #$c6 , #$c3 , #$c0 , #$be , #$bb , #$b8 , #$b5 , #$b2 , #$b0 , #$ad , #$aa , #$a7 , #$a4 , #$a1 , #$9e , #$9b , #$98 , #$95 , #$92 , #$8f , #$8b , #$88 , #$85 , #$82 , #$7f , #$7c , #$79 , #$76 , #$73 , #$6f , #$6c , #$69 , #$66 , #$63 , #$60 , #$5d , #$5a , #$57 , #$54 , #$51 , #$4e , #$4c , #$49 , #$46 , #$43 , #$40 , #$3e , #$3b , #$38 , #$36 , #$33 , #$31 , #$2e , #$2c , #$2a , #$27 , #$25 , #$23 , #$21 , #$1f , #$1d , #$1b , #$19 , #$17 , #$15 , #$14 , #$12 , #$10 , #$f , #$e , #$c , #$b , #$a , #$9 , #$7 , #$6 , #$5 , #$5 , #$4 , #$3 , #$2 , #$2 , #$1 , #$1 , #$1 , #$0 , #$0 , #$0 , #$0 , #$0 , #$0 , #$0 , #$1 , #$1 , #$1 , #$2 , #$2 , #$3 , #$4 , #$5 , #$5 , #$6 , #$7 , #$9 , #$a , #$b , #$c , #$e , #$f , #$10 , #$12 , #$14 , #$15 , #$17 , #$19 , #$1b , #$1d , #$1f , #$21 , #$23 , #$25 , #$27 , #$2a , #$2c , #$2e , #$31 , #$33 , #$36 , #$38 , #$3b , #$3e , #$40 , #$43 , #$46 , #$49 , #$4c , #$4e , #$51 , #$54 , #$57 , #$5a , #$5d , #$60 , #$63 , #$66 , #$69 , #$6c , #$6f , #$73 , #$76 , #$79 , #$7c , #$7f , #$82 , #$85 , #$88 , #$8b , #$8f , #$92 , #$95 , #$98 , #$9b , #$9e , #$a1 , #$a4 , #$a7 , #$aa , #$ad , #$b0 , #$b2 , #$b5 , #$b8 , #$bb , #$be , #$c0 , #$c3 , #$c6 , #$c8 , #$cb , #$cd , #$d0 , #$d2 , #$d4 , #$d7 , #$d9 , #$db , #$dd , #$df , #$e1 , #$e3 , #$e5 , #$e7 , #$e9 , #$ea , #$ec , #$ee , #$ef , #$f0 , #$f2 , #$f3 , #$f4 , #$f5 , #$f7 , #$f8 , #$f9 , #$f9 , #$fa , #$fb , #$fc , #$fc , #$fd , #$fd , #$fd , #$fe , #$fe , #$fe

AngleToVVelLo:
		
		.db #$7f , #$7c , #$79 , #$76 , #$73 , #$6f , #$6c , #$69 , #$66 , #$63 , #$60 , #$5d , #$5a , #$57 , #$54 , #$51 , #$4e , #$4c , #$49 , #$46 , #$43 , #$40 , #$3e , #$3b , #$38 , #$36 , #$33 , #$31 , #$2e , #$2c , #$2a , #$27 , #$25 , #$23 , #$21 , #$1f , #$1d , #$1b , #$19 , #$17 , #$15 , #$14 , #$12 , #$10 , #$f , #$e , #$c , #$b , #$a , #$9 , #$7 , #$6 , #$5 , #$5 , #$4 , #$3 , #$2 , #$2 , #$1 , #$1 , #$1 , #$0 , #$0 , #$0 , #$0 , #$0 , #$0 , #$0 , #$1 , #$1 , #$1 , #$2 , #$2 , #$3 , #$4 , #$5 , #$5 , #$6 , #$7 , #$9 , #$a , #$b , #$c , #$e , #$f , #$10 , #$12 , #$14 , #$15 , #$17 , #$19 , #$1b , #$1d , #$1f , #$21 , #$23 , #$25 , #$27 , #$2a , #$2c , #$2e , #$31 , #$33 , #$36 , #$38 , #$3b , #$3e , #$40 , #$43 , #$46 , #$49 , #$4c , #$4e , #$51 , #$54 , #$57 , #$5a , #$5d , #$60 , #$63 , #$66 , #$69 , #$6c , #$6f , #$73 , #$76 , #$79 , #$7c , #$7f , #$82 , #$85 , #$88 , #$8b , #$8f , #$92 , #$95 , #$98 , #$9b , #$9e , #$a1 , #$a4 , #$a7 , #$aa , #$ad , #$b0 , #$b2 , #$b5 , #$b8 , #$bb , #$be , #$c0 , #$c3 , #$c6 , #$c8 , #$cb , #$cd , #$d0 , #$d2 , #$d4 , #$d7 , #$d9 , #$db , #$dd , #$df , #$e1 , #$e3 , #$e5 , #$e7 , #$e9 , #$ea , #$ec , #$ee , #$ef , #$f0 , #$f2 , #$f3 , #$f4 , #$f5 , #$f7 , #$f8 , #$f9 , #$f9 , #$fa , #$fb , #$fc , #$fc , #$fd , #$fd , #$fd , #$fe , #$fe , #$fe , #$fe , #$fe , #$fe , #$fe , #$fd , #$fd , #$fd , #$fc , #$fc , #$fb , #$fa , #$f9 , #$f9 , #$f8 , #$f7 , #$f5 , #$f4 , #$f3 , #$f2 , #$f0 , #$ef , #$ee , #$ec , #$ea , #$e9 , #$e7 , #$e5 , #$e3 , #$e1 , #$df , #$dd , #$db , #$d9 , #$d7 , #$d4 , #$d2 , #$d0 , #$cd , #$cb , #$c8 , #$c6 , #$c3 , #$c0 , #$be , #$bb , #$b8 , #$b5 , #$b2 , #$b0 , #$ad , #$aa , #$a7 , #$a4 , #$a1 , #$9e , #$9b , #$98 , #$95 , #$92 , #$8f , #$8b , #$88 , #$85 , #$82