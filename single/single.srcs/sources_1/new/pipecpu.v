`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/21 16:18:17
// Design Name: 
// Module Name: pipecpu
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


module pipecpu(
    input wire clk1,
    input wire reset,
    output wire [6:0] leds,
    //output wire [7:0] bcd7,
    output wire [3:0] an
    );
    wire clk;
    wire locked;
    clk_wiz_0 clk_wiz(.clk_out1(clk),.reset(reset),.locked(locked),.clk_in1(clk1));
    wire[11:0] digi;
    //assign an = digi[11:8];
    //assign leds = digi[7:0];
    
//     wire clk;
      // CLK CLKController(sysclk, reset, clk);
//       assign clk = sysclk;
       wire [31:0] Instruction;
       reg [31:0] pc;   // PC_IF
       wire [31:0] pc_next;
    
       // IF
       //wire[31:0]if_pc_plus4;並不需要
       InstructionMemory InstMemory(pc, Instruction);
      
       //wire irq;
      // wire excep_op;
      // wire[31:0]pc_exception;
       //wire[31:0]pc_irq;
       wire[31:0] if_pc_plus4;
       assign if_pc_plus4 = pc + 4;
       //现在取到指令，进行下一级ID，先看寄存器需要保存那些东西，只需要保存指令，pc+4即可
       wire[31:0] id_instruction;//读出来的，id阶段的指令
       wire[31:0]id_pc_plus4;//id阶段，pc已经加4了
       
      wire [4:0] id_rs;
      wire [4:0] id_rt;
      wire [4:0] id_rd;
      wire [4:0] id_shamt;
      wire [5:0] id_funct;
      wire [5:0] id_opcode;
      
       wire if_flush;
       wire stall;
       IF_ID IF_ID_(.if_pc_plus4(if_pc_plus4),.if_flush(if_flush),.stall(stall),.clk(clk),.reset(reset),.pc(pc),.instruction(Instruction),.id_instruction(id_instruction),.id_pc_plus4(id_pc_plus4),.rs(id_rs),.rt(id_rt),.rd(id_rd),.funct(id_funct),.shamt(id_shamt),.opcode(id_opcode));
       
       //现在得到了指令和+4的pc和各种变量,可以进行计算等工作了。
       wire[1:0] id_pcsrc;
       wire id_branch;
       wire id_regwrite;
       wire[1:0] id_regdst;
       wire id_memread;
       wire id_memwrite;
       wire[1:0] id_mem2reg;
       wire id_alusrc1;
       wire id_alusrc2;
       wire id_extop;
       wire id_luop;
       wire [3:0] id_aluop;
       
       
       
       
       Control Control1(.OpCode(id_opcode),.Funct(id_funct),
                               .PCSrc(id_pcsrc),.Branch(id_branch),
                               .RegWrite(id_regwrite),.RegDst(id_regdst),
                               .MemRead(id_memread),.MemWrite(id_memwrite),
                               .MemtoReg(id_mem2reg),.ALUSrc1(id_alusrc1),
                               .ALUSrc2(id_alusrc2),.ExtOp(id_extop),
                               .LuOp(id_luop),.ALUOp(id_aluop));
                               
                               
                                
        //现在通过opcode和funct提取了应该的控制信号。要提取的量rs之类的地址提取出来了，下一步就是从寄存器读值并计算了。
        //现在需要从寄存器中读取值，然后提供给EX阶段进行计算
        wire [4:0]id_aluctrl;
        wire id_sign;
        ALUControl ALUControl1(.ALUOp(id_aluop),.Funct(id_funct),.ALUCtl(id_aluctrl),.Sign(id_sign));
       
       
        //RegwRite变量一定是在WB阶段才用的，所以需要一直传递下去，但这里要使用
        //wire mem_regwrite;好买这个也定义了
        //wire ex_regwrite;后面代码定义吧
        wire wb_regwrite;
        
        //read_register1 就是id_rs吧
        //read_register2就是rt
        //write_register要根据情况吧，可能是rt，可能是rd，所以需要新变量
        wire[4:0] id_write_register ;//同样是需要在WB写的，故而需要传递
        wire[4:0] ex_write_register;
        wire[4:0]mem_write_register;
        wire[4:0] wb_write_register;
        assign id_write_register = (id_regdst == 2'b00)?id_rt: (id_regdst == 2'b01)? id_rd: 5'b11111;
        
        wire [31:0]id_databus1_tmp;//最上面的通路，可能进行移位
        wire [31:0]id_databus2_tmp;//下面的
        wire [31:0]id_databus3;     //写寄存器的通路   
        
        wire[31:0]wb_databus3;
        //现在进行寄存器操作（主要是读，写操作在最后阶段吧）
        RegisterFile RegisterFile1(.reset(reset),.clk(clk),
                                    .RegWrite(wb_regwrite),
                                    .Read_register1(id_rs),
                                    .Read_register2(id_rt),
                                    .Write_register(wb_write_register),
                                    .Write_data(wb_databus3),
                                    .Read_data1(id_databus1_tmp),
                                    .Read_data2(id_databus2_tmp));
                     
        //先计算立即数吧，立即数扩展可能的情况一种是计算中的无符号直接扩展，也就不需要移位，另一种在相对寻址的时候，需要移位，或者可以在加法的时候移位，
        wire[15:0] id_imm;
        assign id_imm = id_instruction[15:0];//立即数的是礼物诶
        wire[31:0] id_imm_ext1;
        assign id_imm_ext1 = {id_extop?{16{id_imm[15]}}:16'h0000,id_imm};
        wire[31:0] id_imm_ext2;
        assign id_imm_ext2 = id_luop?{id_imm,16'h0000}:id_imm_ext1;
        //现在id_imm_ext2就是出来的立即数了，一般来说还有一些需要位移2的量，用到的时候再说吧
        
        //现在计算pc选择，branch和zero变量都会影响，所以：
        wire id_zero;
        wire[31:0] id_databus1;
        wire[31:0] id_databus2;
        wire id_forward1;
        wire id_forward2;
        wire[31:0] mem_alu_out;
        assign id_databus1 = (id_forward1==0)?id_databus1_tmp:mem_alu_out;
        assign id_databus2 = (id_forward2==0)?id_databus2_tmp:mem_alu_out;

        Zero zero(.id_databus1(id_databus1),.id_databus2(id_databus2),
                    .id_opcode(id_opcode),.id_zero(id_zero));
        //现在zero计算完毕了，可以判断pc怎么取了
         assign if_flush =(~stall&&id_branch && id_zero || id_pcsrc != 2'b00)?1:0;
//        assign id_zero=(id_branchtype==3'b000)?(id_databus1-id_databus2==0)?1:0:
//                        (id_branchtype==3'b001)?(id_databus1-id_databus2==0)?0:1:
//                        (id_branchtype==3'b010)?(id_databus1<=0)?1:0:
//                        (id_branchtype==3'b011)?(id_databus1>0)?1:0:
//                        (id_branchtype==3'b100)?(id_databus1<0)?1:0
//                        :0;
        wire[31:0] id_pc_branch;
        wire[31:0]signExt;
        assign signExt = {{16{id_instruction[15]}}, id_instruction[15:0]};
        assign id_pc_branch = (id_zero&&id_branch)?(id_pc_plus4 + signExt*4):if_pc_plus4;
        
        wire[31:0] id_pc_jump;
        assign id_pc_jump = {id_pc_plus4[31:28], id_instruction[25:0], 2'b00};
        
        assign pc_next = (~if_flush&&(stall||reset))?pc:(id_pcsrc == 2'b00)? id_pc_branch: (id_pcsrc == 2'b01)? id_pc_jump: id_databus1;
        always @(posedge reset or posedge clk)
                if (reset)
                    pc <= 32'h00400000;
                else
                    pc <= pc_next;
            
       
        //现在完成了ID阶段的所有工作，可以进行计算了！
        //先将需要使用的东西拷贝到EX阶段吧,总结就是，计算得到的数据，和可能用的控制信号
        wire[31:0]ex_instruction;
        wire ex_sign;
        wire ex_branch;
        wire ex_regwrite;
        wire[1:0] ex_regdst;
        wire ex_memread;
        wire ex_memwrite;
        wire[1:0] ex_mem2reg;
        wire ex_alusrc1;
        wire ex_alusrc2;
        wire[31:0]ex_databus1_tmp;
        wire[31:0]ex_databus2_tmp;
        //没有databus3是因为在后面计算assign中会有的
        wire[4:0]ex_rt;
        wire[4:0]ex_rd;
        wire[4:0]ex_shamt;
        wire[5:0]ex_opcode;
        wire[5:0]ex_funct;
        wire[31:0]ex_pc_plus4;
        wire[4:0]ex_aluctrl;//由ID生成的控制信号，和sign一样，在alu中会用
        wire[31:0]ex_imm_ext2;
        wire[4:0]ex_rs;
        ID_EX   ID_EX1(.clk(clk),.reset(reset),.id_regwrite(id_regwrite),.id_aluctrl(id_aluctrl),.id_imm_ext2(id_imm_ext2),
                        .id_branch(id_branch),.id_regdst(id_regdst),.id_memread(id_memread),
                        .id_memwrite(id_memwrite),.id_mem2reg(id_mem2reg),.id_alusrc1(id_alusrc1),
                        .id_alusrc2(id_alusrc2),.id_databus1(id_databus1),.id_databus2(id_databus2),
                        .id_rt(id_rt),.id_rd(id_rd),.id_shamt(id_shamt),
                        .id_opcode(id_opcode),.id_funct(id_funct),.id_pc_plus4(id_pc_plus4),.id_sign(id_sign),.id_write_register(id_write_register),
                        .id_rs(id_rs),.stall(stall),
                        .ex_sign(ex_sign),.ex_branch(ex_branch),.ex_regwrite(ex_regwrite),
                        .ex_regdst(ex_regdst),.ex_memread(ex_memread),.ex_memwrite(ex_memwrite),
                        .ex_mem2reg(ex_mem2reg),.ex_alusrc1(ex_alusrc1),.ex_alusrc2(ex_alusrc2),
                        .ex_databus1(ex_databus1_tmp),.ex_databus2(ex_databus2_tmp),.ex_rt(ex_rt),
                        .ex_rd(ex_rd),.ex_shamt(ex_shamt),.ex_opcode(ex_opcode),
                        .ex_funct(ex_funct),.ex_pc_plus4(ex_pc_plus4),.ex_aluctrl(ex_aluctrl),
                        .ex_imm_ext2(ex_imm_ext2),.ex_write_register(ex_write_register) ,
                        .ex_rs(ex_rs));
        wire[31:0]ex_databus1;
        wire[31:0]ex_databus2;      
        wire[1:0]ex_forward1;
        wire[1:0]ex_forward2;
        //wire[31:0]mem_alu_out;
        assign ex_databus1 = (ex_forward1==2'b01)? wb_databus3:(ex_forward1==2'b10)?mem_alu_out:ex_databus1_tmp;      
        assign ex_databus2 = (ex_forward2==2'b01)? wb_databus3:(ex_forward2==2'b10)?mem_alu_out:ex_databus2_tmp;
        wire[31:0] ex_aludata1;
        wire[31:0] ex_aludata2;
        
        
        assign ex_aludata2 = (ex_alusrc2)?ex_imm_ext2:ex_databus2;
        assign ex_aludata1 = (ex_alusrc1)?{27'h00000,ex_shamt}:ex_databus1;
        
        wire[31:0] ex_alu_out_tmp;
        wire[31:0] ex_alu_out;
        wire ex_zero;//需注意，我之前在ID阶段已经算过需要分支的指令的zero值，但那个是我单独做的，因为ID要得到pc——next，这里的zero大概只是一个指示吧
        ALU ALU1(.in1(ex_aludata1),.in2(ex_aludata2),.ALUCtl(ex_aluctrl),.Sign(ex_sign),.out(ex_alu_out_tmp),.zero(ex_zero));
        assign ex_alu_out = (ex_mem2reg[1]==0)?ex_alu_out_tmp:ex_pc_plus4;
        
        //现在得到了计算结果ex_alu_out，可以进入下一步了MEM
        
        wire[31:0]mem_instruction;
        wire mem_regwrite;
        wire[1:0]mem_regdst;
        wire[1:0]mem_mem2reg;
        wire mem_memread;
        wire mem_memwrite;
        //wire[31:0]mem_alu_out;前面要转发用，定义在前面
        wire[31:0]mem_pc_plus4;
        wire[4:0]mem_rt;
        wire[4:0]mem_rd;
        wire[31:0]mem_databus2;//主要是在sw指令中需要从寄存器中直接读取出来的这个值
        
        EX_MEM EX_MEM1(.clk(clk),.reset(reset),.ex_databus2(ex_databus2),
                        .ex_regwrite(ex_regwrite),.ex_regdst(ex_regdst),.ex_mem2reg(ex_mem2reg),
                        .ex_memread(ex_memread),.ex_memwrite(ex_memwrite),.ex_alu_out(ex_alu_out),
                        .ex_pc_plus4(ex_pc_plus4),.ex_rt(ex_rt),.ex_rd(ex_rd),
                        .ex_write_register(ex_write_register),
                        .mem_regwrite(mem_regwrite),.mem_regdst(mem_regdst),.mem_mem2reg(mem_mem2reg),
                        .mem_memread(mem_memread),.mem_memwrite(mem_memwrite),.mem_alu_out(mem_alu_out),
                        .mem_pc_plus4(mem_pc_plus4),.mem_rt(mem_rt),.mem_rd(mem_rd) ,
                        .mem_write_register(mem_write_register),.mem_databus2(mem_databus2) );
                        
       
        //消息都传过来了，这一步主要是mem操作，有lw和sw吧，
        wire[31:0]mem_read_data;
        DataMemory DataMemory1(.clk(clk),.reset(reset),.leds(leds),.an(an),
                    .MemRead(mem_memread),.MemWrite(mem_memwrite),
                    .Address(mem_alu_out),.Write_data(mem_databus2),
                    .Read_data(mem_read_data) );
                        
                        
                        
         //直接进WB吧，冒险处理后面再看。
         wire[1:0]wb_mem2reg;
         //wire[4:0]wb_write_register;
         wire[31:0]wb_pc_plus4;
         wire[31:0]wb_alu_out;
         wire[31:0]wb_read_data;
         wire[31:0]wb_instruction;
         //assign mem_read_data=(mem_alu_out[30])?mem_read_data2:mem_read_data1;
         MEM_WB MEM_WB1(.mem_write_register(mem_write_register),.clk(clk),.reset(reset),.mem_regwrite(mem_regwrite),
                        .mem_regdst(mem_regdst),.mem_mem2reg(mem_mem2reg),.mem_rt(mem_rt),
                        .mem_rd(mem_rd),.mem_pc_plus4(mem_pc_plus4),.mem_alu_out(mem_alu_out),
                        .mem_read_data(mem_read_data),
                        
                        .wb_regwrite(wb_regwrite),.wb_mem2reg(wb_mem2reg),.wb_write_register(wb_write_register),
                        .wb_pc_plus4(wb_pc_plus4),.wb_alu_out(wb_alu_out),.wb_read_data(wb_read_data) );
        
        assign  wb_databus3 = (wb_mem2reg ==2'b01)?wb_read_data:( wb_mem2reg == 2'b00)?wb_alu_out:wb_pc_plus4;

        EX_FORWARD EX_FORWARD1(.mem_regwrite(mem_regwrite),.mem_write_register(mem_write_register),.ex_rs(ex_rs),.ex_rt(ex_rt),
                                .wb_regwrite(wb_regwrite),.wb_write_register(wb_write_register),.ex_forward1(ex_forward1),.ex_forward2(ex_forward2) );
        ID_FORWARD ID_FORWARD1(.id_rs(id_rs),.id_rt(id_rt),.id_branch(id_branch),
                                .id_pcsrc(id_pcsrc),.mem_regwrite(mem_regwrite),.mem_write_register(mem_write_register),
                                .id_forward1(id_forward1),.id_forward2(id_forward2));
        HAZARD HAZARD1(.id_rs(id_rs),.id_rt(id_rt),.id_rd(id_rd),.id_branch(id_branch),
                        .id_pcsrc(id_pcsrc),.ex_regwrite(ex_regwrite),.ex_memread(ex_memread),
                        .mem_memread(mem_memread),.ex_write_register(ex_write_register),.mem_write_register(mem_write_register),
                        .stall(stall) );
endmodule
