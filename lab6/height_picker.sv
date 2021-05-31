// Hunter North and Peter Zhong
// 05/26/2021
// EE 371
// Lab 6
//
// Module that will output the correct height based off an audio segment
// Parameters Used:
//		amp	 	- Amplitude of sound to be visually represented by bar
//		height 	- Decided height of bar
module height_picker(amp, height); 

	input logic [23:0] amp;			// Dimension might need to be adjusted
	
	output logic [8:0] height;
	
	// Scale amp by 480
	integer scaled_amp; 
	assign scaled_amp = amp * 23'h0111E0;
	
	// Divide amp down by max of 24 bit number
	logic [23:0] shrunk_amp;
	assign shrunk_amp = scaled_amp / 24'hffffff;
	
	// Assign final height
	assign height = 480 - shrunk_amp;
	
endmodule

// Module to test the height_picker module
module height_picker_testbench();

	logic [23:0] amp;			// Dimension might need to be adjusted
	logic [8:0] height;
	
	height_picker dut (.*);
	
	initial begin
		amp <= 24'hbf155c; #10;
		amp <= 24'he4835d; #10;
		amp <= 24'h009ed0; #10;
	end
endmodule
