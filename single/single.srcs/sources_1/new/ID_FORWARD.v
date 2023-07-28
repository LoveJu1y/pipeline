`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 23:26:30
// Design Name: 
// Module Name: ID_FORWARD
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


module ID_FORWARD(
    input wire[4:0] id_rs,
    input wire[4:0] id_rt,
    input wire id_branch,
    input wire[1:0] id_pcsrc,
    input wire mem_regwrite,
    input wire[4:0]mem_write_register,
    output reg id_forward1,
    output reg id_forward2
    );
    always@(*)begin
    if(mem_regwrite&& (id_branch==1||id_pcsrc[1]==1)&& mem_write_register!=0 && mem_write_register == id_rs)
        id_forward1 =1'b1;
    else 
        id_forward1 = 0;
        
    if(mem_regwrite &&(id_branch==1 || id_pcsrc[1]==1) && mem_write_register!=0 &&mem_write_register == id_rt)
        id_forward2 = 1'b1;
    else
        id_forward2 = 0;
    end
endmodule
