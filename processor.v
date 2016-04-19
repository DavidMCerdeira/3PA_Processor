`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2016 09:46:33
// Design Name: 
// Module Name: processor
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


module processor(
       input Clk,
       input Rst
    );
    
    IF fetch(
        //General
         .Clk(Clk),
         .Rst(Rst),
        //Branch Unit
         .FlushPipeandPC(),
         .WriteEnable(),
         .CB_o(),
        //Stall Unit
         .PCStall(),    
         .IF_ID_Stall(),
         .IF_ID_Flush(),
         .Imiss(),
        //From Execute 
         .JmpAddr(),
         .JmpInstrAddr(),
        //To Pipeline Registers
         .IR(IR),
         .PC(PC),
         .InstrAddr(IAddr),
         .PCSource(PCSrc),
         .PPCCB(PPCCB)
    
    );
    
    IDControlUnit decode(
         .Clk(Clk),
         .reset(Rst),
         .rf_we(),
         .WAddr(),
         .WData(),
        /*Input pipeline registers from fetch*/
         .iIC(IAddr),
         .iPPCCB(PPCCB),
         .iPC(PC), 
         .iValid(),
         .iIR(IR),
        /*Input to stall or flush*/
         .stall(),
         .flush(),
        /*Output pipeline registers to execute*/
            /*Fowarded from fetch*/
         .oIC(),
         .oPPCCB(),
         .oPC(), 
         .oValid(),
            /*Produced outputs to execute*/
         .oRDS(),
         .oRS1(),
         .oRS2(),
         .oOP1(),
         .oOP2(),
         .oIM(),
       
         .oEX(),   
         .oMA(),
         .oWB()
    );
    
    stageMA MAccesss(
        .clk(Clk),//clock
        .st(Rst),//reset
        .i_ma_WB(),//write_back control signal
        .i_ma_MA(),//memory access control signals
        .i_ma_ALU_rslt(),// resultado da ALU
        .i_ma_Rs2_val(), //valor do regiter source 2
        .i_ma_Rs2_addr(), //endere?o do registo do register source 2
        .i_ma_PC(), //program counter
        .i_ma_Rdst(), //registo de destino
        .i_ma_mux_wb(),//resultado do write back (forwarding)
        .i_OP1_MemS(), //forwrding unit signal
        .i_ma_flush(),
        .i_ma_stall(),
      
        .o_ma_PC(), //program counter para ser colocado no pipeline register MA/WB
        .o_ma_Rds(), //endere�o do registo de sa�da
        .o_ALU_rsl(), //resultado do ALU a ser colocado no pipeline register MA/WB
        .o_ma_WB(), //sinais de controlo da write back a serem colocados no pipeline register MA/WB
        .o_ma_EX_MEM_Rs2(),//colocar o endere�o do source register 2 na forward unit,
        .o_ma_EX_MEM_MA(),
        .o_miss(), // falha no acesso de mem�ria
        .o_ma_mem_out()
    );
    
    stage_wb WBack (
         .clk(Clk), 
         .rst(Rst), 
         .i_wb_pc(), 
         .i_wb_data_o_ma(), // Output from memory
         .i_wb_alu_rslt(), // result of the ALU
         .i_wb_cntrl(),// bits [1:0] slect mux, bit 2 reg_write_rf_in
         .i_wb_rdst(),// input of Rdst
         .o_wb_rdst(),// output of Rdst
         .o_wb_reg_write_rf(),//output of the third input control bit
         .o_wb_mux(),// Data for the input of the register file
         .o_wb_reg_dst_s()// select mux out
    );
    
    FU forward(
       ////////////////////////////ID_EX REG
        .IFex__Need_RS1(),
        .IFex__Need_RS2(),
        .IDex__Need_Rs2(),
        .IDex__Need_Rs1(),
        .IDex__Rs1(),
        .IDex__Rs2(),
       ////////////////////////////EX_MEM REG
        .EXmem__Read_MEM(),
        .EXmem__R_WE(),
        .EXmem__Rdst(),
        .EXmem__RDst_S(),
       ////////////////////////////MEM_WB REG
        .MEMwb__Rdst(),
        .MEMwb__R_WE(),
       ////////////////////////////OUTPUT
        .OP1_ExS(),
        .OP2_ExS(),
        .Need_Stall()
    );
    
endmodule
