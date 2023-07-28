`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/22 17:18:36
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input wire clk,
    input wire reset,
    
  //  input wire[31:0]ex_instruction,
    input wire[4:0]ex_write_register,
    input wire ex_regwrite,
    input wire [1:0] ex_regdst,
    input wire[1:0] ex_mem2reg,
    input wire ex_memread,
    input wire ex_memwrite,
    input wire[31:0]ex_alu_out,
    input wire[31:0]ex_pc_plus4,//jr£¬jalrÒªÓÃ¡£
    input wire[4:0]ex_rt,
    input wire[4:0]ex_rd,
    input wire[31:0]ex_databus2,
    
  //  output reg[31:0]mem_instruction,
    output reg[4:0]mem_write_register,
    output reg mem_regwrite,
    output reg[1:0]mem_regdst,
    output reg[1:0]mem_mem2reg,
    output reg mem_memread,
    output reg mem_memwrite,
    output reg [31:0]mem_alu_out,
    output reg[31:0]mem_pc_plus4,
    output reg [4:0]mem_rt,
    output reg [4:0]mem_rd,
    output reg[31:0]mem_databus2
    );
    
    
    always@(posedge clk or posedge reset)
    if(reset)begin
    mem_write_register <=0;
        mem_databus2 <=0;
        mem_regwrite<=0;
        mem_regdst<=0;
        mem_mem2reg<=0;
        mem_memread<=0;
        mem_memwrite<=0;
        mem_alu_out<=0;
        mem_pc_plus4<=0;
        mem_rt<=0;
        mem_rd<=0;
    end
    else begin
        mem_write_register <= ex_write_register;
        mem_databus2<=ex_databus2;
        mem_regwrite<=ex_regwrite;
        mem_regdst<=ex_regdst;
        mem_mem2reg<=ex_mem2reg;
        mem_memread<=ex_memread;
        mem_memwrite<=ex_memwrite;
        mem_alu_out<=ex_alu_out;
        mem_pc_plus4<=ex_pc_plus4;
        mem_rt<=ex_rt;
        mem_rd<=ex_rd;
     //   mem_instruction <=ex_instruction;
        
    end
        
    
endmodule
