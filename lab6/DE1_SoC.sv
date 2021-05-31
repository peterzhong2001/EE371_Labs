// Hunter North and Peter Zhong
// 05/26/2021
// EE 371
// Lab 6
// 
// Top level module which will create the live time audio visualizer
// Parameters required:
//		HEX			 	- 7 bit structures representing hex displays on the DE1_SoC
//		KEY				- 4 different signals represnting the press on a key button on a DE1_SoC
//		LEDR 				- 10 different signals representing the LEDs on DE1_SoC
// 	SW 				- 10 different signals represetning the switches on the DE1_SoC
//		CLOCK_50			- 50 Mhz clock signal
//		VGA drivers 	- A set of drivers used to make the VGA function
//		Audio drivers	- A set of drivers used to make the audio function
//
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, CLOCK2_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS,
					 FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK,
					 AUD_ADCDAT, AUD_DACDAT);
	
	// DE1_SoC hardware 				 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	// DE1_SoC drivers for VGA 
	input CLOCK_50, CLOCK2_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;

	// Make system resetable with key0
	logic reset;
	assign reset = ~KEY[0];	
	
	// Instantiate vga driver module 
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
			 
	// Logic units to drive audio  modules
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	logic signed [23:0] noisy_left, noisy_right;
	
	// Outputs the input audio
	assign writedata_left = readdata_left;
	assign writedata_right = readdata_right;
	// Only read or write when both are possible
	assign read = read_ready & write_ready;
	assign write = read_ready & write_ready;
	
	// Instantiate audio modules
	clock_generator my_clock_gen(CLOCK2_50, 1'b0, AUD_XCK);
	audio_and_video_config cfg(CLOCK_50, 1'b0, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
	audio_codec codec(CLOCK_50, 1'b0, read, write, writedata_left, writedata_right,
							AUD_ADCDAT,	AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK, read_ready, write_ready,
							readdata_left, readdata_right, AUD_DACDAT);
	
	// Instantiate audio segement averaging to be shifted into bar modules
	logic [23:0] amps [0:19]; 
	audio_averaging_shift #(3) aas (.clk(CLOCK_50), .rst(reset), .amps, .rL(readdata_left), .rR(readdata_right));
	
	// Create 20 different bars to visually represent audio		 
	logic [7:0] r1, g1, b1;
	bar_drawer bar_1 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[0]), .rOut(r1), .gOut(g1), .bOut(b1));
	
	logic [7:0] r2, g2, b2;
	bar_drawer bar_2 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[1]), .rOut(r2), .gOut(g2), .bOut(b2));
	
	logic [7:0] r3, g3, b3;
	bar_drawer bar_3 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[2]), .rOut(r3), .gOut(g3), .bOut(b3));
	
	logic [7:0] r4, g4, b4;
	bar_drawer bar_4 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[3]), .rOut(r4), .gOut(g4), .bOut(b4));
	
	logic [7:0] r5, g5, b5;
	bar_drawer bar_5 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[4]), .rOut(r5), .gOut(g5), .bOut(b5));
	
	logic [7:0] r6, g6, b6;
	bar_drawer bar_6 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[5]), .rOut(r6), .gOut(g6), .bOut(b6));
	
	logic [7:0] r7, g7, b7;
	bar_drawer bar_7 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[6]), .rOut(r7), .gOut(g7), .bOut(b7));
	
	logic [7:0] r8, g8, b8;
	bar_drawer bar_8 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[7]), .rOut(r8), .gOut(g8), .bOut(b8));
	
	logic [7:0] r9, g9, b9;
	bar_drawer bar_9 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[8]), .rOut(r9), .gOut(g9), .bOut(b9));
	
	logic [7:0] r10, g10, b10;
	bar_drawer bar_10 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[9]), .rOut(r10), .gOut(g10), .bOut(b10));
	
	logic [7:0] r11, g11, b11;
	bar_drawer bar_11 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[10]), .rOut(r11), .gOut(g11), .bOut(b11));
	
	logic [7:0] r12, g12, b12;
	bar_drawer bar_12 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[11]), .rOut(r12), .gOut(g12), .bOut(b12));
	
	logic [7:0] r13, g13, b13;
	bar_drawer bar_13 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[12]), .rOut(r13), .gOut(g13), .bOut(b13));
	
	logic [7:0] r14, g14, b14;
	bar_drawer bar_14 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[13]), .rOut(r14), .gOut(g14), .bOut(b14));
	
	logic [7:0] r15, g15, b15;
	bar_drawer bar_15 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[14]), .rOut(r15), .gOut(g15), .bOut(b15));
	
	logic [7:0] r16, g16, b16;
	bar_drawer bar_16 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[15]), .rOut(r16), .gOut(g16), .bOut(b16));
	
	logic [7:0] r17, g17, b17;
	bar_drawer bar_17 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[16]), .rOut(r17), .gOut(g17), .bOut(b17));
	
	logic [7:0] r18, g18, b18;
	bar_drawer bar_18 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[17]), .rOut(r18), .gOut(g18), .bOut(b18));
	
	logic [7:0] r19, g19, b19;
	bar_drawer bar_19 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[18]), .rOut(r19), .gOut(g19), .bOut(b19));
	
	logic [7:0] r20, g20, b20;
	bar_drawer bar_20 (.clk(CLOCK_50), .rst(reset), .x, .y, .amp(amps[19]), .rOut(r20), .gOut(g20), .bOut(b20));
	
	// Draw to the VGA
	always_ff @(posedge CLOCK_50) begin
		if (x > 0 && x < 31) begin
			r <= r1;
			g <= g1;
			b <= b1;
		end else if (x > 32 && x < 63) begin
			r <= r2;
			g <= g2;
			b <= b2;
		end else if (x > 64 && x < 95) begin
			r <= r3;
			g <= g3;
			b <= b3;
		end else if (x > 96 && x < 127) begin
			r <= r4;
			g <= g4;
			b <= b4;
		end else if (x > 128 && x < 159) begin
			r <= r5;
			g <= g5;
			b <= b5;
		end else if (x > 160 && x < 191) begin
			r <= r6;
			g <= g6;
			b <= b6;
		end else if (x > 192 && x < 223) begin
			r <= r7;
			g <= g7;
			b <= b7;
		end else if (x > 224 && x < 255) begin
			r <= r8;
			g <= g8;
			b <= b8;
		end else if (x > 256 && x < 287) begin
			r <= r9;
			g <= g9;
			b <= b9;
		end else if (x > 288 && x < 319) begin
			r <= r10;
			g <= g10;
			b <= b10;
		end else if (x > 320 && x < 351) begin
			r <= r11;
			g <= g11;
			b <= b11;
		end else if (x > 352 && x < 383) begin
			r <= r12;
			g <= g12;
			b <= b12;
		end else if (x > 384 && x < 415) begin
			r <= r13;
			g <= g13;
			b <= b13;
		end else if (x > 416 && x < 447) begin
			r <= r14;
			g <= g14;
			b <= b14;
		end else if (x > 448 && x < 479) begin
			r <= r15;
			g <= g15;
			b <= b15;
		end else if (x > 480 && x < 511) begin
			r <= r16;
			g <= g16;
			b <= b16;
		end else if (x > 512 && x < 543) begin
			r <= r17;
			g <= g17;
			b <= b17;
		end else if (x > 544 && x < 575) begin
			r <= r18;
			g <= g18;
			b <= b18;
		end else if (x > 576 && x < 607) begin
			r <= r19;
			g <= g19;
			b <= b19;
		end else if (x > 608 && x < 639) begin
			r <= r20;
			g <= g20;
			b <= b20;
		end else begin
			r <= SW[7:0];
			g <= '0;
			b <= '0;
		end
	end
	
	
	// Turn off hex displays
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
endmodule

// Module to confirm that the DE1_SoC unit is functioning correctly
module DE1_SoC_testbench ();
	// DE1_SoC hardware 				 
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;

	// DE1_SoC drivers for VGA 
	logic CLOCK_50, CLOCK2_50;
	logic [7:0] VGA_R;
	logic  [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	// I2C Audio/Video config interface
	logic FPGA_I2C_SCLK;
	wire FPGA_I2C_SDAT;
	// Audio CODEC
	logic AUD_XCK;
	logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	logic AUD_ADCDAT;
	logic AUD_DACDAT;
	
	// Simulated clock for the testing
	parameter clock_period = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(clock_period / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
	DE1_SoC dut (.*);
	
	initial begin
		
	  
	
		$stop;
	end 
endmodule 
