`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2016 04:51:15 PM
// Design Name: 
// Module Name: DecodeStage
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

`include "pipelinedefs.v"

module DecodeStage(
    input Clk,
    input reset,
    input rf_we,
    input [4:0] WAddr,
    input [31:0] WData,
    /*Input pipeline registers from fetch*/
    input [`IC_WIDTH-1:0] iIC,
    input [`PPCCB_WIDTH-1:0] iPPCCB,
    input [`PC_WIDTH-1:0] iPC, 
    input [`VALID_WIDTH-1:0] iValid,
    input [`INST_WIDTH-1:0] iIR,
    /*Input to stall or flush*/
    input stall,
    input flush,
    /*Output pipeline registers to execute*/
        /*Fowarded from fetch*/
    output [`IC_WIDTH-1:0] oIC,
    output [`PPCCB_WIDTH-1:0] oPPCCB,
    output [`PC_WIDTH-1:0] oPC, 
    output [`VALID_WIDTH-1:0] oValid,
        /*Produced outputs to execute*/
    output [`RDSADDR_WIDTH-1:0] oRDS,
    output [`RS1ADDR_WIDTH-1:0] oRS1,
    output [`RS2ADDR_WIDTH-1:0] oRS2,
    output [`OP1_WIDTH-1:0] oOP1,
    output [`OP2_WIDTH-1:0] oOP2,
    output [`IM_WIDTH-1:0] oIM,
    
    input iR2Select,
    input [1:0] iSignExtCtrl
    );
    
    wire [`IDEX_WIDTH-1:0] idStageOutBus;
    wire [`IDEX_WIDTH-1:0] oEXStage;
    
    idStage idStage(
    .iIR(iIR),
    .rf_we(rf_we),
    .WAddr(WAddr),
    .WData(WData),

    .woRdsAddr(idStageOutBus[`IDEX_RDSADDR]),
    .woRs1Addr(idStageOutBus[`IDEX_RS1ADDR]),
    .woRs2Addr(idStageOutBus[`IDEX_RS2ADDR]),
    .woOP1(idStageOutBus[`IDEX_OP1]),
    .woOP2(idStageOutBus[`IDEX_OP2]),
    .woIMM(idStageOutBus[`IDEX_IM]),
    /*Normal Clk and reset*/
    .clk(Clk),
    .reset(reset),
    
    .iR2Select(iR2Select),
    .iSignExtCtrl(iSignExtCtrl)
    );
    
    assign idStageOutBus[`IDEX_VALID] = iValid;
    assign idStageOutBus[`IDEX_PC]    = iPC;
    assign idStageOutBus[`IDEX_PPCCB] = iPPCCB;
    assign idStageOutBus[`IDEX_IC]    = iIC;
    
    pipereg #(.WIDTH(`IDEX_WIDTH)) IDEXRegs(
     .clk(Clk),
     .rst(reset),
     .flush(flush),
     .stall(stall),
     .in(idStageOutBus),
     .out(oEXStage)
    );
    
     assign oIC    = oEXStage[`IDEX_IC];
     assign oPPCCB = oEXStage[`IDEX_PPCCB];
     assign oPC    = oEXStage[`IDEX_PC];
     assign oValid = oEXStage[`IDEX_VALID];
     assign oRDS   = oEXStage[`IDEX_RDSADDR];
     assign oRS1   = oEXStage[`IDEX_RS1ADDR];    
     assign oRS2   = oEXStage[`IDEX_RS2ADDR];
     assign oOP1   = oEXStage[`IDEX_OP1];
     assign oOP2   = oEXStage[`IDEX_OP2];
     assign oIM    = oEXStage[`IDEX_IM];
    
endmodule
