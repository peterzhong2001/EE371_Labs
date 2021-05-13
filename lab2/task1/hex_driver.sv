// Peter Zhong
// 04/21/2021
// EE 371
// Lab #2. Task 1

// hex_driver is a hex display driver that outputs the corresponding hexadecimal value to the hex display.

module hex_driver (addr_in, data_in, data_out, HEX5, HEX4, HEX2, HEX0);

	input logic [4:0] addr_in;
	input logic [3:0] data_in, data_out;
	output logic [6:0] HEX5, HEX4, HEX2, HEX0;
	
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
	
	// assigning values to output to hex displays
	assign HEX5 = hex_ram[addr_in[4]];
	assign HEX4 = hex_ram[addr_in[3:0]];
	assign HEX2 = hex_ram[data_in];
	assign HEX0 = hex_ram[data_out];
endmodule 

// Testbench for hex_driver module
module hex_driver_testbench();
	logic [4:0] addr_in;
	logic [3:0] data_in, data_out;
	logic [6:0] HEX5, HEX4, HEX2, HEX0;
	
	hex_driver dut (.addr_in, .data_in, .data_out, .HEX5, .HEX4, .HEX2, .HEX0);
	
	// testing random combinations of inputs
	initial begin
		addr_in = 5'b00001; data_in = 4'b0001; data_out = 4'b0001; #10;
		addr_in = 5'b11111; data_in = 4'b1111; data_out = 4'b1111; #10;
		addr_in = 5'b10101; data_in = 4'b0101; data_out = 4'b0101; #10;
		$stop;
	end
endmodule 