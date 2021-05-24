// Hunter North and Peter Zhong
// 05/17/2021
// EE 371
// Lab 5: Task 1

// DE1_SoC instantiates the noise generator, the simple FIR filter, and the advanced FIR filter.
// It establishes connections so that no key presses outputs raw data, KEY0 outputs noise, KEY1 
// outputs task2 filtered noise, and KEY2 outputs task3 filtered noise.

module DE1_SoC (CLOCK_50, CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT,
	AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT,
	KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

	input logic CLOCK_50, CLOCK2_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	logic signed [23:0] task2_left, task2_right, task3_left, task3_right;
	logic signed [23:0] noisy_left, noisy_right;
	logic reset;
	
	// Instantiates noise generator for KEY0
	logic [23:0] noise;
	noise_gen noise_generator (.clk(CLOCK_50), .en(read), .rst(reset), .out(noise));
	assign noisy_left = readdata_left + noise;
	assign noisy_right = readdata_right + noise;
	
	// Instansiates FIR_filter from task 2 for KEY1
	FIR_filter t2 (.clk(CLOCK_50), .rst(reset), .en(read), .rL(noisy_left), .rR(noisy_right), 
					   .wL(task2_left), .wR(task2_right));
	
	// Instansiates FIR_advanced_filter from task 3 for KEY2
	FIR_advanced_filter t3 (.clk(CLOCK_50), .rst(reset), .en(read), .rL(noisy_left), .rR(noisy_right), 
									.wL(task3_left), .wR(task3_right));
						
	always_comb begin
		case(KEY[2:0])
			3'b110: begin // KEY0 outputs noise
				writedata_left = noisy_left;
				writedata_right = noisy_right;
			end
			3'b101: begin // KEY1 outputs task2 filtered noise
				writedata_left = task2_left;
				writedata_right = task2_right;
			end
			3'b011: begin // KEY2 outputs task3 filtered noise
				writedata_left = task3_left;
				writedata_right = task3_right;
			end
			default: begin // default output raw data
				writedata_left = readdata_left;
				writedata_right = readdata_right;
			end
		endcase
	end

	assign reset = ~KEY[3];
	assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = '1;
	assign LEDR = SW;
	
	// only read or write when both are possible
	assign read = read_ready & write_ready;
	assign write = read_ready & write_ready;
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		1'b0,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		1'b0,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		1'b0,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);
endmodule

module DE1_SoC_testbench ();

	logic CLOCK_50, CLOCK2_50;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	
	// I2C Audio/Video config interface
	wire FPGA_I2C_SCLK;
	wire FPGA_I2C_SDAT;
	// Audio CODEC
	wire AUD_XCK;
	wire AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	wire AUD_ADCDAT;
	wire AUD_DACDAT;
	
	// Insantiate the module for testing
	DE1_SoC dut (.*);
	
	initial begin
		// Set default values
		KEY[3] <= 1; KEY[2] <= 1;	KEY[1] <= 1; KEY[1] <= 0; 					@(posedge CLOCK_50);
		
		// Reset
		KEY[3] <= 0;																		@(posedge CLOCK_50);
		KEY[3] <= 1;																		@(posedge CLOCK_50);
		
		// Listen to song normally
		KEY[3] <= 1;														repeat(50) 	@(posedge CLOCK_50);
		
		// Add noise
		KEY[0] <= 0;														repeat(50) 	@(posedge CLOCK_50);
		
		// Apply simple filter
		KEY[0] <= 1; KEY[1] <= 0;										repeat(50) 	@(posedge CLOCK_50);
		
		// Apply better filter
		KEY[1] <= 1; KEY[2] <= 0;										repeat(50) 	@(posedge CLOCK_50);
		
		$stop;
	end
endmodule