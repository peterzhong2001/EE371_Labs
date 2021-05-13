// Peter Zhong
// 04/21/2021
// EE 371
// Lab #2. Task 1

// DE1_SoC is the top-level module that defines the I/Os for the DE-1 SoC board.
// DE1_SoC uses switches SW 3−0 to provide input data for the RAM and switches SW 8−4 to specify the address
// for the RAM module. It uses SW9 as the Write signal and KEY0 as the clk input. Using hexadecimal values, 
// It show the address value on the 7-segment displays HEX5−4, shows the data being input to the memory on HEX2,
// and shows the data read out of the memory on HEX0.

module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, CLOCK_50);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
    input logic CLOCK_50;
	
	// Assiging default off value to HEX3 and HEX1
	assign HEX3 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	
	// Assigning clk and reset
	logic clk, reset;
	assign clk = ~KEY[0];
	assign reset = ~KEY[3];
	
	// Establishing data_in, data_out, and addr_in as intermediate connections
	logic [3:0] data_in, data_out;
	logic [4:0] addr_in;
	assign data_in = SW[3:0];
	assign addr_in = SW[8:4];
	
	// ram1 takes addr_in, write, and data_in, and serves as a synchronous read/write 32x4 RAM module.
	// It sets all the stored data to 0 on reset. 
	RAM ram1 (.addr_in, .data_in, .data_out, .write(SW[9]), .clk, .reset);
	
	// hd1 takes addr_in, data_in, and data_out, and displays those values in hexadecimal to the
	// corresponding hex display.
	hex_driver hd1 (.addr_in, .data_in, .data_out, .HEX5, .HEX4, .HEX2, .HEX0);
	
endmodule

module DE1_SoC_testbench();
	logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   logic [3:0]  KEY;
   logic [9:0]  SW;
   logic CLOCK_50;

	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .CLOCK_50);
	
	// Setting up logic to make testbench cleaner
	logic [4:0] addr_in;
	logic [3:0] data_in;
	logic write, clk, reset;
	assign SW[3:0] = data_in;
	assign SW[8:4] = addr_in;
	assign SW[9] = write;
	assign KEY[0] = ~clk;
	assign KEY[3] = ~reset;
	
	// Setting up a simulated clk.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 = 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 = ~CLOCK_50; // Forever toggle the clk
	end
	
	// Trying all combinations of inputs (x and y).
	initial begin
	   // resetting the module
		reset = 1; #10;
		
		// writing some random data into the RAM
		reset = 0; addr_in = 5'b00001; data_in = 4'b0001; write = 1'b1; #10;
					  clk = 1; #10; clk = 0; #10; // simulated clk pulse
					  addr_in = 5'b00010; data_in = 4'b0010; write = 1'b1; #10;
					  clk = 1; #10; clk = 0; #10; 
					  addr_in = 5'b00011; data_in = 4'b0011; write = 1'b1; #10;
					  clk = 1; #10; clk = 0; #10; 
					  addr_in = 5'b11111; data_in = 4'b1111; write = 1'b1; #10;
					  clk = 1; #10; clk = 0; #10; 
						
		// reading the previously written data from the RAM
					  addr_in = 5'b00001; data_in = 4'b1010; write = 1'b0; #10;
					  clk = 1; #10; clk = 0; #10; 
					  addr_in = 5'b00010; data_in = 4'b1010; write = 1'b0; #10;
					  clk = 1; #10; clk = 0; #10;
					  addr_in = 5'b00011; data_in = 4'b1010; write = 1'b0; #10;
					  clk = 1; #10; clk = 0; #10;
					  addr_in = 5'b11111; data_in = 4'b1010; write = 1'b0; #10;
					  clk = 1; #10; clk = 0; #10;
		$stop;
	end
endmodule 