// Peter Zhong
// 5/5/2021
// EE 371
// Lab #3. Task 1 and 2

// line_drawer uses Bresenham’s line algorithm to draw a line based on two sets of
// coordinates given by the input. It outputs the coordinates of the pixels over
// several clock cycles. The number of cycles is equal to the number of pixels in the line.

module line_drawer(
	input logic clk, reset,
	
	// x and y coordinates for the start and end points of the line
	input logic [9:0]	x0, x1, 
	input logic [8:0] y0, y1,

	//outputs cooresponding to the coordinate pair (x, y)
	output logic [9:0] x,
	output logic [8:0] y 
	);
	
	// determining steepness of the line 
	logic is_steep;
	logic signed [10:0] xgap;
	logic signed [9:0] ygap;
	// calculating absolute value of the deltas
	assign xgap = (x0 > x1) ? (x0 - x1) : (x1 - x0);
	assign ygap = (y0 > y1) ? (y0 - y1) : (y1 - y0);
	assign is_steep = (ygap > xgap) ? 1'b1 : 1'b0;
	
	// finding starting and ending point
	logic signed [10:0] xstart, xend;
	logic signed [9:0] ystart, yend;
	
	always_comb begin
		// starting on the smaller y value if the line is steep
		if (is_steep) begin
			xstart = (y0 <= y1) ? x0 : x1;
			ystart = (y0 <= y1) ? y0 : y1;
			xend = (y0 > y1) ? x0 : x1;
			yend = (y0 > y1) ? y0 : y1;
		end
		// starting on the smaller x value if the line is gradual
		else begin
			xstart = (x0 <= x1) ? x0 : x1;
			ystart = (x0 <= x1) ? y0 : y1;
			xend = (x0 > x1) ? x0 : x1;
			yend = (x0 > x1) ? y0 : y1;
		end
	end
	
	// determining positive or negative steps for x and y coordinates
	integer xstep, ystep;
	assign xstep = (xend > xstart) ? 1 : -1;
	assign ystep = (yend > ystart) ? 1 : -1;
	
	// logic to output x and y coordinates
	logic signed [11:0] error;
   always_ff @(posedge clk) begin
		// reset x and y to starting points, reset error to initial value
		if (reset) begin
			x <= xstart;
			y <= ystart;
			if (is_steep == 1'b1)
				error <= -ygap/2;
			else
				error <= -xgap/2;
		end
		// logic for if the line is steep
		// increment y one by one, conditional step for x
		else if ((is_steep == 1'b1) & (y < yend)) begin
			y <= y + 1;
			if ((error + xgap) >= 0) begin // increment x
				x <= x + xstep;
				error <= error + xgap - ygap;
			end
			else // update error
				error <= error + xgap;
		end
		// logic for if the line is gradual
		// increment x one by one, conditional step for y
		else if (x < xend) begin
			x <= x + 1;
			if ((error + ygap) >= 0) begin // increment y
				y <= y + ystep;
				error <= error + ygap - xgap;
			end
			else // update error
				error <= error + ygap;
		end
	end 
endmodule

// Testbench for line_drawer module
module line_drawer_testbench();
	logic [9:0] x0, x1, x;
	logic [8:0] y0, y1, y;
	logic clk, reset;
	
	line_drawer dut (.*);
	
	// Setting up a simulated clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	initial begin
		// horizontal line
		reset <= 1; x0 <= 0; y0 <= 1; x1 <= 10; y1 <= 1; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		// vertical line
		reset <= 1; x0 <= 1; y0 <= 1; x1 <= 1; y1 <= 10; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		// perfectly diagonal line from origin
		reset <= 1; x0 <= 0; y0 <= 0; x1 <= 10; y1 <= 10; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		// perfectly diagonal line from arbitrary point
		reset <= 1; x0 <= 5; y0 <= 4; x1 <= 15; y1 <= 14; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		// positive slope gradual slope line (arbitrary)
		reset <= 1; x0 <= 1; y0 <= 0; x1 <= 15; y1 <= 6; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		// positive slope steep slope line (arbitrary)
		reset <= 1; x0 <= 0; y0 <= 1; x1 <= 6; y1 <= 15; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		// negative slope gradual slope line (arbitrary)
		reset <= 1; x0 <= 1; y0 <= 6; x1 <= 15; y1 <= 0; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		// negative slope steep slope line (arbitrary)
		reset <= 1; x0 <= 0; y0 <= 15; x1 <= 6; y1 <= 1; repeat(3) @(posedge clk);
		reset <= 0;                                     repeat(15) @(posedge clk);
		$stop;
	end
endmodule 