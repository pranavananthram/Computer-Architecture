`timescale 1ns/10ps
module regfile(ReadData1, ReadData2, WriteData, 
					 ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk); 
					 
	output logic [63:0] ReadData1, ReadData2; 
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	
	logic [31:0] regNum; // One-hot write enables (from decoder)
	logic [31:0][63:0] dataOut;// 32 registers × 64 bits //is the 64-bit output of register i
	logic [63:0][31:0] dataIn; //contains the nth bit from all 32 registers — used for building 32-to-1 muxes


	//This converts WriteRegister (5-bit index) into a one-hot 32-bit signal
	//Only one bit of regNum will be 1 (if RegWrite is high)
	decoder decode (.RegWrite, .WriteRegister, .regNum); 
	
	
	//Each gets WriteData and stores it only if regEnable = 1 (i.e., regNum[i] = 1)
	//dataOut[i] holds the current value of that register
	genvar i, n;
	generate	
		for (i = 0; i < 31; i++) begin : everyRegister
			register registers31 (.WriteData, .clk, .regEnable(regNum[i]), .dataOut(dataOut[i])); 
		end
	endgenerate
	
	//Register 31 is hardwired to zero (WriteData = 0)
	register register31 (.WriteData(64'b0), .regEnable(regNum[31]), .dataOut(dataOut[31]), .clk);
	
	//This rearranges the data to build 32-to-1 muxes
	//For each bit position k, we get a vector of 32 values from all registers
	genvar j, k; 
	generate
		for (j = 0; j < 32; j++) begin : iterateRow
			for (k = 0; k < 64; k++) begin : iterateCol
				assign dataIn[63 - k][j] = dataOut[j][k]; //for 32 to 1 mux
			end 
		end 
	endgenerate
	
	
	//use a mux32_1 to choose 1 of the 32 registers’ value for that bit
	generate 
		for(n = 0; n < 64; n++) begin : thirtytwomuxes
			mux32_1 partone (.x(dataIn[n]), .ch(ReadRegister1), .xout(ReadData1[63 - n])); 
			mux32_1 parttwo (.x(dataIn[n]), .ch(ReadRegister2), .xout(ReadData2[63 - n])); 
		end 
	endgenerate 
	
endmodule

// Test bench for Register file
`timescale 1ns/10ps

module regstim(); 		

	parameter ClockDelay = 5000;

	logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	logic [63:0]	WriteData;
	logic 			RegWrite, clk;
	logic [63:0]	ReadData1, ReadData2;

	integer i;

	// Your register file MUST be named "regfile".
	// Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	regfile dut (.ReadData1, .ReadData2, .WriteData, 
					 .ReadRegister1, .ReadRegister2, .WriteRegister,
					 .RegWrite, .clk);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end

	initial begin
		// Try to write the value 0xA0 into register 31.
		// Register 31 should always be at the value of 0.
		RegWrite <= 5'd0;
		ReadRegister1 <= 5'd0;
		ReadRegister2 <= 5'd0;
		WriteRegister <= 5'd31;
		WriteData <= 64'h00000000000000A0;
		@(posedge clk);
		
		$display("%t Attempting overwrite of register 31, which should always be 0", $time);
		RegWrite <= 1;
		@(posedge clk);

		// Write a value into each  register.
		$display("%t Writing pattern to all registers.", $time);
		for (i=0; i<31; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*64'h0000010204080001;
			@(posedge clk);
			
			RegWrite <= 1;
			@(posedge clk);
		end

		// Go back and verify that the registers
		// retained the data.
		$display("%t Checking pattern.", $time);
		for (i=0; i<32; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*64'h0000000000000100+i;
			@(posedge clk);
		end
		$stop;
	end
endmodule
