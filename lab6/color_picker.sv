// Hunter North and Peter Zhong
// 05/26/2021
// EE 371
// Lab 6
//
// Module that will output the correct color based off of audio segment
// Parameters Used:
//		amp	 	- Amplitude of sound to be visually represented by bar
//		rOut	 	- Amount of red coloring in output color
//		gOut	 	- Amount of green coloring in output color
//		bOut	 	- Amount of blue coloring in output color

module color_picker(amp, rOut, gOut, bOut); 

	input logic [23:0] amp;			// Dimension might need to be adjusted
	
	output logic [7:0] rOut, gOut, bOut;
	
	assign rOut = amp[23:16];
	assign bOut = amp[15:8];
	assign gOut = amp[7:0];
	
endmodule

// Module to test the color_picker module
module color_picker_testbench();

	logic [23:0] amp;			// Dimension might need to be adjusted
	logic [7:0] rOut, gOut, bOut;
	
	color_picker dut (.*);
	
	initial begin
		amp <= 24'hfff010; #10;
		amp <= 24'h0ff111; #10;
		amp <= 24'h00f0d4; #10;
	end
endmodule
