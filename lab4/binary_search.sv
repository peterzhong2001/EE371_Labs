// Hunter North and Peter Zhong
// 05/12/2020
// EE 371
// Lab #4. Task 2

// binary_search implements a binary search algorithm on a 32x8 RAM.
// It takes an 8-bit input A_in and start signal S, and outputs f when A_in is in the RAM.
// It outputs n_f when A_in is not in the RAM.

module binary_search(
	input logic clk,
	input logic reset,
	input logic s_in,
	input logic [7:0] A_in,
	
	output logic f, // found
	output logic n_f, //not found
	output logic [4:0] addr
);

	// synchronizing s_in
	logic s;
	always_ff @(posedge clk) begin
		s <= s_in;
	end

	/*------------Datapath-------------*/
	logic ld_A, incr_addr, decr_addr;
	logic [7:0] A;
	logic [7:0] q;
	
	// RAM for numbers. No write operations, read only
	// update q at negative edge (~clk) so that q is updated between address update
	// and comparison operation.
	ram32x8 RAM (.clk(~clk), .addr_in(addr), .data_out(q));
	
	// register for holding A
	always_ff @(posedge clk) begin
		if (reset)
			A <= '0;
		else if (ld_A)
			A <= A_in;
	end
	
	// register for addr and size
	// left and right for tracking the left and right boundaries
	logic [5:0] size, left, right;
	always_ff @(posedge clk) begin
		if (reset | ld_A) begin
			size <= 32;
			addr <= 15;
			left <= 0;
			right <= 31;
		end
		else if (f)
			addr <= addr;
		// increase left bound, update addr and size accordingly
		else if (incr_addr) begin 
			left <= left + (size / 2);
			addr <= (left + (size / 2) + right) / 2;
			size <= right - (left + (size / 2)) + 1;
		end
		// decrease right bound, update addr and size accordingly
		else if (decr_addr) begin
			right <= right - (size / 2);
			addr <= (left + right - (size / 2)) / 2;
			size <= right - (size / 2) - left + 1;
		end
	end
	
	/*------------Control-------------*/
	enum {idle, search, found, not_found} ps, ns;
	
	// next state logic
	always_comb begin
		case(ps)
			idle: if (s) ns = search;
				   else ns = idle;
			search: if (q == A) ns = found;
					  else if (size == 1) ns = not_found;
					  else ns = search;
			found: if (s) ns = found;
				    else ns = idle;
			not_found: if (s) ns = not_found;
						  else ns = idle;
		endcase
	end
	
	// output logic
	assign ld_A = (ps == idle);
	assign f = (ps == found);
	assign n_f = (ps == not_found);
	assign incr_addr = ((ps == search) & (q < A));
	assign decr_addr = ((ps == search) & (q > A));
	
	//DFF
	always_ff @(posedge clk) begin
		if (reset)
			ps <= idle;
		else
			ps <= ns;
	end
endmodule 

`timescale 1 ps / 1 ps
// Testbench for line_drawer module
module binary_search_testbench();
	logic clk, reset, s_in, f, n_f;
	logic [7:0] A_in;
	logic [4:0] addr;
	
	binary_search dut (.*);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		reset <= 1; s_in <= 0; repeat(3) @(posedge clk);
						// Large existing A_in
		reset <= 0; s_in <= 0; A_in <= 58; repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
						// Small existing A_in
						s_in <= 0; A_in <= 2;  repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
						// Medium existing A_in, smaller than middle value
						s_in <= 0; A_in <= 28; repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
						// Medium existing A_in, larger than middle value
						s_in <= 0; A_in <= 34; repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
						// Large nonexisting A_in
						s_in <= 0; A_in <= 55; repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
						// Small nonexisting A_in
						s_in <= 0; A_in <= 1;  repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
						// Medium nonexisting A_in, smaller than middle value
						s_in <= 0; A_in <= 29; repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
						// Medium nonexisting A_in, larger than middle value
						s_in <= 0; A_in <= 33; repeat(2) @(posedge clk);
						s_in <= 1;             repeat(10) @(posedge clk);
		$stop;
	end
endmodule 