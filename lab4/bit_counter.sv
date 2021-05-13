// Peter Zhong
// 05/12/2020
// EE 371
// Lab #4. Task 1

// This module implements a 8-bit bit counter. It takes an 8-bit number, performs
// the bit counting operations when s_in is set to true, and outputs the number of
// "1"s in the input number to result.

// components in the datapath: 8-bit shift register, 4-bit counter

module bit_counter(
	input logic clk,
	input logic reset,
	input logic s_in,
	input logic [7:0] A_in,
	
	output logic [3:0] result,
	output logic done
);

	// control signals
	logic ld_A, shift_A, idle, incr;
	
	// synchronizing s_in
	logic s;
	always_ff @(posedge clk) begin
		s <= s_in;
	end
	
	/*------------Datapath-------------*/
	logic [7:0] A;
	
	// shift register
	always_ff @(posedge clk) begin
		if (reset)
			A <= '0;
		else if (ld_A)
			A <= A_in;
		else if (shift_A)
			A <= A >> 1;
	end

	// counter
	always_ff @(posedge clk) begin
		if (reset | idle)
			result <= '0;
		else if (done)
			result <= result;
		else if (incr)
			result <= result + 1;
	end
	
	/*------------Control-------------*/
	enum {S1, S2, S3} ps, ns;

	// next state logic
	always_comb begin
		case(ps)
			S1: if (s) ns = S2;
				 else ns = S1;
			S2: if (A == 0) ns = S3;
				 else ns = S2;
			S3: if (s) ns = S3;
				 else ns = S1;
		endcase
	end

	//output logic
	assign ld_A = (ps == S1);
	assign shift_A = (ps == S2);
	assign idle = (ps == S1);
	assign incr = ((ps == S2) & (A[0]));
	assign done = (ps == S3);
	
	// DFF
	always_ff @(posedge clk) begin
		if (reset)
			ps <= S1;
		else
			ps <= ns;
	end
endmodule 

// Testbench for bit counter module
module bit_counter_testbench();
	logic clk, reset, s_in, done;
	logic [7:0] A_in;
	logic [3:0] result;
	
	bit_counter dut (.*);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		// reset the entire module
		reset <= 1;                                repeat(3) @(posedge clk);
		// test three different cases of A_in
		reset <= 0; A_in <= 8'b01010101; s_in <= 0; repeat(2) @(posedge clk);
												   s_in <= 1; repeat(20) @(posedge clk);
					   A_in <= 8'b11111111; s_in <= 0; repeat(2) @(posedge clk);
													s_in <= 1; repeat(20) @(posedge clk);
						A_in <= 8'b10010010; s_in <= 0; repeat(2) @(posedge clk);
													s_in <= 1; repeat(20) @(posedge clk);
		$stop;
	end
endmodule 