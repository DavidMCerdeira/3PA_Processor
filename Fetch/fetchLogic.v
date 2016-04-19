`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2016 01:48:11 PM
// Design Name: 
// Module Name: fetchLogic
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


module fetchLogic(
    //========================= General
    input Clk,
    input Rst,
    //========================= Hazard UNit
    input FlushPipeandPC,
    input PCStall,
    input IF_ID_Flush,
    input IF_ID_Stall,
    input WriteEnable,
    input [1:0] CB_o,
    output Imiss,
    //========================= From Execute 
    input [31:0] JmpAddr,
    input [31:0] JmpInstrAddr,
    //========================= To Pipeline Registers
    output [31:0] IR,
    output [31:0] PC,
    output [31:0] InstrAddr,
    output PCSource,
    output [31:0] Predict,
    output [1:0] CB
    );
    
   PCUpdate pcupdate(
       .Clk(Clk),
       .Rst(Rst),
       .PC(PC),
       .InstrAddr(InstrAddr),
       .FlushPipeandPC(FlushPipeandPC),
       .PCStall(PCStall),
       .Predict(Predict),
       .PCSource(PCSource),
       .JmpAddr(JmpAddr)
    );
        
    InstrFetch instfetch(
       .Clk(Clk),
       .Rst(Rst),
       .InstrAddr(InstrAddr),
       .IF_ID_Flush(IF_ID_Flush),
       .IF_ID_Stall(IF_ID_Stall),
       .IR(IR),
       .Imiss(Imiss)
    );
    
    wire [33:0] PPC_CB;
    
    PredictCache predictcache(
        .Rst(Rst),
        .Clk(Clk),
        .RAddr(InstrAddr),  
        .WAddr(JmpInstrAddr), 
        .WE(WriteEnable),
        .Instr_new_CB(CB_o),
        .PPC_CB(PPC_CB),
        .Data(JmpAddr),
        .PC_Source(PCSource)
    );
    
   assign CB=PPC_CB[1:0];
   assign Predict=PPC_CB[33:2];

endmodule
