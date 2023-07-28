`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/23 22:34:32
// Design Name: 
// Module Name: EX_FORWARD
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


module EX_FORWARD(
    input wire mem_regwrite,
    input wire[4:0] mem_write_register,
    input wire[4:0] ex_rs,
    input wire[4:0] ex_rt,
    input wire wb_regwrite,
    input wire[4:0]wb_write_register,
    output reg[1:0]ex_forward1,
    output reg[1:0]ex_forward2
    );
    always@(*)begin
    if(mem_regwrite && mem_write_register!=0&& mem_write_register==ex_rs )
    ex_forward1 = 2'b10;
    else if(wb_regwrite &&  wb_write_register!=0&&wb_write_register==ex_rs && (mem_write_register !=ex_rs || mem_regwrite!=1))
    ex_forward1 = 2'b01;
    else
    ex_forward1 = 2'b00;
    
    if(mem_regwrite && mem_write_register!=0&&mem_write_register == ex_rt)
    ex_forward2 = 2'b10;
    else if(wb_regwrite && wb_write_register!=0 &&wb_write_register == ex_rt&&(mem_write_register !=ex_rt ||mem_regwrite !=1))
    ex_forward2 = 2'b01;
    else
    ex_forward2 = 2'b00;
    end
endmodule
