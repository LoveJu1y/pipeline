`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/21 16:43:58
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input wire clk,
    input wire reset,
    input wire[31:0] pc,
    input wire[31:0]instruction,
    input wire stall,
    input wire if_flush,
    input wire[31:0]if_pc_plus4,
    
    output reg [31:0]id_instruction,
    output reg [31:0] id_pc_plus4,
    output reg[4:0] rs,
     output reg[4:0] rt,
      output reg[4:0] rd,
       output reg[4:0] shamt,
        output reg[5:0] funct,
        output reg[5:0] opcode
    );
    always@(posedge clk or posedge reset)
    if(reset )begin
     id_instruction <= 0;
           id_pc_plus4 <= 0;
    id_instruction <= 0;
     opcode <= 0;
       rs <= 0;
       rt <= 0;
       rd <= 0;
       shamt <= 0;
       funct <= 0;
     end
    else if(if_flush) begin
     id_instruction <= 0;
        opcode <= 0;
          rs <= 0;
          rt <= 0;
          rd <= 0;
          shamt <= 0;
          funct <= 0;
          id_pc_plus4 <=0;
    end
    else if(~stall) begin
    id_instruction <= instruction;
        id_pc_plus4 <= if_pc_plus4;
        opcode <= instruction[31:26];
        rs <= instruction[25:21];
        rt <= instruction[20:16];
        rd <= instruction[15:11];
        shamt <= instruction[10:6];
        funct <= instruction[5:0];
    end
    //目前没有冒险处理
    
endmodule
