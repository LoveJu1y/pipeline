`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/24 00:36:09
// Design Name: 
// Module Name: HAZARD
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


module HAZARD(
    input wire[4:0]id_rs,
    input wire[4:0]id_rt,
    input wire[4:0]id_rd,
    input wire id_branch,
    input wire[1:0] id_pcsrc,
    input wire ex_regwrite,
    input wire ex_memread,
    input wire mem_memread,
    input wire if_flush,
    input wire[4:0]ex_write_register,
    input wire[4:0]mem_write_register,
    
    output reg stall
    );
    always@(*)begin
    if(ex_memread && (ex_write_register==id_rs||ex_write_register==id_rt))
        stall = 1;
    else if(ex_regwrite&& (id_branch==1||id_pcsrc[1]==1)&&(ex_write_register==id_rs||ex_write_register==id_rt))
        stall = 1;
    else if((id_branch==1||id_pcsrc[1]==1)&&mem_memread&&(mem_write_register==id_rs||mem_write_register==id_rt)) 
      stall=1;
    else
      stall=0;
      end

endmodule
