// Peter Zhong
// 04/21/2021
// EE 371
// Lab #2. Task 3

// FIFO_Control module controls the FIFO. It sends out empty and full signals based on the state of the FIFO.
// It sends out an enable signal to the RAM when a data is to be written into the FIFO. It remembers the location
// of the least recent data and the location where the new data is supposed to be stored, and it passes those
// information to the RAM when they are needed.

module FIFO_Control #(
							 parameter depth = 4
							 )(
								input logic clk, reset,
								input logic read, write,
							  output logic wr_en,
							  output logic empty, full,
							  output logic [depth-1:0] readAddr, writeAddr
							  );
	
	// number of elements in the FIFO structure
	integer n;
	// address of the least recent element
	integer f;

	// Implementing the main logic of the FIFO controller
	always_ff @(posedge clk) begin
		// reset
		if (reset) begin
			 readAddr <= '0;
			writeAddr <= '0;
				 empty <= 1'b1;
				  full <= 1'b0;
				  wr_en <= 1'b0;
				  n <= 0;
				  f <= 0;
		end 
		else if (read | write) begin
			// simultaneous operation
			if (read & write) begin
				readAddr <= f;
				wr_en <= 1'b1;
				f <= (f+1)%(2**depth);
				writeAddr <= (f+n)%(2**depth);
			end
			else begin
				// read
				if (read & ~empty) begin
					if (n == 1) begin
						full <= 1'b0;
						empty <= 1'b1;
					end
					wr_en <= 1'b0;
					full <= 1'b0;
					readAddr <= f;
					n <= n - 1;
					f <= (f+1)%(2**depth);
				end
				// write
				else if (write & ~full) begin
					if (n == (2**depth - 1)) begin
						full <= 1'b1;
						empty <= 1'b0;
					end
					wr_en <= 1'b1;
					empty <= 1'b0;
					writeAddr <= (f+n)%(2**depth);
					n <= n + 1;
				end
				else
					wr_en <= 1'b0;
			end
		end
		else
			wr_en <= 1'b0;
	end
endmodule 

// Testbench for the FIFO_Control module
module FIFO_Control_testbench();
	
	parameter depth = 4;
	
	logic clk, reset;
	logic read, write;
	logic wr_en;
	logic [depth-1:0] readAddr, writeAddr;
	logic empty, full;
	
	// Instantiation of dut
	FIFO_Control #(depth) dut (.*);
	
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
			// write 20 times (over the size of the RAM)
			write <= 1'b1; read <= 1'b0;                    repeat(20) @(posedge clk);
			// read 20 times (over the size of the RAM)
			write <= 1'b0; read <= 1'b1;                    repeat(20) @(posedge clk);
		   // write 5 times then read and write simultaneously for 10 cycles
			write <= 1'b1; read <= 1'b0;                    repeat(5) @(posedge clk);
			write <= 1'b1; read <= 1'b1;                    repeat(10) @(posedge clk);
		$stop;
	end
endmodule 