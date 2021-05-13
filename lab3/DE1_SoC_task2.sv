// Peter Zhong
// 5/5/2021
// EE 371
// Lab #3. Task 2

// DE1_SoC_task2 is a modified version of DE1_SoC from Task 1. On top the original functionalities,
// it instantiated a screen_clearer to control the screen clearing process, an input_processing to
// clean up user input, and an always_ff block to implement the animation controller.

module DE1_SoC_task2 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
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
	
	// logic for resetting the animations
	logic reset;
	assign reset = ~KEY[0];
	
	// logic for resetting the drawer
	logic drawer_reset_clearer, drawer_reset_animation;
	
	// this input_processing module makes the "clear" input from user one cycle long
	input_processing ip1 (.A(~KEY[3]), .out(clear_user), .clk(CLOCK_50));
	
	// screen_clearer controls the x coordinates of the clearing operation.
	logic listen, clear_user, clear_animation;
	logic [9:0] x_clear;
	screen_clearer clearer (.clk(CLOCK_50), .clear(clear_user | clear_animation), 
								.listen, .drawer_reset(drawer_reset_clearer), .x(x_clear));
	
	// muxes to control buses for coordinates
	logic [9:0] x0_bus, x1_bus;
	logic [8:0] y0_bus, y1_bus;
	// logic for listening either to the clearer or to the animation generator
	assign x0_bus = listen ? x_clear : x0;
	assign y0_bus = listen ? 0 : y0;
	assign x1_bus = listen ? x_clear : x1;
	assign y1_bus = listen ? 480 : y1;
	
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
	
	// using an always_ff block to manage animations
	// draw line, clear frame, increment coordinate, repeat
	integer count, incr_count, decr_count;
	always_ff @(posedge CLOCK_50) begin
		// only execute if the user is not clearing the screen
		if (KEY[3]) begin
			if (reset) begin // reset to the beginning of the animation
				count <= 0;
				incr_count <= 0;
				decr_count <= 0;
				x0 <= 30;
				y0 <= 100;
				x1 <= 100;
				y1 <= 30;
				clear_animation <= 1'b1;
				drawer_reset_animation <= 1'b1;
			end
			// undo drawer_reset_animation after 5 cycles, start drawing the line
			else if (count == 5) begin
				count <= count + 1;
				drawer_reset_animation <= 1'b0;
			end
			// clear the frame after drawing a line
			else if (count == 400000) begin
				count <= count + 1;
				clear_animation <= 1'b1;
			end
			// increment the coordinates after clearing the frame
			else if (count == 800000) begin
				count <= count + 1;
				drawer_reset_animation <= 1'b1;
				if (incr_count < 250) begin // increment
					incr_count <= incr_count + 1;
					x0 <= x0 + 1;
					y0 <= y0 + 1;
					x1 <= x1 + 1;
					y1 <= y1 + 1;
				end
				else if (decr_count < 250) begin // decrement
					decr_count <= decr_count + 1;
					x0 <= x0 - 1;
					y0 <= y0 - 1;
					x1 <= x1 - 1;
					y1 <= y1 - 1;
				end
				else if (incr_count == 250 & decr_count == 250) begin // clear count
					incr_count <= 0;
					decr_count <= 0;
				end
			end
			// undo the reset after 5 cycles, start drawing the next frame
			else if (count == 800005) begin
				count <= 0;
				drawer_reset_animation <= 1'b0;
			end
			else begin
				count <= count + 1;
				clear_animation <= 1'b0;
			end
		end
	end
endmodule

// Testbench for the top-level module
module DE1_SoC_task2_testbench();
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
	
	DE1_SoC_task2 dut (.*);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
	end
	
	logic reset;
	assign KEY[0] = ~reset;
	
	initial begin
		reset <= 1; repeat (5) @(posedge CLOCK_50);
		reset <= 0; repeat(500) @(posedge CLOCK_50);
		$stop;
	end
endmodule 