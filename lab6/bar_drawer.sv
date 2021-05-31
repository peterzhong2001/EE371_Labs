// Hunter North and Peter Zhong
// 05/26/2021
// EE 371
// Lab 6
//
// Module that will draw a bar on the screen based on an audio segment
// Parameters Used:
//		clk 		- Clock to coordinate timing in module
//		rst 		- Signal to reset bar to all black
//		x			- X component of location that is being drawn to
//		y			- Y component of location that is being drawn to
//		amp	 	- Amplitude of sound to be visually represented by bar
//		rOut 		- Red coloring in bar
//		gOut 		- Green coloring in bar
//		bOut 		- Blue coloring in bar
module bar_drawer (clk, rst, x, y, amp, rOut, gOut, bOut);
	
	input logic 			clk;
	input logic 			rst;
	input logic [9:0] 	x;
	input logic [8:0]  	y;
	input logic [23:0]	amp;			// Dimension might need to be adjusted
	
	output logic [7:0] 	rOut, gOut, bOut;

	/****Determine Height of Bar*******/
	logic [8:0] height;
	height_picker hp (.*);
	
	
	/****Determine Color of Bar********/
	logic [7:0] rBar, gBar, bBar;
	color_picker cp (.amp, .rOut(rBar), .gOut(gBar), .bOut(bBar));
	
	/****Draw to Board ***************/
	always_ff @(posedge clk) begin
		// Black when resetting
		if (rst) begin
			rOut <= '0;
			gOut <= '0;
			bOut <= '0;
		// Black if outisde the determined bar height
		end else if (y < height) begin 
			rOut <= '0;
			gOut <= '0;
			bOut <= '0;
		// Draw bar calculated colors if inside bar height
		end else if (y >= height) begin
			rOut <= rBar;
			gOut <= gBar;
			bOut <= bBar;
		end
	end
endmodule

// Module to test the bar_drawer module	
module bar_drawer_testbench ();
	
	// Inputs to drive dut
	logic 		clk;
	logic 		rst;
	logic [9:0] x;
	logic [8:0] y;
	logic [23:0] amp;			// Dimension might need to be adjusted
	
	// Outputs for dut
	logic [7:0] rOut, gOut, bOut;
	
	// Simulated clock for testing
	parameter clock_period = 100;
	initial begin
		clk <= 0;
		forever #(clock_period / 2) clk <= ~clk;
	end
	
	// Instantiate module for testing
	bar_drawer dut (.*);
	
	// Test dut
	initial begin
		// Set defaults
		rst <= 0;	x <= 0; 	y <= 0; 	amp <= 0; 		@(posedge clk);
		
		// Reset system	
		rst <= 1;									repeat(1)@(posedge clk);
		
		// Undo reset
		rst <= 0;									repeat(1)@(posedge clk);
		
		// Test large (250) amp
		// inside bar...
		y <= 400;	amp <= 8000000;			repeat(2)@(posedge clk);
		// Outside bar...
		y <= 100;									repeat(2)@(posedge clk);
				
		$stop;
	end
endmodule
