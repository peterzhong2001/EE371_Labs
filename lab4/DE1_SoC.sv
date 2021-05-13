// Peter Zhong
// 05/12/2020
// EE 371
// Lab #4. Task 1

// DE1_SoC is the top-level module that defines the I/Os for the DE-1 SoC board.
// DE1_SoC takes KEY[0] as synchronous reset, SW[7:0] as input data, and SW[9] as 
// the start signal, and outputs the result of the bit counting operation to HEX0.

module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, CLOCK_50);
   output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0]  LEDR;
   input  logic [3:0]  KEY;
   input  logic [9:0]  SW;
   input logic CLOCK_50;
	
	// assign unused hex displays
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	// use logic to make interconnections
	logic clk, reset, s_in, done;
	logic [7:0] A_in;
	logic [3:0] result;
	
	// synchronizing reset
	always_ff @(posedge clk) begin
		reset <= ~KEY[0];
	end
	
	assign clk = CLOCK_50;
	assign s_in = SW[9];
	assign A_in = SW[7:0];
	assign LEDR[9] = done;
	
	// instantiting bit counter. SW[7:0] as input, SW[9] as start, LEDR[9] as done,
	// result to a bus connecting to the hex display module
	bit_counter bc1 (.*);
	
	// instantiating hex driver. result bus as input, HEx0 as output
	hex_driver hd1 (.in(result), .out(HEX0));
	
endmodule

module DE1_SoC_testbench();
	logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]  LEDR;
   logic [3:0]  KEY;
   logic [9:0]  SW;
   logic CLOCK_50;
	
	DE1_SoC dut (.*);
	
	logic reset;
	assign KEY[0] = ~reset;
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	// Trying all combinations of inputs (x and y).
	initial begin
		reset <= 1; repeat(2) @(posedge CLOCK_50);
		// test three different cases of A_in
		reset <= 0; SW[7:0] <= 8'b01010101; SW[9] <= 0; repeat(2) @(posedge CLOCK_50);
												      SW[9] <= 1; repeat(20) @(posedge CLOCK_50);
					   SW[7:0] <= 8'b11111111; SW[9] <= 0; repeat(2) @(posedge CLOCK_50);
													   SW[9] <= 1; repeat(20) @(posedge CLOCK_50);
						SW[7:0] <= 8'b10010010; SW[9] <= 0; repeat(2) @(posedge CLOCK_50);
													   SW[9] <= 1; repeat(20) @(posedge CLOCK_50);
		$stop;
	end
endmodule 