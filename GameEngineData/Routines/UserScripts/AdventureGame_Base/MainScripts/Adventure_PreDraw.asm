;; sprite pre-draw
;;; this will allow a user to draw sprites
;;; before object sprites are drawn.
;;; keep in mind, there are still only 64 sprites
;;; that can be drawn on a screen, 
;;; and still only 8 per scan line!

;;; you can use DrawSprite macro directly using the following scheme:
;DrawSprite arg0, arg1, arg2, arg3, arg4
	;arg0 = x
	;arg1 = y
	;arg2 = chr table value
	;arg3 = attribute data
	;arg3 = starting ram position
	
;; x and y are the direct positions on the screen in pixels.
;; chr table value is which sprite you'd like to draw from the ppu table.
;; attribute data is a binary number (starts with #%), and here are how the bits work:
	;;; bit 7 - Flip sprite vertically
	;;; bit 6 - Flip sprite horizontally
	;;; bit 5 - priority (0 in front of background, 1 behind background)
	;;; bit 4,3,2 - (null)
	;;; bit 1,0 - subpalette used (00, 01, 10, 11)
	
	
;;; for starting ram position, use spriteOffset.
;; this is set to 0 just before entering this script (or 4 if sprite 0 hit was used).
;; ***remember to increase spriteOffset by 4 for every sprite that is drawn,
;; including after the last one drawn*****, so that the first object's sprite begins
;; in the next available spot.

;;EXAMPLE:
;; DrawSprite #$80, #$80, #$10, #%00000000, spriteOffset
;; inc spriteOffset
;; inc spriteOffset
;; inc spriteOffset
;; inc spriteOffset


	
