module DataMemory(
	input  reset    , 
	input  clk      ,  
	output reg[6:0] leds      ,
	output reg[3:0] an, 
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 1024;
	parameter RAM_SIZE_BIT  = 8;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];
    reg [31:0] ROM_data ;
	// read data from RAM_data as Read_data
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 3:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)
		if (reset)begin
			for (i = 0; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
				
                RAM_data[0]<=32'h00000006;
               // RAM_data[1]<=32'h00000006;0
                RAM_data[2]<=32'h00000009;
                RAM_data[3]<=32'h00000003;
                
                RAM_data[4]<=32'h00000006;
                RAM_data[5]<=32'hffffffff;
                RAM_data[6]<=32'hffffffff;
                //RAM_data[7]<=32'h00000167;0
                
               // RAM_data[8]<=32'h000003c3;
               // RAM_data[9]<=32'h000001d1;
               // RAM_data[10]<=32'h000002c2;
                //RAM_data[11]<=32'h00000092;
                
               // RAM_data[12]<=32'h0000011a;
               // RAM_data[13]<=32'h0000033c;
               //RAM_data[14]<=32'h000003c2;
               // RAM_data[15]<=32'h000001ec;
               
//                RAM_data[16]<=32'h000003e4;
//                RAM_data[17]<=32'h000003af;
//                RAM_data[18]<=32'h0000033c;
//                RAM_data[19]<=32'h000001b5;

//                RAM_data[20]<=32'h00000188;
//                RAM_data[21]<=32'h0000025d;
//                RAM_data[22]<=32'h00000387;
//                RAM_data[23]<=32'h0000009a;

//                RAM_data[24]<=32'h00000125;
//                RAM_data[25]<=32'h0000017f;
//                RAM_data[26]<=32'h000001a6;
//                RAM_data[27]<=32'h000002cd;

//                RAM_data[28]<=32'h000002cf;
//                RAM_data[29]<=32'h00000380;
//                RAM_data[30]<=32'h000001c0;
//                RAM_data[31]<=32'h000002d7;

               // RAM_data[32]<=32'h00000304;
                RAM_data[33]<=32'h00000009;
               // RAM_data[34]<=32'h00000366;
                RAM_data[35]<=32'hffffffff;
               
                RAM_data[36]<=32'h00000003;
                RAM_data[37]<=32'h00000004;
                RAM_data[38]<=32'h00000001;
                //RAM_data[39]<=32'h0000037f;
                
//                RAM_data[40]<=32'h000002c0;
//                RAM_data[41]<=32'h0000032c;
//                RAM_data[42]<=32'h00000143;
//                RAM_data[43]<=32'h0000014e;

//                RAM_data[44]<=32'h000002a2;
//                RAM_data[45]<=32'h00000299;
//                RAM_data[46]<=32'h0000008e;
//                RAM_data[47]<=32'h000002c8;

//                RAM_data[48]<=32'h000000fe;
//                RAM_data[49]<=32'h00000365;
//                RAM_data[50]<=32'h00000224;
//                RAM_data[51]<=32'h00000285;

//                RAM_data[52]<=32'h00000297;
//                RAM_data[53]<=32'h000002f6;
//                RAM_data[54]<=32'h00000026;
//                RAM_data[55]<=32'h0000035c;

//                RAM_data[56]<=32'h000002d4;
//                RAM_data[57]<=32'h000002e6;
//                RAM_data[58]<=32'h00000212;
//                RAM_data[59]<=32'h0000030b;

//                RAM_data[60]<=32'h0000013d;
//                RAM_data[61]<=32'h00000024;
//                RAM_data[62]<=32'h000000bf;
//                RAM_data[63]<=32'h0000034b;

                //RAM_data[64]<=32'h00000121;
                RAM_data[65]<=32'h00000003;
                RAM_data[66]<=32'hffffffff;
                //RAM_data[67]<=32'h000003af;
                
                RAM_data[68]<=32'h00000002;
                RAM_data[69]<=32'hffffffff;
                RAM_data[70]<=32'h00000005;
               // RAM_data[71]<=32'h00000326;
               
//                RAM_data[72]<=32'h0000037b;
//                RAM_data[73]<=32'h000002da;
//                RAM_data[74]<=32'h00000173;
//                RAM_data[75]<=32'h0000015f;

//                RAM_data[76]<=32'h00000007;
//                RAM_data[77]<=32'h00000066;
//                RAM_data[78]<=32'h0000018a;
//                RAM_data[79]<=32'h00000225;

//                RAM_data[80]<=32'h00000276;
//                RAM_data[81]<=32'h00000270;
//                RAM_data[82]<=32'h00000055;
//                RAM_data[83]<=32'h000003bb;

//                RAM_data[84]<=32'h000002f5;
//                RAM_data[85]<=32'h00000349;
//                RAM_data[86]<=32'h000003c7;
//                RAM_data[87]<=32'h00000179;

//                RAM_data[88]<=32'h000003a4;
//                RAM_data[89]<=32'h00000135;
//                RAM_data[90]<=32'h000003b1;
//                RAM_data[91]<=32'h000001b8;

//                RAM_data[92]<=32'h00000273;
//                RAM_data[93]<=32'h00000144;
//                RAM_data[94]<=32'h0000021a;
//                RAM_data[95]<=32'h0000021b;

               // RAM_data[96]<=32'h00000077;
                RAM_data[97]<=32'h00000006;
                RAM_data[98]<=32'h00000003;
                RAM_data[99]<=32'h00000002;
                
                //RAM_data[100]<=32'h00000000;
                RAM_data[101]<=32'h00000006;
                RAM_data[102]<=32'hffffffff;
                
                 RAM_data[129]<=32'hffffffff;
                 RAM_data[130]<=32'h00000004;
                 RAM_data[131]<=32'hffffffff;
                 
                 RAM_data[132]<=32'h00000006;
                 RAM_data[134]<=32'h00000002;
                 
                 RAM_data[161]<=32'hffffffff;
                 RAM_data[162]<=32'h00000001;
                 RAM_data[163]<=32'h00000005;
                 
                 RAM_data[164]<=32'hffffffff;
                 RAM_data[165]<=32'h00000002;
                
                end
		else if (MemWrite && Address==32'h40000010)begin
			ROM_data <= Write_data;
			leds<=Write_data[6:0];
			an<=Write_data[11:8];
        end
        else if (MemWrite )
            RAM_data[Address[RAM_SIZE_BIT + 3:2]] <= Write_data;
			
endmodule
