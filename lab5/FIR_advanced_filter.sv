// Hunter North and Peter Zhong
// 05/17/2021
// EE 371
// Lab 5: Task 3

// FIR_advanced filter is a parametrized filter that dynamically takes the average value of
// the most recent N samples of the input data. 

module FIR_advanced_filter #(parameter [7:0] N = 16)
									 (clk, rst, en, rL, rR, wL, wR);

	input logic clk, rst, en;
	input logic [23:0] rR, rL;
	
	output logic [23:0] wR, wL;
	
	// Place log2(N) into n with ceiling operation
	logic [7:0] n;
	always_comb begin
		if 		(N < 2) 		n = 0;
		else if 	(N < 4) 		n = 1;
		else if 	(N < 8) 		n = 2;
		else if 	(N < 16) 	n = 3;
		else if 	(N < 32) 	n = 4;
		else if 	(N < 64) 	n = 5;
		else if 	(N < 128) 	n = 6;
		else if  (N < 256)	n = 7;
	end
	
	// Divide input by window size
	logic [7:0] rRDiv, rLDiv;
	assign rRDiv = rR >> n;
	assign rLDiv = rL >> n;
	
	// Establish unit to govern shifting of N previous segments
	logic [23:0] bufferR [N-1:0];
	logic [23:0] bufferL [N-1:0];
	logic [23:0] outR, outL;
	integer k;
	always_ff @(posedge clk) begin
		// reset to zeros
		if (rst) begin
			for (k = N-1; k >= 0; k--) begin
				bufferR[k] <= '0;
				bufferL[k] <= '0;
			end
			outR <= '0;
			outL <= '0;
		// Update buffer - shift in the input divided by N
		end else if (en) begin
			// Shift in
			bufferR[N-1] <= rRDiv;
			bufferL[N-1] <= rLDiv;
			
			// Move data down
			for (k = N-2; k >= 0; k--) begin
				bufferR[k] <= bufferR[k+1];
				bufferL[k] <= bufferL[k+1];
			end
			
			// Shift out
			outR <= bufferR[0];
			outL <= bufferL[0];
		end
	end	
	
	// Manage accumulation
	logic [23:0] accR, accL;
	always_ff @(posedge clk) begin
		// Reset accumulators to zero
		if (rst) begin
			accR <= 0;
			accL <= 0;
		// Update accumulation
		end else if (en) begin
			accR <= (accR + rRDiv - outR);
			accL <= (accL + rLDiv - outL);
		end
	end
	
	assign wL = accL;
	assign wR = accR;
endmodule

// Testbench for the FIR_advanced_filter module
module FIR_advanced_filter_testbench();
	
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
	FIR_advanced_filter #(16) dut (.*);
	
	initial begin
		rst <= 0; en <= 0; rR <= 0; rL <= 0; 						 @(posedge clk);
		
		// Reset system
		rst <= 1;															 @(posedge clk);
		rst <= 0;												repeat(2) @(posedge clk);
		
		// Load in values
		en <= 1;	rR <= 16;  rL <= 32;		  				repeat(5) @(posedge clk);
		en <= 1;	rR <= 32;  rL <= 64;		  				repeat(5) @(posedge clk);
		en <= 1;	rR <= 64;  rL <= 128;		  			repeat(5) @(posedge clk);
		en <= 1;	rR <= 128; rL <= 256;		  			repeat(10)@(posedge clk);
		
		en <= 0;													repeat(3) @(posedge clk);

		$stop;
	end
endmodule