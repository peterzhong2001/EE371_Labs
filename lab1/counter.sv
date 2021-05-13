// Peter Zhong
// 04/12/2020
// EE 371
// Lab #1. Task 2

// counter takes two inputs (inc, dec). It adds 5'b00001 to out when inc is true, and subtracts 5'b00001
// from out when dec is true. Out has a minimum value of 5'b00000 and a maximum value determined by the
// parameter (25 by default).

module counter #(parameter MAX=25) (inc, dec, out, full, clear, clk, reset);

	input logic inc, dec, clk, reset;
	output logic [4:0] out;
	output logic full, clear;

	// Sequential logic for counting up and counting down depending on the input.
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= 5'b00000;
			full <= 1'b0;
			clear <= 1'b0;
		end
		else if (inc & out < MAX) begin //increment when not at max
			out <= out + 5'b00001;
			clear <= 1'b0;
		end
		else if (dec & out > 5'b00000) begin // decrement when not at min
			out <= out - 5'b00001;
			full <= 1'b0;
		end
		else if (out == MAX) begin // hold value at max, output full
			out <= MAX;
			full <= 1'b1;
		end
		else if (out == 5'b00000) begin // hold value at min, output clear
			out <= 5'b00000;
			clear <= 1'b1;
		end
		else
			out <= out; // hold value otherwise
	end

endmodule 

// Testbench for the counter module
module counter_testbench();
	logic inc, dec, full, clear, reset;
	logic [4:0] out;
	logic CLOCK_50;
	
	counter #(5) dut (.inc, .dec, .out, .full, .clear, .clk(CLOCK_50), .reset);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	initial begin
		reset <= 1;                     repeat(3) @(posedge CLOCK_50); // reset
		reset <= 0; inc <= 1;           repeat (7) @(posedge CLOCK_50); // inc past max limit
						inc <= 0; dec <= 1; repeat(7) @(posedge CLOCK_50); // dec past min limit
		$stop;
	end
endmodule 