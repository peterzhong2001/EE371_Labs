// Hunter North and Peter Zhong
// 05/12/2020
// EE 371
// Lab #4. Task 2

// DE1_SoC_2 is the top-level module that defines the I/Os for the DE-1 SoC board.
// DE1_SoC_2 takes KEY[0] as synchronous reset, SW[7:0] as input data, and SW[9] as 
// the start signal. if input data is found in the RAM, LEDR[9] will light up and 
// the address of the data will be displayed in hexadecimal format on HEX1 and HEX0.
// If the input data is not found, LEDR8 will light up and all hex displays will
// remain off. 

module DE1_SoC_2 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, CLOCK_50);
   output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0]  LEDR;
   input  logic [3:0]  KEY;
   input  logic [9:0]  SW;
   input logic CLOCK_50;
	
	// assign unused hex displays
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	// use logic to make interconnections
	logic clk, reset, s_in, f, n_f;
	logic [7:0] A_in;
	logic [4:0] addr;
	
	// synchronizing reset
	always_ff @(posedge clk) begin
		reset <= ~KEY[0];
	end
	
	assign clk = CLOCK_50;
	assign s_in = SW[9];
	assign A_in = SW[7:0];
	assign LEDR[9] = f;
	assign LEDR[8] = n_f;
	
	// instantiating a binary searcher. SW[7:0] as input, SW[9] as start, LEDR[9] as found,
	// LEDR[8] as not found. Result to a bus connecting to the hex display module
	binary_search bs1 (.*);
	
	
	// instantiating hex drivers. addr bus as input, HEx0_out and HEX1_out as output
	logic [6:0] HEX0_out, HEX1_out;
	seg7 hex0 (.bcd(addr[3:0]), .leds(HEX0_out));
	seg7 hex1 (.bcd({3'b000, addr[4]}), .leds(HEX1_out));
	
	// use the full signal to control whether the hex displays turn on
	assign HEX0 = f ? HEX0_out : 7'b1111111;
	assign HEX1 = f ? HEX1_out : 7'b1111111;
	
endmodule

`timescale 1 ps / 1 ps
// testbench for the top-level module
module DE1_SoC_2_testbench();
	logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]  LEDR;
   logic [3:0]  KEY;
   logic [9:0]  SW;
   logic CLOCK_50;
	
	DE1_SoC_2 dut (.*);
	
	// assigning logics to make the code more readable
	logic reset;
	assign KEY[0] = ~reset;
	
	logic [7:0] A_in;
	assign SW[7:0] = A_in;
	
	logic s_in;
	assign SW[9] = s_in;
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	// Trying all combinations of inputs (x and y).
	initial begin
		reset <= 1; s_in <= 0; repeat(3) @(posedge CLOCK_50);
						// Large existing A_in
		reset <= 0; s_in <= 0; A_in <= 58; repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
						// Small existing A_in
						s_in <= 0; A_in <= 2;  repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
						// Medium existing A_in, smaller than middle value
						s_in <= 0; A_in <= 28; repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
						// Medium existing A_in, larger than middle value
						s_in <= 0; A_in <= 34; repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
						// Large nonexisting A_in
						s_in <= 0; A_in <= 55; repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
						// Small nonexisting A_in
						s_in <= 0; A_in <= 1;  repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
						// Medium nonexisting A_in, smaller than middle value
						s_in <= 0; A_in <= 29; repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
						// Medium nonexisting A_in, larger than middle value
						s_in <= 0; A_in <= 33; repeat(2) @(posedge CLOCK_50);
						s_in <= 1;             repeat(10) @(posedge CLOCK_50);
		$stop;
	end
endmodule 