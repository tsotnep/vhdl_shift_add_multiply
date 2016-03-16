This is a Multiplier, a shift-add-multiplier.
how to use:
	1. provide inputs A_in, B_in
	2. make rising edge of start_calc_in (...01...)
	3. wait for interrupt and read answer 
	4. when interrupt flag is '1' it stays '1' until you do step n : 2
