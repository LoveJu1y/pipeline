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
       //wire[31:0]if_pc_plus4;�K����Ҫ
       InstructionMemory InstMemory(pc, Instruction);
      
       //wire irq;
      // wire excep_op;
      // wire[31:0]pc_exception;
       //wire[31:0]pc_irq;
       wire[31:0] if_pc_plus4;
       assign if_pc_plus4 = pc + 4;
       //����ȡ��ָ�������һ��ID���ȿ��Ĵ�����Ҫ������Щ������ֻ��Ҫ����ָ�pc+4����
       wire[31:0] id_instruction;//�������ģ�id�׶ε�ָ��
       wire[31:0]id_pc_plus4;//id�׶Σ�pc�Ѿ���4��
       
      wire [4:0] id_rs;
      wire [4:0] id_rt;
      wire [4:0] id_rd;
      wire [4:0] id_shamt;
      wire [5:0] id_funct;
      wire [5:0] id_opcode;
      
       wire if_flush;
       wire stall;
       IF_ID IF_ID_(.if_pc_plus4(if_pc_plus4),.if_flush(if_flush),.stall(stall),.clk(clk),.reset(reset),.pc(pc),.instruction(Instruction),.id_instruction(id_instruction),.id_pc_plus4(id_pc_plus4),.rs(id_rs),.rt(id_rt),.rd(id_rd),.funct(id_funct),.shamt(id_shamt),.opcode(id_opcode));
       
       //���ڵõ���ָ���+4��pc�͸��ֱ���,���Խ��м���ȹ����ˡ�
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
                               
                               
                                
        //����ͨ��opcode��funct��ȡ��Ӧ�õĿ����źš�Ҫ��ȡ����rs֮��ĵ�ַ��ȡ�����ˣ���һ�����ǴӼĴ�����ֵ�������ˡ�
        //������Ҫ�ӼĴ����ж�ȡֵ��Ȼ���ṩ��EX�׶ν��м���
        wire [4:0]id_aluctrl;
        wire id_sign;
        ALUControl ALUControl1(.ALUOp(id_aluop),.Funct(id_funct),.ALUCtl(id_aluctrl),.Sign(id_sign));
       
       
        //RegwRite����һ������WB�׶β��õģ�������Ҫһֱ������ȥ��������Ҫʹ��
        //wire mem_regwrite;�������Ҳ������
        //wire ex_regwrite;������붨���
        wire wb_regwrite;
        
        //read_register1 ����id_rs��
        //read_register2����rt
        //write_registerҪ��������ɣ�������rt��������rd��������Ҫ�±���
        wire[4:0] id_write_register ;//ͬ������Ҫ��WBд�ģ��ʶ���Ҫ����
        wire[4:0] ex_write_register;
        wire[4:0]mem_write_register;
        wire[4:0] wb_write_register;
        assign id_write_register = (id_regdst == 2'b00)?id_rt: (id_regdst == 2'b01)? id_rd: 5'b11111;
        
        wire [31:0]id_databus1_tmp;//�������ͨ·�����ܽ�����λ
        wire [31:0]id_databus2_tmp;//�����
        wire [31:0]id_databus3;     //д�Ĵ�����ͨ·   
        
        wire[31:0]wb_databus3;
        //���ڽ��мĴ�����������Ҫ�Ƕ���д���������׶ΰɣ�
        RegisterFile RegisterFile1(.reset(reset),.clk(clk),
                                    .RegWrite(wb_regwrite),
                                    .Read_register1(id_rs),
                                    .Read_register2(id_rt),
                                    .Write_register(wb_write_register),
                                    .Write_data(wb_databus3),
                                    .Read_data1(id_databus1_tmp),
                                    .Read_data2(id_databus2_tmp));
                     
        //�ȼ����������ɣ���������չ���ܵ����һ���Ǽ����е��޷���ֱ����չ��Ҳ�Ͳ���Ҫ��λ����һ�������Ѱַ��ʱ����Ҫ��λ�����߿����ڼӷ���ʱ����λ��
        wire[15:0] id_imm;
        assign id_imm = id_instruction[15:0];//����������������
        wire[31:0] id_imm_ext1;
        assign id_imm_ext1 = {id_extop?{16{id_imm[15]}}:16'h0000,id_imm};
        wire[31:0] id_imm_ext2;
        assign id_imm_ext2 = id_luop?{id_imm,16'h0000}:id_imm_ext1;
        //����id_imm_ext2���ǳ������������ˣ�һ����˵����һЩ��Ҫλ��2�������õ���ʱ����˵��
        
        //���ڼ���pcѡ��branch��zero��������Ӱ�죬���ԣ�
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
        //����zero��������ˣ������ж�pc��ôȡ��
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
            
       
        //���������ID�׶ε����й��������Խ��м����ˣ�
        //�Ƚ���Ҫʹ�õĶ���������EX�׶ΰ�,�ܽ���ǣ�����õ������ݣ��Ϳ����õĿ����ź�
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
        //û��databus3����Ϊ�ں������assign�л��е�
        wire[4:0]ex_rt;
        wire[4:0]ex_rd;
        wire[4:0]ex_shamt;
        wire[5:0]ex_opcode;
        wire[5:0]ex_funct;
        wire[31:0]ex_pc_plus4;
        wire[4:0]ex_aluctrl;//��ID���ɵĿ����źţ���signһ������alu�л���
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
        wire ex_zero;//��ע�⣬��֮ǰ��ID�׶��Ѿ������Ҫ��֧��ָ���zeroֵ�����Ǹ����ҵ������ģ���ΪIDҪ�õ�pc����next�������zero���ֻ��һ��ָʾ��
        ALU ALU1(.in1(ex_aludata1),.in2(ex_aludata2),.ALUCtl(ex_aluctrl),.Sign(ex_sign),.out(ex_alu_out_tmp),.zero(ex_zero));
        assign ex_alu_out = (ex_mem2reg[1]==0)?ex_alu_out_tmp:ex_pc_plus4;
        
        //���ڵõ��˼�����ex_alu_out�����Խ�����һ����MEM
        
        wire[31:0]mem_instruction;
        wire mem_regwrite;
        wire[1:0]mem_regdst;
        wire[1:0]mem_mem2reg;
        wire mem_memread;
        wire mem_memwrite;
        //wire[31:0]mem_alu_out;ǰ��Ҫת���ã�������ǰ��
        wire[31:0]mem_pc_plus4;
        wire[4:0]mem_rt;
        wire[4:0]mem_rd;
        wire[31:0]mem_databus2;//��Ҫ����swָ������Ҫ�ӼĴ�����ֱ�Ӷ�ȡ���������ֵ
        
        EX_MEM EX_MEM1(.clk(clk),.reset(reset),.ex_databus2(ex_databus2),
                        .ex_regwrite(ex_regwrite),.ex_regdst(ex_regdst),.ex_mem2reg(ex_mem2reg),
                        .ex_memread(ex_memread),.ex_memwrite(ex_memwrite),.ex_alu_out(ex_alu_out),
                        .ex_pc_plus4(ex_pc_plus4),.ex_rt(ex_rt),.ex_rd(ex_rd),
                        .ex_write_register(ex_write_register),
                        .mem_regwrite(mem_regwrite),.mem_regdst(mem_regdst),.mem_mem2reg(mem_mem2reg),
                        .mem_memread(mem_memread),.mem_memwrite(mem_memwrite),.mem_alu_out(mem_alu_out),
                        .mem_pc_plus4(mem_pc_plus4),.mem_rt(mem_rt),.mem_rd(mem_rd) ,
                        .mem_write_register(mem_write_register),.mem_databus2(mem_databus2) );
                        
       
        //��Ϣ���������ˣ���һ����Ҫ��mem��������lw��sw�ɣ�
        wire[31:0]mem_read_data;
        DataMemory DataMemory1(.clk(clk),.reset(reset),.leds(leds),.an(an),
                    .MemRead(mem_memread),.MemWrite(mem_memwrite),
                    .Address(mem_alu_out),.Write_data(mem_databus2),
                    .Read_data(mem_read_data) );
                        
                        
                        
         //ֱ�ӽ�WB�ɣ�ð�մ��������ٿ���
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