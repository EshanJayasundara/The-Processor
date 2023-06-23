// Computer Architecture (CO224) - Lab
// Design: CPU of the Simple Processor
// Author: Eshan Jayasundara, Sasindu Dilshan

`timescale 1ns/100ps

`include "alu.v"
`include "controlUnit.v"
`include "regFile.v"
`include "pcCond.v"

module Cpu (
    input  [31:0] INSTRUCTION,
    input  CLK, RESET,
    input  [7:0] READ_DATA,
    input  BUSYWAIT,
    output reg signed [31:0] PC,
    output WRITEEN, READEN,
    output [7:0] ADDRESS, WRITE_DATA
);
    parameter W = 8, N = 8;

    wire [W-1:0] OUT1,OUT2, ALU_OUT;
    reg  [W-1:0] IN, IN1, IN2, OPCODE, mux2out, OUT, mux4out;
    reg  [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS;
    wire [2:0] ALUOP;
    wire WRITE, ZERO, mux1, mux2, mux3, mux4;

    RegFile #(.W(W), .N(N)) RegFile_dut (.IN(mux4out), 
                                           .OUT1(OUT1), 
                                           .OUT2(OUT2), 
                                           .INADDRESS(INADDRESS), 
                                           .OUT1ADDRESS(OUT1ADDRESS),
                                           .OUT2ADDRESS(OUT2ADDRESS),
                                           .WRITE(WRITE),
                                           .CLK(CLK),
                                           .RESET(RESET)
                                           );
    assign WRITE_DATA = OUT1;

    ControlUnit ControlUnit_dut(.INSTRUCTION(INSTRUCTION),
                                .MUX1(mux1),
                                .MUX2(mux2),
                                .MUX3(mux3),
                                .MUX4(mux4),
                                .ALUOP(ALUOP),
                                .WRITE(WRITE),
                                .READEN(READEN),
                                .WRITEEN(WRITEEN),
                                .BUSYWAIT(BUSYWAIT)
                                );

    Alu #(.W(8)) Alu_dut(.data1(OUT1),
                         .operation(ALUOP),
                         .result(ALU_OUT),
                         .data2(IN2),
                         .ZERO(ZERO)
                         );
    assign ADDRESS = ALU_OUT;

    // Decoder
    always @(*) begin
        #1
        OPCODE      = INSTRUCTION[31:24];
        OUT1ADDRESS = INSTRUCTION[10: 8];
        OUT2ADDRESS = INSTRUCTION[ 2: 0];
        INADDRESS   = INSTRUCTION[18:16];
    end

    //MUX 4 for select aluout or data_mem_out
    always @(*) begin
        if(mux4) begin
            #1
            mux4out = READ_DATA;
        end else begin
            mux4out = ALU_OUT;
        end
    end

    // MUX 2 for selecting subtracting or addition
    always @(*) begin
        if(mux2) begin
            #1
            mux2out = ~OUT2 + 'b1;
        end else begin
            mux2out = OUT2;
        end
    end
    
    // MUX 1 for selecting immediate or register file output 2
    always @(*) begin
        if(mux1) begin
            IN2 = INSTRUCTION[7:0];
        end else begin
            IN2 = mux2out;
        end
    end

    wire F;
    PcCond PcCond_dut(.P(mux3 == 1'b1), .Q(INSTRUCTION[26:24] == 3'b111), .R(ZERO == 1'b1), .S(INSTRUCTION[27:24] == 4'b1000), .T(ZERO == 1'b0), .F(F));


    //Program Counter
    wire signed [22:0] signBits = {22{INSTRUCTION[23]}};
    wire signed [31:0] target = {signBits, INSTRUCTION[23:16], 2'b00};
  
    always @(posedge CLK) begin
        if(RESET == 1'b1) #1 PC <= 0;
        else begin
            if(F) #1 PC <= PC + target + 4;
            else if(BUSYWAIT) PC <= PC;
            else #1 PC <= PC+4;
        end
    end

endmodule