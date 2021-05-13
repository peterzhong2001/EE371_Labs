// Peter Zhong
// 5/5/2021
// EE 371
// Lab #3. Task 2

// DE1_SoC_2 is a modified version of DE1_SoC from Task 1. On top the original functionalities,
// it instantiated a screen_clearer to control the screen clearing process, an input_processing to
// clean up user input, and an always_ff block to implement the animation controller.

module DE1_SoC_2 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	logic [9:0] x0, x1, x;
	logic [8:0] y0, y1, y;
	logic frame_start;
	logic pixel_color;
	
	// logic to tell the animation to run
	logic running;
	assign running = SW[0];
	
	// logic for resetting the drawer
	logic drawer_reset_clearer, drawer_reset_animation;
	
	// this input_processing module makes the "clear" input from user one cycle long
	logic clear;
	input_processing ip1 (.A(~KEY[3]), .out(clear), .clk(CLOCK_50));
	
	// screen_clearer controls the x coordinates of the clearing operation.
	logic listen;
	logic [9:0] x_clear;
	screen_clearer clearer (.clk(CLOCK_50), .clear(clear), 
								.listen, .drawer_reset(drawer_reset_clearer), .x(x_clear));
	
	// muxes to control buses for coordinates
	logic [9:0] x0_bus, x1_bus;
	logic [8:0] y0_bus, y1_bus;
	// logic for listening either to the clearer or to the animation generator
	assign x0_bus = listen ? x_clear : x0;
	assign y0_bus = listen ? 0 : y0;
	assign x1_bus = listen ? x_clear : x1;
	assign y1_bus = listen ? 480 : y1;
	
	// RAM for coordinates of lines
	logic [9:0] x0_coordinates [0:9];
	logic [8:0] y0_coordinates [0:9];
	logic [9:0] x1_coordinates [0:9];
	logic [8:0] y1_coordinates [0:9];
	// assign values to the x0 and y0 coordinates
	assign x0_coordinates[0] = 320;
	assign x0_coordinates[1] = 220;
	assign x0_coordinates[2] = 220;
	assign x0_coordinates[3] = 420;
	assign x0_coordinates[4] = 420;
	assign x0_coordinates[5] = 320;
	assign x0_coordinates[6] = 220;
	assign x0_coordinates[7] = 420;
	assign x0_coordinates[8] = 220;
	assign x0_coordinates[9] = 420;
	assign y0_coordinates[0] = 160;
	assign y0_coordinates[1] = 220;
	assign y0_coordinates[2] = 320;
	assign y0_coordinates[3] = 320;
	assign y0_coordinates[4] = 220;
	assign y0_coordinates[5] = 160;
	assign y0_coordinates[6] = 320;
	assign y0_coordinates[7] = 220;
	assign y0_coordinates[8] = 220;
	assign y0_coordinates[9] = 320;
	// assign values to the x1 and y1 coordinates
	assign x1_coordinates[0] = 220;
	assign x1_coordinates[1] = 220;
	assign x1_coordinates[2] = 420;
	assign x1_coordinates[3] = 420;
	assign x1_coordinates[4] = 320;
	assign x1_coordinates[5] = 220;
	assign x1_coordinates[6] = 420;
	assign x1_coordinates[7] = 220;
	assign x1_coordinates[8] = 420;
	assign x1_coordinates[9] = 320;
	assign y1_coordinates[0] = 220;
	assign y1_coordinates[1] = 320;
	assign y1_coordinates[2] = 320;
	assign y1_coordinates[3] = 220;
	assign y1_coordinates[4] = 160;
	assign y1_coordinates[5] = 320;
	assign y1_coordinates[6] = 220;
	assign y1_coordinates[7] = 220;
	assign y1_coordinates[8] = 320;
	assign y1_coordinates[9] = 160;
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	// paint in black if clearing, paint in white otherwise
	assign pixel_color = listen ? 1'b0 : 1'b1;
	
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x, .y,
				.pixel_color, .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);
	
	// draw lines between (x0, y0) and (x1, y1)
	line_drawer lines (.clk(CLOCK_50), .reset(drawer_reset_clearer | drawer_reset_animation),
				.x0(x0_bus), .y0(y0_bus), .x1(x1_bus), .y1(y1_bus), .x, .y);
	
	// use count to count clock cycle, index to keep track of address of RAM to read off of
	integer count, index;
	integer clock_cycle = 50000000; // frequency of the clock for CLOCK_50
	// integer clock_cycle = 500; // frequency of the clock for testbench
	// logic to control the animation
	always_ff @(posedge CLOCK_50) begin
		if (clear) begin
			count <= 0;
			index <= 0;
			// set to inactive coordinates
			x0 <= 641;
			x1 <= 641;
			y0 <= 481;
			y1 <= 481;
		end
		else if (count == 1) begin // tell drawer to update as soon as there is a new line to draw
			count <= count + 1;
			drawer_reset_animation <= 1'b1;
		end
		else if (count == 3) begin // turn off the update signal
			count <= count + 1;
			drawer_reset_animation <= 1'b0;
		end
		else if (count == (clock_cycle / 2)) begin // update index every half a second
			count <= 0;
			if (index < 9)
				index <= index + 1;
			else
				index <= 0;
			// update coordinates
			x0 <= x0_coordinates[index];
			x1 <= x1_coordinates[index];
			y0 <= y0_coordinates[index];
			y1 <= y1_coordinates[index];
		end
		else if (running) begin
			count <= count + 1;
		end
	end
endmodule


// Testbench for the top-level module
module DE1_SoC_2_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	logic CLOCK_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	DE1_SoC_2 dut (.*);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	logic clear, running;
	assign KEY[3] = ~clear;
	assign SW[0] = running;
	initial begin
		clear <= 1; running <= 0;        repeat(5) @(posedge CLOCK_50);
		clear <= 0;                                @(posedge CLOCK_50);
		clear <= 1;  					repeat (400000) @(posedge CLOCK_50); // clear the VGA
		clear <= 0; running <= 1;  repeat(5000) @(posedge CLOCK_50); // let the animation run
		$stop;
	end
endmodule 