`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/21 23:20:54
// Design Name: 
// Module Name: Zero
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Zero(
    input wire[31:0] id_databus1,
    input wire[31:0] id_databus2,
    input wire[5:0] id_opcode,
    output reg id_zero
    );
      always@(*)
          case (id_opcode)
              6'b000100:id_zero <= (id_databus1 - id_databus2 == 0)?1:0;//beq
              6'b000101:id_zero <= (id_databus1 - id_databus2 == 0)?0:1;//bne
              6'b000110:id_zero <= (id_databus1 - id_databus2 <0);//blez
              6'b000111:id_zero <= ~id_databus1[31];//bgtz
              6'b000001:id_zero <= id_databus1[31];//bltz
              default :id_zero <= 0;
          endcase
    
    
endmodule
