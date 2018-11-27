.enum ObjectRam
	Object_status .dsb 12 ; required
			;;;; bits 765 = activation/deactivation
			;;;; bit 3 = reserved for edge/random spawning, but waiting for timer
			;;;; bit 0 = "hurt and invincible" (used for recoil direction)
			;;;; bit 1 = "post-invincible hurt" (still invincible but has regained input control)
	Object_type .dsb 12 ; required
	Object_x_hi	.dsb 12 ; required
		
	Object_x_lo .dsb 12 ; required
	Object_y_hi	.dsb 12 ; required
	Object_y_lo	.dsb 12 ; required 
;	Object_max_speed	.dsb 12 ;; NOT REQUIRED, can read from look up.
	Object_speed_variant	.dsb 12 
	Object_v_speed_lo	.dsb 12 ;; required
	Object_v_speed_hi	.dsb 12 ;; required
	Object_h_speed_lo	.dsb 12	;; required
	Object_h_speed_hi	.dsb 12


;	Object_size			.dsb 12 ;; NOT REQUIRED, can read from look up.,
	Object_movement		.dsb 12 ;; required
;	Object_bbox_left	.dsb 12 ;; NOT REQUIRED, can read from lookup.
;	Object_bbox_top		.dsb 12 ;; NOT REQUIRED, can read from lookup
;	Object_width		.dsb 12 ;; NOT REQUIRED, can read from lookup
;	Object_height		.dsb 12 ;; NOT REQUIRED, can read from lookup
	Object_vulnerability .dsb 12 ;; NOT REQUIRED, can read from lookup
	Object_action_timer	.dsb 12 ;; required
	Object_animation_timer . dsb 12
	Object_health		.dsb 12 ;; required
	Object_animation_frame .dsb 12
	Object_action_step		.dsb 12  ;; 8 steps, thus 32 potential types of action with remaining bits.
										;; xxxxxyyy where y = action step and x = behavior type.
	Object_animation_offset_speed .dsb 12	;; 7654 = offset, 3210 = speed.
											;; to be updated every time animation type changes.
		Object_end_action				.dsb 12
		Object_edge_action				.dsb 12
;;;=========================================
;;These variables are stored pointers to the object'so
;; direction table lookup in ram, which points to the
;; stuff to draw.  Keeping them with the object should speed things up
;; considerably by saving two address jumps for every single tile drawn!

	Object_table_lo_lo     .dsb 12
	Object_table_lo_hi		.dsb 12
	Object_table_hi_lo		.dsb 12
	Object_table_hi_hi		.dsb 12
	Object_total_tiles		.dsb 12 
	;; these, will be loaded into temp12 or another pointer.  Then an offset will be factored.
	;;;
;;==============================================
;;===============================================
	Object_timer_0		.dsb 12 ;; generally used for hurt timer.
								;; though a state could also be used for a hurt timer, this provides another option.
	
;	Object_worth			.dsb 12 ;; NOT REQUIRED, can read from look up
;	Object_acc_amount		.dsb 12 ;; NOT REQUIRED, can read from lookup
;	Object_strength_defense	.dsb 12 ;; NOT REQUIRED can read from look up
	Object_flags			.dsb 12 ;;Required if you ever want to use it in collision routines!
;; SOME OF THE NON-REQUIREDS will only work if being called from static bank
;; so, for instance, do collisions in static bank so bboxes, vulnerability, etc
;; can be accessed by having anim bank loaded.
;;;;;;;;;;;;;;;;;;;
; THERE CAN BE ROOM FOR TWO USER DEFINED VARIABLES
; AND STILL HAVE ROOM TO PUT SCROLL RAM HERE
	Object_ID			.dsb 12
	Object_scroll		.dsb 12

	updateColumnNT_fire_Tile .dsb 32




.ende