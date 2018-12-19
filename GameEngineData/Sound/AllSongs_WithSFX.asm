song_index_New = 0
song_New = 0


song_list:
	.dw New

sfx_list:

instrument_list:
	.dw simple_0
	.dw drone_1
	.dw Silent_2

simple_0:
	.db 5, 9, 11, 13, ARP_TYPE_ABSOLUTE
	.db 13,6,ENV_LOOP, 6
	.db 0,ENV_STOP
	.db 0,DUTY_ENV_STOP
	.db ENV_STOP
drone_1:
	.db 5, 7, 9, 11, ARP_TYPE_ABSOLUTE
	.db 0,ENV_STOP
	.db 0,ENV_STOP
	.db 0,DUTY_ENV_STOP
	.db ENV_STOP
Silent_2:
	.db 5, 7, 9, 11, ARP_TYPE_ABSOLUTE
	.db 0,ENV_STOP
	.db 0,ENV_STOP
	.db 0,DUTY_ENV_STOP
	.db ENV_STOP

New:
	.db 0
	.db 12
	.db 0
	.db 10
	.dw New_square1
	.dw New_square2
	.dw New_triangle
	.dw New_noise
	.dw 0

New_square1:
	.db CAL,<(New_square1_0),>(New_square1_0)
	.db CAL,<(New_square1_1),>(New_square1_1)
	.db CAL,<(New_square1_3),>(New_square1_3)
	.db CAL,<(New_square1_3),>(New_square1_3)
	.db CAL,<(New_square1_0),>(New_square1_0)
	.db CAL,<(New_square1_1),>(New_square1_1)
	.db GOT
	.dw New_square1

New_square2:
	.db CAL,<(New_square2_0),>(New_square2_0)
	.db CAL,<(New_square2_0),>(New_square2_0)
	.db CAL,<(New_square2_0),>(New_square2_0)
	.db CAL,<(New_square2_0),>(New_square2_0)
	.db CAL,<(New_square2_0),>(New_square2_0)
	.db CAL,<(New_square2_0),>(New_square2_0)
	.db GOT
	.dw New_square2

New_triangle:
	.db CAL,<(New_triangle_0),>(New_triangle_0)
	.db CAL,<(New_triangle_1),>(New_triangle_1)
	.db CAL,<(New_triangle_2),>(New_triangle_2)
	.db CAL,<(New_triangle_2),>(New_triangle_2)
	.db CAL,<(New_triangle_0),>(New_triangle_0)
	.db CAL,<(New_triangle_1),>(New_triangle_1)
	.db GOT
	.dw New_triangle

New_noise:
	.db CAL,<(New_noise_1),>(New_noise_1)
	.db CAL,<(New_noise_0),>(New_noise_0)
	.db CAL,<(New_noise_0),>(New_noise_0)
	.db CAL,<(New_noise_0),>(New_noise_0)
	.db CAL,<(New_noise_0),>(New_noise_0)
	.db CAL,<(New_noise_0),>(New_noise_0)
	.db GOT
	.dw New_noise


New_square1_0:
	.db STI,0,SL2,C3,C3,G3,G3,A3,A3,SL4,G3
	.db RET


New_square2_0:
	.db STI,2,SL0,A0
	.db RET


New_triangle_0:
	.db STI,1,SL8,G4,SL4,F4,E4
	.db RET


New_noise_1:
	.db STI,2,SL0,0
	.db RET


New_square1_1:
	.db STI,0,SL2,F3,F3,E3,E3,D3,D3,SL4,C3
	.db RET


New_triangle_1:
	.db STI,1,SL4,F4,E4,D4,C4
	.db RET


New_noise_0:
	.db STI,2,SL0,0
	.db RET


New_square1_3:
	.db STI,0,SL2,G3,G3,F3,F3,E3,E3,SL4,D3
	.db RET


New_triangle_2:
	.db STI,1,SL4,E4,F4,E4,D4
	.db RET



