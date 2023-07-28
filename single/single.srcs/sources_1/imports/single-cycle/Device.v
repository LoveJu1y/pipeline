module Device(
	input  reset    , 
	input  clk      , 
	input  MemRead  , 
	input  MemWrite ,
	input  [32 -1:0] MemBus_Address     , 
	input  [32 -1:0] MemBus_Write_Data  , 
	output [32 -1:0] Device_Read_Data
);

	// device registers
	reg [31:0] reg_op;
	reg [31:0] reg_start;
	reg [31:0] reg_ans;

	// -------- Your code below (for question 3) --------

	
	// -------- Your code above (for question 3) --------

endmodule
