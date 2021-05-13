// Peter Zhong
// 5/5/2021
// EE 371
// Lab #3. Task 2

// screen_clearer takes in a clear signal and outputs incrementing x coordinates
// to control the clearing operation of a 640x480 screen. It resets the drawer on
// every increment of x, and it sets listen signal to 1'b1 when there is an ongoing
// reset operation.

module screen_clearer (clear, listen, drawer_reset, clk, x);

	input logic clear, clk;
	output logic [9:0] x;
	output logic listen;
	output logic drawer_reset;
	
	integer count;
	logic enable;
	
	// an enable counter to give the line_drawer enough time to clear
	// enables increment once every 500 cycles (480 vertical pixels).
	// it also controls drawer_reset to go true for 5 cycles on every
	// enable signal.
	always_ff @(posedge clk) begin
		if (listen) begin
			if (clear) begin
				count <= 0;
				enable <= 1'b0;
				drawer_reset <= 1'b1;
			end
			else if (count == 5) begin
				count <= count + 1;
				drawer_reset <= 1'b0;
			end
			else if (count == 500) begin
				count <= 0;
				enable <= 1'b1;
				drawer_reset <= 1'b1;
			end
			else begin
				count <= count + 1;
				enable <= 1'b0;
			end
		end
		else
			drawer_reset <= 1'b0;
	end
	
	// increment x after clearing one column
	// only ask to be listened during valid output time
	always_ff @(posedge clk) begin
		if (clear) begin
			x <= 0;
			listen <= 1'b1;
		end
		else if (enable & x < 641)
			x <= x + 1;
		else if (x == 641)
			listen <= 1'b0;
	end

endmodule 

// Testbench for the screen_clearer module
module screen_clearer_testbench();
	logic [9:0] x;
	logic clear;
	logic clk;
	logic listen;
	logic drawer_reset;
	
	screen_clearer dut (.*);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		clear <= 1; repeat(3) @(posedge clk);
		clear <= 0; repeat (400000) @(posedge clk);
		clear <= 1; repeat(3) @(posedge clk);
		clear <= 0; repeat (100000) @(posedge clk);
		$stop;
	end
endmodule 