// Hunter North and Peter Zhong
// 05/09/2021
// EE 371
// Lab 4: Task 1
//
// This module will manage a single hex display that is dedicated to portraying a hex number (0-F).
//	Inputs:
//		bcd:			A 5 bit number representing the desired number to be displayed on hex display
// Outputs:
//		leds:			A 7 bit array representing the lights within a hex display
//
module seg7 (bcd, leds);

	input logic [3:0] bcd;
	output logic [6:0] leds;

	// Logic to translate the inputed number into a configuration of turned on lights in the hex 
	// display
	always_comb begin
		case (bcd)
						// Light: 6543210
			4'b0000: leds = 7'b1000000; // 0
			4'b0001: leds = 7'b1111001; // 1
			4'b0010: leds = 7'b0100100; // 2
			4'b0011: leds = 7'b0110000; // 3
			4'b0100: leds = 7'b0011001; // 4
			4'b0101: leds = 7'b0010010; // 5
			4'b0110: leds = 7'b0000010; // 6
			4'b0111: leds = 7'b1111000; // 7
			4'b1000: leds = 7'b0000000; // 8
			4'b1001: leds = 7'b0010000; // 9
			4'b1010: leds = 7'b0001000; // A
			4'b1011: leds = 7'b0000011; // B
			4'b1100: leds = 7'b1000110; // C
			4'b1101: leds = 7'b0100001; // D
			4'b1110: leds = 7'b0000110; // E
			4'b1111: leds = 7'b0001110; // F
			default: leds = 7'bX;
		endcase
	end
	
endmodule 

// Testbench for the seg7 module that ensures correct operation of the module through
// both normal actions as well as unique edge cases
//
module seg7_testbench();
	logic [3:0] bcd;
	logic [6:0] leds;
	
	// Create an in instance of our seg7 module
	seg7 dut (.bcd, .leds);
	
	// Try all combinations of inputs.
	integer i;
	initial begin
		for(i = 0; i < 16; i++) begin
			{bcd[4:0]} = i;
			#10;
		end	
	end
	
endmodule