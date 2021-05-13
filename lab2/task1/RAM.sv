// Peter Zhong
// 04/21/2021
// EE 371
// Lab #2. Task 1

// RAM is by default a 32x4 RAM that implements synchronous read/write functionalities as specified in the
// lab specifications.

module RAM #(parameter ADDR_WIDTH=5, parameter DATA_WIDTH=4) (addr_in, data_in, data_out, write, clk, reset);

	input logic [ADDR_WIDTH-1:0] addr_in;
	input logic [DATA_WIDTH-1:0] data_in;
	input logic write, clk, reset;
	output logic [DATA_WIDTH-1:0] data_out;
	
	// Initiating the 2D array for the memory module
	logic [2**ADDR_WIDTH-1:0][DATA_WIDTH-1:0] memory_array;
	
	always_ff @(posedge clk) begin
		// Implementing reset logic
		if (reset)
			memory_array <= '0;
		// Implementing write logic
		else if (write) begin
			memory_array[addr_in] <= data_in;
			data_out <= memory_array[addr_in];
		end
		// Implementing read logic
		else
			data_out <= memory_array[addr_in];
	end

endmodule 

// Testbench for the RAM module
module RAM_testbench();
	logic [4:0] addr_in;
	logic [3:0] data_in;
	logic write, reset;
	logic [3:0] data_out;
	logic CLOCK_50;
	
	RAM dut (.addr_in, .data_in, .data_out, .write, .clk(CLOCK_50), .reset);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	initial begin
		// resetting the module
		reset <= 1; repeat(5) @(posedge CLOCK_50);
		
		// writing some random data into the RAM
		reset <= 0; addr_in <= 5'b00001; data_in <= 4'b0001; write <= 1'b1; @(posedge CLOCK_50);
						addr_in <= 5'b00010; data_in <= 4'b0010; write <= 1'b1; @(posedge CLOCK_50);
						addr_in <= 5'b00011; data_in <= 4'b0011; write <= 1'b1; @(posedge CLOCK_50);
						addr_in <= 5'b11111; data_in <= 4'b1111; write <= 1'b1; @(posedge CLOCK_50);
						
		// reading the previously written data from the RAM
						addr_in <= 5'b00001; data_in <= 4'b1010; write <= 1'b0; @(posedge CLOCK_50);
						addr_in <= 5'b00010; data_in <= 4'b1010; write <= 1'b0; @(posedge CLOCK_50);
						addr_in <= 5'b00011; data_in <= 4'b1010; write <= 1'b0; @(posedge CLOCK_50);
						addr_in <= 5'b11111; data_in <= 4'b1010; write <= 1'b0; @(posedge CLOCK_50);
		$stop;
	end
endmodule 