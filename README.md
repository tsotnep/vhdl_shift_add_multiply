This is a Multiplier, a shift-add-multiplier.
steps on how to use:

	1. provide inputs A_in, B_in
	2. make rising edge of start_calc_in (...01...)
	3. after interrupt/ans_ready_out becomes '1' then you can immediately read answer
	4. when interrupt flag is '1' it stays '1' until you do step n : 2

note: output is (input size)*2

note: when interrupt flag becomes '1', fsm is able to start calculation after 2 clock cycles (on simulation screen it's 3)

calculation times:
        lets assume bitwidth of input is SIZE=5.
        
        after giving rising edge of start_calc_in:
        
	        *5 clock cycles to finish calculation (max)
	        
	        +1 clock cycle to set interrupt flag to '1'
	        
	
        *value provided on B_in input shifts to left, A_in shifts to right.
        
                if B_in becomes 0 earlier than SIZE clock cycles then it stops calculation
                
                example 1:
                        A_in = 11011, B_in = 00001, time of result: 1+1 clock cycle
                example 2:
                        A_in = 11011, B_in = 10001, time of result: 5+1 clock cycle
                resume:
                        if calculation is time critical, try to provide smaller numbers on input B_in


this diagram describes how FSM of multiplier works
![FSM](http://i.imgur.com/dNgUYem.png)





this is the fragment, of how simulation
![SIM](http://i.imgur.com/i3f5Ita.png)

