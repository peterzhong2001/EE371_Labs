module D_FF (q, d, clk);
	input logic d, clk;
	output logic q;
	
	always_ff @(posedge clk) begin
			q <= d;
	end

endmodule 