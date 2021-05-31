// Hunter North and Peter Zhong
// 05/26/2021
// EE 371
// Lab 6
// 
// Module that will calculate the average value over a set of audio samples. This module
// will store 20 difference averages in a shift register that will continually shift right
// in order to make room for the newest average.
// Parameters required:
//		UPDATE_FREQ 	- The rate at which we are shifting in the newest average value
//		clk				- Signal to coordinate timing in module	
//		rst 				- Signal to reset the module
// 	rL 				- The right amplitude from audio file
//		rR					- The left amplitude from audio file
//		amps 				- A 20 unit structure which stores the previous 20 amplitudes 
//
module audio_averaging_shift #(parameter UPDATE_FREQ = 5) (clk, rst, amps, rL, rR);

	input logic clk, rst;
	input logic [23:0] rL, rR;
	output logic [23:0] amps [0:19];
	
	// control logic for updating average value and shifting registers
	integer count;
	logic update_avg, shift_enable;
	
	always_ff @(posedge clk) begin
		if (rst) begin
			count <= 1;
			update_avg <= 0;
			shift_enable <= 0;
		end
		// update avg one cycle before shifting registers
		else if ( (count + 1) == 50000000 / UPDATE_FREQ) begin
			count <= count + 1;
			update_avg <= 1;
			shift_enable <= 0;
		end
		else if (count == 50000000 / UPDATE_FREQ) begin
			count <= 1;
			update_avg <= 0;
			shift_enable <= 1;
		end
		else begin
			count <= count + 1;
			shift_enable <= 0;
			update_avg <= 0;
		end
	end
	
	
	// audio averaging, update average
	logic [23:0] curr_avg, avg;
	integer samples; // number of samples to average for every update operation
	// assign samples = 48000 / UPDATE_FREQ; // 48k samples per second
	// for testbench
	assign samples = 50000000 / UPDATE_FREQ;
	
	always_ff @(posedge clk) begin
		if (rst) begin
			curr_avg <= 0;
			avg <= 0;
		end
		else if (update_avg) begin
			avg <= curr_avg;
			curr_avg <= (rL / samples)  + (rR / samples);
		end
		else
			curr_avg <= curr_avg + (rL / samples)  + (rR / samples);
	end
	

	
	// shift registers w/ count, update frequency 0.2s
	always_ff @(posedge clk) begin
		if (rst) begin
			amps <= '{default: '0};
		end
		else if (shift_enable) begin
			amps[19] <= amps[18];
			amps[18] <= amps[17];
			amps[17] <= amps[16];
			amps[16] <= amps[15];
			amps[15] <= amps[14];
			amps[14] <= amps[13];
			amps[13] <= amps[12];
			amps[12] <= amps[11];
			amps[11] <= amps[10];
			amps[10] <= amps[9];
			amps[9] <= amps[8];
			amps[8] <= amps[7];
			amps[7] <= amps[6];
			amps[6] <= amps[5];
			amps[5] <= amps[4];
			amps[4] <= amps[3];
			amps[3] <= amps[2];
			amps[2] <= amps[1];
			amps[1] <= amps[0];
			amps[0] <= avg;
		end
	end

endmodule 


// Module to test the audio_averaging_shift module	
module audio_averaging_shift_testbench();
	logic clk, rst;
	logic [23:0] rL, rR;
	logic [23:0] amps [0:19];
	
	// shifting once every 2 cycles
	audio_averaging_shift #(10000000) dut(.*);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		rst <= 1; rL <= 0; rR <= 0;  repeat(5) @(posedge clk);
		rst <= 0; rL <= 50; rR <= 50;   @(posedge clk);
					 rL <= 100; rR <= 100; @(posedge clk);
					 rL <= 150; rR <= 150; @(posedge clk);
					 rL <= 200; rR <= 200; @(posedge clk);
					 rL <= 250; rR <= 250; @(posedge clk);
					 rL <= 300; rR <= 300; @(posedge clk);
					 
					 rL <= 50; rR <= 50;   @(posedge clk);
					 rL <= 100; rR <= 100; @(posedge clk);
					 rL <= 150; rR <= 150; @(posedge clk);
					 rL <= 200; rR <= 200; @(posedge clk);
					 rL <= 250; rR <= 250; @(posedge clk);
					 rL <= 300; rR <= 300; @(posedge clk);
					 
					 rL <= 50; rR <= 50;   @(posedge clk);
					 rL <= 100; rR <= 100; @(posedge clk);
					 rL <= 150; rR <= 150; @(posedge clk);
					 rL <= 200; rR <= 200; @(posedge clk);
					 rL <= 250; rR <= 250; @(posedge clk);
					 rL <= 300; rR <= 300; @(posedge clk);
					 
					 rL <= 50; rR <= 50;   @(posedge clk);
					 rL <= 100; rR <= 100; @(posedge clk);
					 rL <= 150; rR <= 150; @(posedge clk);
					 rL <= 200; rR <= 200; @(posedge clk);
					 rL <= 250; rR <= 250; @(posedge clk);
					 rL <= 300; rR <= 300; @(posedge clk);
					 
					 rL <= 50; rR <= 50;   @(posedge clk);
					 rL <= 100; rR <= 100; @(posedge clk);
					 rL <= 150; rR <= 150; @(posedge clk);
					 rL <= 200; rR <= 200; @(posedge clk);
					 rL <= 250; rR <= 250; @(posedge clk);
					 rL <= 300; rR <= 300; @(posedge clk);
					 
					 rL <= 50; rR <= 50;   @(posedge clk);
					 rL <= 100; rR <= 100; @(posedge clk);
					 rL <= 150; rR <= 150; @(posedge clk);
					 rL <= 200; rR <= 200; @(posedge clk);
					 rL <= 250; rR <= 250; @(posedge clk);
					 rL <= 300; rR <= 300; @(posedge clk);
		$stop;
	end
endmodule 
