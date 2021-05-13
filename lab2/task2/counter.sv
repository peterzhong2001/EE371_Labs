// Peter Zhong
// 04/21/2021
// EE 371
// Lab #2. Task 2

// counter scrolls through the 5-bit address one by one, stopping for approximately one second at each address.
// The parameter FREQ specifies the number of clock cycles for the counter to increment by 1. It is set to 
// 50M by default for the 50MHz clock on the DE1_SoC board.

module counter #(parameter FREQ=50000000)(addr_r, clk, reset);

	input logic clk, reset;
	output logic [4:0] addr_r;
	
	integer count;
	
	always_ff @(posedge clk) begin
		// Implementing reset
		if (reset) begin
			addr_r <= '0;
			count <= 0;
		end
		// Update addr_r when 1 second has passed
		else if (count == FREQ) begin
			if (addr_r == 5'b11111)
				addr_r <= '0;
			else
				addr_r <= addr_r + 5'b00001;
			count <= 0;
		end
		// Increment count when less than 1 second has passed
		else
			count <= count + 1;
	end
	
endmodule 

// Testbench for counter module
module counter_testbench();
	logic clk, reset;
	logic [4:0] addr_r;
	logic CLOCK_50;
	
	// Instantiating a 1-clock-cycle counter for testbench purpose
	counter #(0) dut (.addr_r, .clk(CLOCK_50), .reset);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	// Reset the module, then let the counter run
	initial begin
		reset <= 1; repeat(5) @(posedge CLOCK_50);
		reset <= 0; repeat(40) @(posedge CLOCK_50);
		$stop;
	end
endmodule 