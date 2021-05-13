
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
					
	/* 	Define_Variables_Here		*/
	
	
	/*			Instantiate_Your_Dual-Port_RAM_Here			*/
	
	
	/*			FIFO-Control_Module			*/				
	FIFO_Control #(depth) FC (.clk, .reset, 
									  .read, 
									  .write, 
									  .wr_en( ),
									  .empty,
									  .full,
									  .readAddr( ), 
									  .writeAddr( )
									 );
	
endmodule 

module FIFO_testbench();
	
	parameter depth = 4, width = 8;
	
	logic clk, reset;
	logic read, write;
	logic [width-1:0] inputBus;
	logic resetState;
	logic empty, full;
	logic [width-1:0] outputBus;
	
	FIFO #(depth, width) dut (.*);
	
	parameter CLK_Period = 100;
	
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	
endmodule 