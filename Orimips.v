`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:25 10/29/2024 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Orimips(
    input clk,
    input reset,
    input [5:0] HWInt,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
    output [31:0] macroscopic_pc
    );
    
    // F zone ////////////////////////////////
    // PC and NPC
    wire [31:0] F_pc;
    wire [31:0] F_npc;
    wire [31:0] F_PCplus8;
    wire pc_en;
    
    // IM
    wire [31:0] F_Instr;
    wire [31:0] F_fixedInstr;
    
    // temp
    wire [31:0] F_temp32;
    wire [4:0] F_temp5;
    wire F_temp1;
    
    // D zone ////////////////////////////////
    // D control
    wire D_RegDst;
    wire [1:0] D_nPC_sel;
    wire D_ExtOp;
    wire D_Regra;
    wire [5:0] D_ALUctr;
    wire [3:0] D_rsTuse;
    wire [3:0] D_rtTuse;
    wire [3:0] D_Tnew;
    
    // GRF(R)
    wire [4:0] D_A1;
    wire [4:0] D_A2;
    wire [4:0] D_A3;
    wire [31:0] D_RD1;
    wire [31:0] D_RD2;
    wire [31:0] D_fixedRD1;
    wire [31:0] D_fixedRD2;
    
    // EXT
    wire [31:0] D_ext32;
    
    // CMP
    wire D_zero;
    wire D_flush;
    wire D_fixedflush;
    
    //others
    wire [31:0] D_PCplus8;
    wire [31:0] D_pc;
    wire [31:0] D_Instr;
    wire [5:0] D_OpCode;
    wire [4:0] D_rs;
    wire [4:0] D_rt;
    wire [4:0] D_rd;
    wire [4:0] D_shamt;
    wire [5:0] D_Funct;
    wire [15:0] D_imm16;
    wire [25:0] D_imm26;
    wire FD_en;
    wire FD_clear;
    wire D_ismult;
    
    // temp
    wire [31:0] D_temp32;
    wire [4:0] D_temp5;
    wire D_temp1;
    
    // E zone ////////////////////////////////
    // E control
    wire E_ALUSrc;
    wire E_start;
    wire E_mffix;
    wire [5:0] E_ALUctr;
    wire [3:0] E_rsTuse;
    wire [3:0] E_rtTuse;
    wire [3:0] E_Tnew;
    
    // ALU
    wire [31:0] E_RD1;
    wire [31:0] E_RD2;
    wire [31:0] E_fixedRD1;
    wire [31:0] E_fixedRD2;
    wire [31:0] E_inputA;
    wire [31:0] E_inputB;
    wire [31:0] E_ALUoutputA;
    // wire E_zero;
    
    // MDU
    wire [31:0] E_MDUoutputA;
    wire E_busy;
    
    // others
    wire [31:0] E_fixedoutputA;
    wire [31:0] E_ext32;
    wire [4:0] E_A3;
    wire [31:0] E_PCplus8;
    wire [31:0] E_pc;
    wire [31:0] E_Instr;
    wire [5:0] E_OpCode;
    wire [4:0] E_rs;
    wire [4:0] E_rt;
    wire [4:0] E_rd;
    wire [4:0] E_shamt;
    wire [5:0] E_Funct;
    wire [15:0] E_imm16;
    wire [25:0] E_imm26;
    wire DE_en;
    wire DE_clear;
    
    // temp
    wire [31:0] E_temp32;
    wire [4:0] E_temp5;
    wire E_temp1;
    
    // M zone ////////////////////////////////
    // M control
    // wire M_MemWrite;
    wire M_cpzfix;
    wire M_cpzWrite;
    wire [5:0] M_ALUctr;
    wire [3:0] M_rsTuse;
    wire [3:0] M_rtTuse;
    wire [3:0] M_Tnew;
    
    // DM
    wire [31:0] M_ALUoutputA;
    wire [31:0] M_RD2;
    wire [31:0] M_fixedRD2;
    wire [31:0] M_data;
    wire [31:0] M_pc;
    
    // others
    wire [31:0] M_CPZoutputA;
    wire [31:0] M_fixedoutputA;
    wire [4:0] M_A3;
    wire [31:0] M_PCplus8;
    wire [31:0] M_Instr;
    wire [5:0] M_OpCode;
    wire [4:0] M_rs;
    wire [4:0] M_rt;
    wire [4:0] M_rd;
    wire [4:0] M_shamt;
    wire [5:0] M_Funct;
    wire [15:0] M_imm16;
    wire [25:0] M_imm26;
    wire EM_en;
    wire EM_clear;
    
    // temp
    wire [31:0] M_temp32;
    wire [4:0] M_temp5;
    wire M_temp1;
    
    // W zone ////////////////////////////////
    // W control
    wire W_MemtoReg;
    wire W_RegWrite;
    wire W_PCtoReg;
    wire [5:0] W_ALUctr;
    wire [3:0] W_rsTuse;
    wire [3:0] W_rtTuse;
    wire [3:0] W_Tnew;
    
    // GRF(W)
    wire [31:0] W_outputA;
    wire [31:0] W_data;
    wire [31:0] W_PCplus8;
    wire [4:0] W_A3;
    wire [31:0] W_WD;
    wire [31:0] W_pc;
    
    // others
    wire [31:0] W_Instr;
    wire [5:0] W_OpCode;
    wire [4:0] W_rs;
    wire [4:0] W_rt;
    wire [4:0] W_rd;
    wire [4:0] W_shamt;
    wire [5:0] W_Funct;
    wire [15:0] W_imm16;
    wire [25:0] W_imm26;
    wire MW_en;
    wire MW_clear;
    
    // temp
    wire [31:0] W_temp32;
    wire [4:0] W_temp5;
    wire W_temp1;
    
    // forward ///////////////////////////////
    wire E_isPCplus8;
    wire M_isPCplus8;
    
    wire D_RD1_from_E;
    wire D_RD2_from_E;
    
    wire D_RD1_from_M;
    wire D_RD2_from_M;
    wire E_RD1_from_M;
    wire E_RD2_from_M;
    
    wire D_RD1_from_M_PCplus8;
    wire D_RD2_from_M_PCplus8;
    wire E_RD1_from_M_PCplus8;
    wire E_RD2_from_M_PCplus8;
    
    wire D_RD1_from_W;
    wire D_RD2_from_W;
    wire E_RD1_from_W;
    wire E_RD2_from_W;
    wire M_RD2_from_W;
    
    // stall /////////////////////////////////
    wire D_stall;
    
    // error /////////////////////////////////
    wire Req;
    wire [31:0] EPC;
    
    wire D_eret;
    wire E_eret;
    wire M_eret;
    wire W_eret;
    
    wire D_isjump;
    wire F_BDIn;
    wire D_BDIn;
    wire E_BDIn;
    wire M_BDIn;
    wire W_BDIn;
    
    wire [4:0] F_ExcCode;
    wire [4:0] D_ExcCode;
    wire [4:0] E_ExcCode;
    wire [4:0] M_ExcCode;
    wire [4:0] W_ExcCode;
    
    wire [4:0] D_floatExcCode;
    wire [4:0] E_floatExcCode;
    wire [4:0] M_floatExcCode;
    wire [4:0] W_floatExcCode;
    
    wire [4:0] F_fixedExcCode;
    wire [4:0] D_fixedExcCode;
    wire [4:0] E_fixedExcCode;
    wire [4:0] M_fixedExcCode;
    wire [4:0] W_fixedExcCode;
    
    
    // F zone ////////////////////////////////
    PC PC (.clk(clk), .en(pc_en), .reset(reset), .inputPC(F_npc), .outputPC(F_pc));
    NPC NPC (.PC(F_pc), .nPC_sel(D_nPC_sel), .zero(D_zero), .EPC(EPC), .imm16(D_imm16), 
             .imm26(D_imm26), .GRF(D_fixedRD1), .PCplus8(F_PCplus8), .NPC(F_npc), .Req(Req), .eret(D_eret));
    // IM IM (.addr(F_pc), .data(F_Instr));
    
    FDreg FDreg (.clk(clk), .en(FD_en), .reset(reset), .F_Instr(F_fixedInstr), 
                 .F_PCplus8(F_PCplus8), .D_Instr(D_Instr), .D_PCplus8(D_PCplus8), 
                 .F_pc(F_pc), .D_pc(D_pc), .clear(FD_clear), .F_ExcCode(F_fixedExcCode), .D_ExcCode(D_floatExcCode),
                 .F_BDIn(F_BDIn), .D_BDIn(D_BDIn), .Req(Req), .flush(D_fixedflush),
                 .F_temp32(F_temp32), .F_temp5(F_temp5), .F_temp1(F_temp1), .D_temp32(D_temp32), .D_temp5(D_temp5), .D_temp1(temp1));

    // D zone ////////////////////////////////
    Dcontrol Dcontrol (.OpCode(D_OpCode), .Funct(D_Funct), .rs(D_rs), .RegDst(D_RegDst), 
                       .nPC_sel(D_nPC_sel), .ExtOp(D_ExtOp), .Regra(D_Regra), .ALUctr(D_ALUctr), 
                       .rsTuse(D_rsTuse), .rtTuse(D_rtTuse), .Tnew(D_Tnew), .ExcCode(D_ExcCode));
    GRF GRF (.clk(clk), .reset(reset), .WE(W_RegWrite), .A1(D_A1), .A2(D_A2),
             .A3(W_A3), .WD(W_WD), .PC(W_pc), .RD1(D_RD1), .RD2(D_RD2));
    EXT EXT (.imm16(D_imm16), .ExtOp(D_ExtOp), .ext32(D_ext32));
    CMP CMP (.D_type(D_ALUctr), .D_fixedRD1(D_fixedRD1), .D_fixedRD2(D_fixedRD2), .D_zero(D_zero), 
             .D_flush(D_flush));
    
    DEreg DEreg (.clk(clk), .en(DE_en), .reset(reset), .D_fixedRD1(D_fixedRD1), 
                 .D_fixedRD2(D_fixedRD2), .D_ext32(D_ext32), .D_A3(D_A3), 
                 .D_PCplus8(D_PCplus8), .D_pc(D_pc), .E_RD1(E_RD1), .E_RD2(E_RD2), 
                 .E_ext32(E_ext32), .E_A3(E_A3), .E_PCplus8(E_PCplus8), .E_pc(E_pc), 
                 .D_Instr(D_Instr), .E_Instr(E_Instr), .clear(DE_clear), .D_ExcCode(D_fixedExcCode), .E_ExcCode(E_floatExcCode),
                 .D_BDIn(D_BDIn), .E_BDIn(E_BDIn), .Req(Req),  
                 .D_temp32(D_temp32), .D_temp5(D_temp5), .D_temp1(D_temp1), .E_temp32(D_temp32), .E_temp5(D_temp5), .E_temp1(E_temp1));

    // E zone ////////////////////////////////
    Econtrol Econtrol (.OpCode(E_OpCode), .Funct(E_Funct), .rs(E_rs), .ALUSrc(E_ALUSrc), .start(E_start), .mffix(E_mffix), 
                       .ALUctr(E_ALUctr), .rsTuse(E_rsTuse), .rtTuse(E_rtTuse), .Tnew(E_Tnew));
    ALU ALU (.inputA(E_inputA), .inputB(E_inputB), .type(E_ALUctr), .outputA(E_ALUoutputA), .ExcCode(E_ExcCode));
    MDU MDU (.clk(clk), .reset(reset), .inputA(E_inputA), .inputB(E_inputB), .type(E_ALUctr), .start(E_start), 
             .outputA(E_MDUoutputA), .busy(E_busy), .Req(Req));
             
    EMreg EMreg (.clk(clk), .en(EM_en), .reset(reset), .E_outputA(E_fixedoutputA), 
                 .E_fixedRD2(E_fixedRD2), .E_A3(E_A3), .E_PCplus8(E_PCplus8), 
                 .E_pc(E_pc), .M_outputA(M_ALUoutputA), .M_RD2(M_RD2), .M_A3(M_A3), 
                 .M_PCplus8(M_PCplus8), .M_pc(M_pc), .E_Instr(E_Instr), .M_Instr(M_Instr), 
                 .clear(EM_clear), .E_ExcCode(E_fixedExcCode), .M_ExcCode(M_floatExcCode), .E_BDIn(E_BDIn), .M_BDIn(M_BDIn), .Req(Req), 
                 .E_temp32(E_temp32), .E_temp5(E_temp5), .E_temp1(E_temp1), .M_temp32(M_temp32), .M_temp5(M_temp5), .M_temp1(M_temp1));

    // M zone ////////////////////////////////
    Mcontrol Mcontrol (.OpCode(M_OpCode), .Funct(M_Funct), .rs(M_rs), .cpzfix(M_cpzfix), .cpzWrite(M_cpzWrite), .ALUctr(M_ALUctr), 
                       .rsTuse(M_rsTuse), .rtTuse(M_rtTuse), .Tnew(M_Tnew));
    // DM DM (.clk(clk), .reset(reset), .WE(M_MemWrite), .addr(M_ALUoutputA), .WD(M_fixedRD2),
           // .PC(M_pc), .data(M_data));
    BE BE (.addr(M_ALUoutputA), .data(M_fixedRD2), .type(M_ALUctr), .byteen(m_data_byteen), .fixed_data(m_data_wdata), .Req(Req));
    DE DE (.addr(M_ALUoutputA), .data(m_data_rdata), .type(M_ALUctr), .fixed_data(M_data));
    CP0 CP0 (.clk(clk), .reset(reset), .WE(M_cpzWrite), .addr(M_rd), .WD(M_fixedRD2), .data(M_CPZoutputA), 
             .VPC(M_pc), .BDIn(M_BDIn), .ExcCodeIn(M_fixedExcCode), .HWInt(HWInt), .EXLClr(M_eret), .EPCOut(EPC), .Req(Req));
    
    MWreg MWreg (.clk(clk), .en(MW_en), .reset(reset), .M_outputA(M_fixedoutputA), .M_data(M_data), 
                 .M_A3(M_A3), .M_PCplus8(M_PCplus8), .M_pc(M_pc), .M_Instr(M_Instr), 
                 .W_outputA(W_outputA), .W_data(W_data), .W_A3(W_A3), .W_PCplus8(W_PCplus8), 
                 .W_pc(W_pc), .W_Instr(W_Instr), .clear(MW_clear), .M_ExcCode(M_fixedExcCode), .W_ExcCode(W_floatExcCode),
                 .M_BDIn(M_BDIn), .W_BDIn(W_BDIn), .Req(Req), 
                 .M_temp32(M_temp32), .M_temp5(M_temp5), .M_temp1(M_temp1), .W_temp32(W_temp32), .W_temp5(W_temp5), .W_temp1(W_temp1));

    // W zone ////////////////////////////////
    Wcontrol Wcontrol (.OpCode(W_OpCode), .Funct(W_Funct), .rs(W_rs), .MemtoReg(W_MemtoReg), 
                       .RegWrite(W_RegWrite), .PCtoReg(W_PCtoReg), .ALUctr(W_ALUctr), 
                       .rsTuse(W_rsTuse), .rtTuse(W_rtTuse), .Tnew(W_Tnew));



    // F zone ////////////////////////////////
    
    assign pc_en = (D_stall && ~Req) ? 1'b0 : 1'b1;
    assign F_fixedInstr = (F_ExcCode) ? 32'h00000000 : F_Instr;
    
    assign i_inst_addr = F_pc;
    assign F_Instr = i_inst_rdata;
    
    // D zone ////////////////////////////////
    assign D_OpCode = D_Instr[31:26];
    assign D_rs = D_Instr[25:21];
    assign D_rt = D_Instr[20:16];
    assign D_rd = D_Instr[15:11];
    assign D_shamt = D_Instr[10:6];
    assign D_Funct = D_Instr[5:0];
    assign D_imm16 = D_Instr[15:0];
    assign D_imm26 = D_Instr[25:0];
    
    assign D_A1 = D_rs;
    assign D_A2 = D_rt;
    assign D_A3 = (D_Regra) ? 5'b11111 :
                  (D_RegDst) ? D_rd : D_rt;

    assign D_fixedRD1 = (D_RD1_from_E) ? E_PCplus8 :
                        (D_RD1_from_M) ? M_ALUoutputA :
                        (D_RD1_from_M_PCplus8) ? M_PCplus8 : 
                        (D_RD1_from_W) ? W_WD : D_RD1;
    assign D_fixedRD2 = (D_RD2_from_E) ? E_PCplus8 :
                        (D_RD2_from_M) ? M_ALUoutputA :
                        (D_RD2_from_M_PCplus8) ? M_PCplus8 : 
                        (D_RD2_from_W) ? W_WD : D_RD2;

    assign FD_en = (D_stall) ? 1'b0 : 1'b1;
    assign FD_clear = 1'b0;

    // E zone ////////////////////////////////
    assign E_OpCode = E_Instr[31:26];
    assign E_rs = E_Instr[25:21];
    assign E_rt = E_Instr[20:16];
    assign E_rd = E_Instr[15:11];
    assign E_shamt = E_Instr[10:6];
    assign E_Funct = E_Instr[5:0];
    assign E_imm16 = E_Instr[15:0];
    assign E_imm26 = E_Instr[25:0];
    
    assign E_inputA = E_fixedRD1;
    assign E_inputB = (E_ALUSrc) ? E_ext32 : E_fixedRD2;
    assign E_fixedoutputA = (E_mffix) ? E_MDUoutputA : E_ALUoutputA;
    
    assign E_fixedRD1 = (E_RD1_from_M) ? M_ALUoutputA :
                        (E_RD1_from_M_PCplus8) ? M_PCplus8 : 
                        (E_RD1_from_W) ? W_WD : E_RD1;
    assign E_fixedRD2 = (E_RD2_from_M) ? M_ALUoutputA :
                        (E_RD2_from_M_PCplus8) ? M_PCplus8 : 
                        (E_RD2_from_W) ? W_WD : E_RD2;

    assign DE_en = 1'b1;
    assign DE_clear = (D_stall) ? 1'b1 : 1'b0;
    
    // M zone ////////////////////////////////
    assign M_OpCode = M_Instr[31:26];
    assign M_rs = M_Instr[25:21];
    assign M_rt = M_Instr[20:16];
    assign M_rd = M_Instr[15:11];
    assign M_shamt = M_Instr[10:6];
    assign M_Funct = M_Instr[5:0];
    assign M_imm16 = M_Instr[15:0];
    assign M_imm26 = M_Instr[25:0];
    
    assign M_fixedoutputA = (M_cpzfix) ? M_CPZoutputA : M_ALUoutputA;
    
    assign M_fixedRD2 = (M_RD2_from_W) ? W_WD : M_RD2;

    assign EM_en = 1'b1;
    assign EM_clear = 1'b0;
    
    assign m_data_addr = M_ALUoutputA;
    assign m_inst_addr = M_pc;
    assign macroscopic_pc = M_pc;
    
    // W zone ////////////////////////////////
    assign W_OpCode = W_Instr[31:26];
    assign W_rs = W_Instr[25:21];
    assign W_rt = W_Instr[20:16];
    assign W_rd = W_Instr[15:11];
    assign W_shamt = W_Instr[10:6];
    assign W_Funct = W_Instr[5:0];
    assign W_imm16 = W_Instr[15:0];
    assign W_imm26 = W_Instr[25:0];
    
    assign W_WD = (W_PCtoReg) ? W_PCplus8 :
                  (W_MemtoReg) ? W_data : W_outputA;

    assign MW_en = 1'b1;
    assign MW_clear = 1'b0;
    
    assign w_grf_we = W_RegWrite;
    assign w_grf_addr = W_A3;
    assign w_grf_wdata = W_WD;
    assign w_inst_addr = W_pc;

    // forward ///////////////////////////////
    assign E_isPCplus8 = (E_ALUctr == 6'b000111);
    assign M_isPCplus8 = (M_ALUctr == 6'b000111);
    
    assign D_RD1_from_E = (E_isPCplus8 && E_A3 != 5'b00000 && D_rs == E_A3 && D_rsTuse != 4'hf && E_Tnew != 4'hf && D_rsTuse >= E_Tnew) ? 1'b1 : 1'b0;
    assign D_RD2_from_E = (E_isPCplus8 && E_A3 != 5'b00000 && D_rt == E_A3 && D_rsTuse != 4'hf && E_Tnew != 4'hf && D_rtTuse >= E_Tnew) ? 1'b1 : 1'b0;
    
            //(M_type != JAL)
    assign D_RD1_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 && D_rs == M_A3 && D_rsTuse != 4'hf && M_Tnew != 4'hf && D_rsTuse >= M_Tnew) ? 1'b1 : 1'b0;
    assign D_RD2_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 && D_rt == M_A3 && D_rtTuse != 4'hf && M_Tnew != 4'hf && D_rtTuse >= M_Tnew) ? 1'b1 : 1'b0;
    assign E_RD1_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 && E_rs == M_A3 && E_rsTuse != 4'hf && M_Tnew != 4'hf && E_rsTuse >= M_Tnew) ? 1'b1 : 1'b0;
    assign E_RD2_from_M = (~M_isPCplus8 && M_A3 != 5'b00000 && E_rt == M_A3 && E_rtTuse != 4'hf && M_Tnew != 4'hf && E_rtTuse >= M_Tnew) ? 1'b1 : 1'b0;
    
            //(M_type == JAL)
    assign D_RD1_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 && D_rs == M_A3 && D_rsTuse != 4'hf && M_Tnew != 4'hf && D_rsTuse >= M_Tnew) ? 1'b1 : 1'b0;
    assign D_RD2_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 && D_rt == M_A3 && D_rtTuse != 4'hf && M_Tnew != 4'hf && D_rtTuse >= M_Tnew) ? 1'b1 : 1'b0;
    assign E_RD1_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 && E_rs == M_A3 && E_rsTuse != 4'hf && M_Tnew != 4'hf && E_rsTuse >= M_Tnew) ? 1'b1 : 1'b0;
    assign E_RD2_from_M_PCplus8 = (M_isPCplus8 && M_A3 != 5'b00000 && E_rt == M_A3 && E_rtTuse != 4'hf && M_Tnew != 4'hf && E_rtTuse >= M_Tnew) ? 1'b1 : 1'b0;
    
    assign D_RD1_from_W = (W_A3 != 5'b00000 && D_rs == W_A3 && D_rsTuse != 4'hf && W_Tnew != 4'hf && D_rsTuse >= W_Tnew) ? 1'b1 : 1'b0;
    assign D_RD2_from_W = (W_A3 != 5'b00000 && D_rt == W_A3 && D_rtTuse != 4'hf && W_Tnew != 4'hf && D_rtTuse >= W_Tnew) ? 1'b1 : 1'b0;
    assign E_RD1_from_W = (W_A3 != 5'b00000 && E_rs == W_A3 && E_rsTuse != 4'hf && W_Tnew != 4'hf && E_rsTuse >= W_Tnew) ? 1'b1 : 1'b0;
    assign E_RD2_from_W = (W_A3 != 5'b00000 && E_rt == W_A3 && E_rtTuse != 4'hf && W_Tnew != 4'hf && E_rtTuse >= W_Tnew) ? 1'b1 : 1'b0;
    assign M_RD2_from_W = (W_A3 != 5'b00000 && M_rt == W_A3 && M_rtTuse != 4'hf && W_Tnew != 4'hf && M_rtTuse >= W_Tnew) ? 1'b1 : 1'b0;
    
    // stall /////////////////////////////////
    assign D_ismult = (D_ALUctr == 6'b010101 || D_ALUctr == 6'b010110 || D_ALUctr == 6'b010111 || D_ALUctr == 6'b011000 || 
                       D_ALUctr == 6'b011001 || D_ALUctr == 6'b011010 || D_ALUctr == 6'b011011 || D_ALUctr == 6'b011100) ? 1'b1 : 1'b0;
    
    assign D_stall = (E_A3 != 5'b00000 && D_rs == E_A3 && D_rsTuse != 4'hf && E_Tnew != 4'hf && D_rsTuse < E_Tnew) ? 1'b1 :
                     (E_A3 != 5'b00000 && D_rt == E_A3 && D_rtTuse != 4'hf && E_Tnew != 4'hf && D_rtTuse < E_Tnew) ? 1'b1 :
                     (M_A3 != 5'b00000 && D_rs == M_A3 && D_rsTuse != 4'hf && M_Tnew != 4'hf && D_rsTuse < M_Tnew) ? 1'b1 :
                     (M_A3 != 5'b00000 && D_rt == M_A3 && D_rtTuse != 4'hf && M_Tnew != 4'hf && D_rtTuse < M_Tnew) ? 1'b1 :
                     (W_A3 != 5'b00000 && D_rs == W_A3 && D_rsTuse != 4'hf && W_Tnew != 4'hf && D_rsTuse < W_Tnew) ? 1'b1 :
                     (W_A3 != 5'b00000 && D_rt == W_A3 && D_rtTuse != 4'hf && W_Tnew != 4'hf && D_rtTuse < W_Tnew) ? 1'b1 : 
                     (D_ismult && (E_start || E_busy)) ? 1'b1 : 
                     (D_eret && E_ALUctr == 6'b011110 && E_rd == 5'b01110) ? 1'b1 : 
                     (D_eret && M_ALUctr == 6'b011110 && M_rd == 5'b01110) ? 1'b1 : 1'b0;
    
    // error /////////////////////////////////
    assign D_eret = (D_ALUctr == 6'b100000) ? 1'b1 : 1'b0;
    assign E_eret = (E_ALUctr == 6'b100000) ? 1'b1 : 1'b0;
    assign M_eret = (M_ALUctr == 6'b100000) ? 1'b1 : 1'b0;
    assign W_eret = (W_ALUctr == 6'b100000) ? 1'b1 : 1'b0;
    
    assign D_isjump = (D_ALUctr == 6'b000101 || D_ALUctr == 6'b001001 || D_ALUctr == 6'b000111 || D_ALUctr == 6'b001000 || D_ALUctr == 6'b001010);
    assign F_BDIn = (D_isjump) ? 1'b1 : 1'b0;
    
    assign F_ExcCode = (((F_pc[1:0] != 2'b0) || !(F_pc >= 32'h00003000 && F_pc < 32'h00007000)) && ~D_eret) ? 5'b00100 : 5'b00000;
    
    assign F_fixedExcCode = F_ExcCode;
    assign D_fixedExcCode = (D_floatExcCode) ? D_floatExcCode : D_ExcCode;
    assign E_fixedExcCode = (E_floatExcCode) ? E_floatExcCode : E_ExcCode;
    assign M_fixedExcCode = M_floatExcCode;
    assign W_fixedExcCode = W_floatExcCode;

    assign D_fixedflush = (D_flush & (~D_stall)) ? 1'b1 : 1'b0;
    
endmodule
