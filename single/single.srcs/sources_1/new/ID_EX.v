`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/22 01:11:15
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input wire clk,
    input wire reset,
    
    //input  wire[31:0]id_instruction,
    input wire[4:0]id_write_register,
    input wire stall,
    input wire id_regwrite,
    input wire id_branch,
    input wire[1:0]id_regdst,
    input wire id_memread,
    input wire id_memwrite,
    input wire[1:0] id_mem2reg,
    input wire id_alusrc1,
    input wire id_alusrc2,
    input wire[31:0] id_databus1,
    input wire[31:0] id_databus2,
    input wire[4:0] id_rs,
   // input wire id_rs,rs应该不需要了，已经有databus1了
    input wire[4:0]id_rt,
    input wire[4:0] id_rd,
    input wire[4:0] id_shamt,
    input wire[5:0] id_opcode,
    input wire[5:0] id_funct,
    input wire[31:0] id_pc_plus4,//因为jal和jalr需要将pc+1存在寄存器、
    input wire[4:0] id_aluctrl,
    input wire[31:0]id_imm_ext2,
    input wire id_sign,
   
    //output reg[31:0]ex_instruction,
    output reg[4:0]ex_rs,
    output reg[4:0]ex_write_register,
    output reg ex_sign,
    output reg ex_branch,//似乎没什么用了
    output reg ex_regwrite,
    output reg[1:0] ex_regdst,
    output reg ex_memread,
    output reg ex_memwrite,
    output reg[1:0] ex_mem2reg,
    output reg ex_alusrc1,
    output reg ex_alusrc2,
    output reg[31:0] ex_databus1,
    output reg[31:0] ex_databus2,
    output reg[4:0] ex_rt,
    output reg[4:0] ex_rd,
    output reg[4:0] ex_shamt,
    output reg[5:0] ex_opcode,//先不管，大概
    output reg[5:0] ex_funct,
    output reg[31:0] ex_pc_plus4,
    output reg[4:0] ex_aluctrl,
    output reg[31:0]ex_imm_ext2
   

    );
    always@(posedge clk or posedge reset)
        if(reset)begin
        ex_rs <=0;
        ex_write_register <=0;
        ex_sign <= 0;
        ex_aluctrl<= 0;
        ex_imm_ext2 <= 0;
          ex_branch <= 0;//似乎没什么用了
           ex_regwrite<= 0;
           ex_regdst<= 0;
           ex_memread<= 0;
           ex_memwrite<= 0;
            ex_mem2reg<= 0;
            ex_alusrc1<= 0;
            ex_alusrc2<= 0;
            ex_databus1<= 0;
            ex_databus2<= 0;
            ex_rt<= 0;
            ex_rd<= 0;
            ex_shamt<= 0;
            ex_opcode<= 0;//先不管，大概
            ex_funct<= 0;
            ex_pc_plus4<= 0;
            end
        else if(stall) begin
         ex_regwrite<= 0;
          ex_regdst<= 0;
          ex_memread<= 0;
          ex_memwrite<= 0;
          ex_write_register<=0;
          
//          ex_write_register <=0;
//          ex_sign <= 0;
//          ex_aluctrl<= 0;
//          ex_imm_ext2 <= 0;
//          ex_branch <= 0;//似乎没什么用了
//          ex_regwrite<= 0;
//          ex_regdst<= 0;
//          ex_memread<= 0;
//          ex_memwrite<= 0;
//          ex_mem2reg<= 0;
//          ex_alusrc1<= 0;
//          ex_alusrc2<= 0;
//          ex_databus1<= 0;
//          ex_databus2<= 0;
//          ex_rt<= 0;
//          ex_rd<= 0;
//          ex_shamt<= 0;
//          ex_opcode<= 0;//先不管，大概
//          ex_funct<= 0;
//          ex_pc_plus4<= 0;
          end
         else begin
         ex_rs<=id_rs;
        // ex_instruction <= id_instruction;
         ex_write_register<=id_write_register;
         ex_sign <= id_sign;
           ex_aluctrl<= id_aluctrl;
               ex_imm_ext2 <= id_imm_ext2;
            ex_branch <= id_branch;//似乎没什么用了
            ex_regwrite<= id_regwrite;
            ex_regdst<= id_regdst;
            ex_memread<= id_memread;
            ex_memwrite<= id_memwrite;
             ex_mem2reg<= id_mem2reg;
             ex_alusrc1<= id_alusrc1;
             ex_alusrc2<= id_alusrc2;
             ex_databus1<= id_databus1;
             ex_databus2<= id_databus2;
             ex_rt<= id_rt;
             ex_rd<= id_rd;
             ex_shamt<= id_shamt;
             ex_opcode<= id_opcode;//先不管，大概
             ex_funct<= id_funct;
             ex_pc_plus4<= id_pc_plus4;
            end
        
    
    
    
    
    
    
    
    
    
    
    
    
endmodule
