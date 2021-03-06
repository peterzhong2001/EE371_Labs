// Hunter North and Peter Zhong
// 05/17/2021
// EE 371
// Lab 5: Task 2

// FIR_filter is an averaging filter that removes noise from an audio sample by 
// taking the average of the adjacent 8 samples and outputting the average value
// to the output terminal.

module FIR_filter(clk, rst, en, rL, rR, wL, wR);

	input logic clk, rst, en;
	input logic [23:0] rR, rL;
	output logic [23:0] wR, wL;
 
	// Establish unit to govern shifting of 8 previous segments
	logic [23:0] bufferR [7:0];
	logic [23:0] bufferL [7:0];
	integer k;
	always_ff @(posedge clk) begin
		// reset to zeros
		if (rst) begin
			for (k = 7; k >= 0; k--) begin
				bufferR[k] <= '0;
				bufferL[k] <= '0;
			end
		
		// Update buffer - shift in the input divided by eight
		end else if (en) begin
			bufferR[7] <= {{3{rR[23]}}, rR[23:3]};
			bufferL[7] <= {{3{rL[23]}}, rL[23:3]};
			
			for (k = 6; k >= 0; k--) begin
				bufferR[k] <= bufferR[k+1];
				bufferL[k] <= bufferL[k+1];
			end
		end
	end
	
	// Perform summing operation
	logic [23:0] avR, avL;
	assign avR =	(bufferR[7] + bufferR[6] + bufferR[5] + bufferR[4] +
						bufferR[3] + bufferR[2] + bufferR[1] + bufferR[0]);
	assign avL =	(bufferL[7] + bufferL[6] + bufferL[5] + bufferL[4] +
						bufferL[3] + bufferL[2] + bufferL[1] + bufferL[0]);
						
	// Assign averages to the output
	always_ff @(posedge clk) begin
		if (en) begin
			wL <= avL;
			wR <= avR;
		end
	end
endmodule

// Testbench for the FIR_filter module
module FIR_filter_testbench();
	
	logic clk, rst, en;
	logic [23:0] rR, rL;
	logic [23:0] wR, wL;
	
	// Simulated clock for the testing
	parameter clock_period = 100;
	initial begin
		clk <= 0;
		forever #(clock_period / 2) clk <= ~clk;
	end
	
	// Insantiate the module for testing
	FIR_filter dut (.*);
	
	initial begin
		rst <= 0; en <= 0; rR <= 0; rL <= 0; 						 @(posedge clk);
		
		// Reset system
		rst <= 1;															 @(posedge clk);
		rst <= 0;												repeat(2) @(posedge clk);
		
		// Load in values
		en <= 1;	rR <= 8;  rL <= 16;		  				repeat(4) @(posedge clk);
		en <= 1;	rR <= 16; rL <= 32;  					repeat(4) @(posedge clk);
		en <= 1; rR <= 0;  rL <= 0;						repeat(10) @(posedge clk);
		$stop;
	end
endmodule