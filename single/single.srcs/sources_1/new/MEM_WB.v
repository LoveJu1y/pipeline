`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/22 22:08:19
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
        input wire clk,
        input wire reset,
        
        //input wire[31:0]mem_instruction,
        input wire[4:0]mem_write_register,
        input wire mem_regwrite,
        input wire[1:0] mem_regdst,
        input wire[1:0] mem_mem2reg,
        input wire[4:0]mem_rt,
        input wire[4:0]mem_rd,
        input wire[31:0] mem_pc_plus4,
        input wire[31:0]mem_alu_out,
        input wire[31:0]mem_read_data,
        
       //output reg[31:0]wb_instruction,
        output reg wb_regwrite,
        output reg[1:0] wb_mem2reg,
        output reg[4:0]wb_write_register,
        output reg [31:0] wb_pc_plus4,
        output reg[31:0]wb_alu_out,
        output reg[31:0]wb_read_data
        
    );
    
    
    always@(posedge clk or posedge reset)
    if(reset)begin
        wb_regwrite <= 0;
        wb_write_register <=0;
    end
    else begin
       // assign IDWrite_register = (IDRegDst == 2'b00)? IDInstruction[20:16]: (IDRegDst == 2'b01)? IDInstruction[15:11]: 5'b11111;
//        case(mem_regdst)
//            2'b00:wb_write_register<=mem_rt;
//            2'b01:wb_write_register<=mem_rd;
//            default wb_write_register<=5'b11111;
//            endcase
        wb_write_register <= mem_write_register;
        wb_regwrite <= mem_regwrite;
        wb_mem2reg <= mem_mem2reg;
        wb_pc_plus4 <= mem_pc_plus4;
        wb_alu_out <= mem_alu_out;
        wb_read_data <= mem_read_data;
        //wb_instruction <= mem_instruction;
    end
    
    
    
endmodule



