// Peter Zhong
// 04/21/2021
// EE 371
// Lab #2. Task 3

// FIFO module implements a 16x8 queue-like FIFO structure. 
// When a read signal is received, FIFO stores the data on the input bus if the FIFO is not full.
// when a write signal is received, FIFO outputs the least recent stored value onto the output bus,
// and removes that value from the FIFO.

module FIFO #(
				  parameter depth = 4,
				  parameter width = 8
				  )(
					 input logic clk, reset,
					 input logic read, write,
					 input logic [width-1:0] inputBus,
					output logic empty, full,
					output logic [width-1:0] outputBus
				   );
					
	// variables for interconnections and communication between the RAM and the controller
	logic [3:0] addr_r, addr_w;
	logic wr_en;
	
	
	// Instantiation of the 16x8 RAm used for the FIFO
	ram16x8 RAM (.clock(clk), .data(inputBus), .rdaddress(addr_r), .wraddress(addr_w), .wren(wr_en), .q(outputBus));
	
	// Instantiation of the controller for the FIFO			
	FIFO_Control #(depth) FC (.clk, .reset, 
									  .read, 
									  .write, 
									  .wr_en,
									  .empty,
									  .full,
									  .readAddr(addr_r), 
									  .writeAddr(addr_w)
									 );
	
endmodule 


// Testbench for the FIFO module
`timescale 1 ps / 1 ps
module FIFO_testbench();
	
	parameter depth = 4, width = 8;
	
	logic clk, reset;
	logic read, write;
	logic [width-1:0] inputBus;
	logic empty, full;
	logic [width-1:0] outputBus;
	
	// Instantiation of dut
	FIFO #(depth, width) dut (.*);
	
	// Generate a 50MHz clock
	parameter CLK_Period = 100;
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	initial begin
		// reset the FIFO module
		reset <= 1;                                        repeat(2) @(posedge clk);
		reset <= 0;                                        repeat(2) @(posedge clk);
			write <= 1'b1; read <= 1'b0;                              @(posedge clk);
		// fill up the entire memory w/ 8'h00 through 8'h0f
		                               inputBus <= 8'h00;           @(posedge clk);
					                      inputBus <= 8'h01;           @(posedge clk);
												 inputBus <= 8'h02;           @(posedge clk);
												 inputBus <= 8'h03;           @(posedge clk);
												 inputBus <= 8'h04;           @(posedge clk);
												 inputBus <= 8'h05;           @(posedge clk);
												 inputBus <= 8'h06;           @(posedge clk);
												 inputBus <= 8'h07;           @(posedge clk);
												 inputBus <= 8'h08;           @(posedge clk);
												 inputBus <= 8'h09;           @(posedge clk);
												 inputBus <= 8'h0a;           @(posedge clk);
												 inputBus <= 8'h0b;           @(posedge clk);
												 inputBus <= 8'h0c;           @(posedge clk);
												 inputBus <= 8'h0d;           @(posedge clk);
												 inputBus <= 8'h0e;           @(posedge clk);
												 inputBus <= 8'h0f;           @(posedge clk);
		// attempt to put in more data after the memory is full
												 inputBus <= 8'h10;           @(posedge clk);
												 inputBus <= 8'h11;           @(posedge clk);
												 inputBus <= 8'h12;           @(posedge clk);
			write <= 1'b0;                                           @(posedge clk);
		// clear out the entire memory & attempt to read more data
							   read <= 1'b1;                   repeat(20) @(posedge clk);
		// simultaneous read and write operations after writing
												  inputBus <= 8'h00;           @(posedge clk);
			write <= 1'b1; read <= 1'b0; inputBus <= 8'h00;           @(posedge clk);
												  inputBus <= 8'h01;           @(posedge clk);
												  inputBus <= 8'h02;           @(posedge clk);
												  inputBus <= 8'h03;           @(posedge clk);
												  inputBus <= 8'h04;           @(posedge clk);
												  inputBus <= 8'h05;           @(posedge clk);
			write <= 1'b1; read <= 1'b1; inputBus <= 8'h06;           @(posedge clk);	
												  inputBus <= 8'h07;           @(posedge clk);
												  inputBus <= 8'h08;           @(posedge clk);
												  inputBus <= 8'h09;           @(posedge clk);
												  inputBus <= 8'h0a;           @(posedge clk);
												  inputBus <= 8'h0b;           @(posedge clk);
												  inputBus <= 8'h0c;           @(posedge clk);
												  inputBus <= 8'h0d;           @(posedge clk);
												  inputBus <= 8'h0e;           @(posedge clk);
												  inputBus <= 8'h0f;           @(posedge clk);
		$stop;
	end
endmodule 