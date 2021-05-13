// Peter Zhong
// 04/21/2021
// EE 371
// Lab #2. Task 3

// This is the driver for a single hex display. It takes in a 4-bit value and display the corresponding
// hexadecimal value on the hex display.

module hex_driver (in, out);

	input logic [3:0] in;
	output logic [6:0] out;
	
	// Initiating a hex ram to drive the hex displays
	logic [15:0][6:0] hex_ram;
	assign hex_ram[0]  = 7'b1000000; // 0
	assign hex_ram[1]  = 7'b1111001; // 1
	assign hex_ram[2]  = 7'b0100100; // 2
	assign hex_ram[3]  = 7'b0110000; // 3
	assign hex_ram[4]  = 7'b0011001; // 4
	assign hex_ram[5]  = 7'b0010010; // 5
	assign hex_ram[6]  = 7'b0000010; // 6
	assign hex_ram[7]  = 7'b1111000; // 7
	assign hex_ram[8]  = 7'b0000000; // 8
	assign hex_ram[9]  = 7'b0010000; // 9
	assign hex_ram[10] = 7'b0001000; // a
	assign hex_ram[11] = 7'b0000011; // b
	assign hex_ram[12] = 7'b1000110; // c
	assign hex_ram[13] = 7'b0100001; // d
	assign hex_ram[14] = 7'b0000110; // e
	assign hex_ram[15] = 7'b0001110; // f

	assign out = hex_ram[in];
	
endmodule 

// Testbench for hex_driver module
module hex_driver_testbench();
	logic [3:0] in;
	logic [6:0] out;
	
	hex_driver dut (.in, .out);
	
	initial begin
	// Test some random inputs
		in = 4'h0; #10;
		in = 4'h3; #10;
		in = 4'h8; #10;
		in = 4'hb; #10;
		in = 4'hf; #10;
		$stop;
	end
endmodule 