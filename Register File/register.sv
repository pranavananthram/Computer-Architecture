`timescale 1ns/10ps

module register(input logic [63:0]WriteData, input logic clk, regEnable, output logic [63:0]dataOut);
	
	logic [63:0] mux2tooneout; // ioutput of each 2-to-1 mux.
	
	
	genvar i;
	
	generate //once for each register
		for (i = 0; i < 64; i++) begin : registers
		//If regEnable = 0, output is the current bit of dataOut[i] (no update).
		//If regEnable = 1, output is WriteData[i] (update requested).
		//Output: mux2tooneout[i] → the data going into the flip-flop.
			mux2_1 muxtwotoone (.x(dataOut[i]), .y(WriteData[i]), .sel(regEnable), .out(mux2tooneout[i]));
			
			//On the rising edge of clk, it stores the value of mux2tooneout[i] into dataOut[i].
			D_FF dfff (.q(dataOut[i]), .d(mux2tooneout[i]), .reset(1'b0), .clk);
		end
	endgenerate 
	
endmodule 