module test_cpu();
	
	reg reset   ;
	reg clk1     ;

//	wire        MemRead             ; 
//	wire        MemWrite            ;
//	wire [31:0] MemBus_Address      ;
//	wire [31:0] MemBus_Write_Data   ;
//	wire [31:0] Device_Read_Data    ;
	
	pipecpu cpu1(  
		.reset              (reset              ), 
		.clk1                (clk1                )
//		.MemBus_Address     (MemBus_Address     ),
//		.Device_Read_Data   (Device_Read_Data   ), 
//		.MemBus_Write_Data  (MemBus_Write_Data  ), 
//		.MemRead            (MemRead            ), 
//		.MemWrite           (MemWrite           )
        
        
	);

//	Device device1(  
//		.reset              (reset              ), 
//		.clk                (clk                ), 
//		.MemBus_Address     (MemBus_Address     ),
//		.Device_Read_Data   (Device_Read_Data   ), 
//		.MemBus_Write_Data  (MemBus_Write_Data  ), 
//		.MemRead            (MemRead            ), 
//		.MemWrite           (MemWrite           )
//    );
	
	initial begin
		reset   = 1;
		clk1     = 1;
		#50 reset = 0;
	end
	
	always #100 clk1 = ~clk1;
		
endmodule
