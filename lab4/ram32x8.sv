// Hunter North and Peter Zhong
// 04/21/2021
// EE 371
// Lab #4. Task 2

// ram32x8 is by default a 32x8 RAM that implements synchronous read functionality.
// It is initialized with a .mif file and therefore does not have any write functionality.

module ram32x8 #(parameter ADDR_WIDTH=5, parameter DATA_WIDTH=8) (addr_in, data_out, clk);

	input logic [ADDR_WIDTH-1:0] addr_in;
	input logic clk;
	output logic [DATA_WIDTH-1:0] data_out;
	
	// Initiating the 2D array for the memory module
	logic [DATA_WIDTH-1:0] memory_array [0:2**ADDR_WIDTH-1] /* synthesis ram_init_file = "my_array.mif"*/ ;
	
	always_ff @(posedge clk)
			data_out <= memory_array[addr_in];
endmodule 

// Testbench for the RAM module
module ram32x8_testbench();
	logic [4:0] addr_in;
	logic write;
	logic [3:0] data_out;
	logic CLOCK_50;
	
	ram32x8 dut (.addr_in, .data_out, .clk(CLOCK_50));
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	initial begin					
		// reading data from the RAM
						addr_in <= 5'b00001;  @(posedge CLOCK_50);
						addr_in <= 5'b00010;  @(posedge CLOCK_50);
						addr_in <= 5'b00011;  @(posedge CLOCK_50);
						addr_in <= 5'b11111;  @(posedge CLOCK_50);
		$stop;
	end
endmodule 