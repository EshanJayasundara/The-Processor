// Computer Architecture (CO224) - Lab
// Design: ALU of the Simple Processor
// Author: Eshan Jayasundara, Sasindu Dilshan

`timescale 1ns/100ps
`include "mult.v"  // reference to mult module
`include "shift.v" // reference to shift module

module Fwd(input [7:0] data1, data2, output [7:0] out); // forward module is for forwarding the data at data2 to alu result
        assign #1 out = data2;
endmodule

module Add(input [7:0] data1, data2, output [7:0] out); // add module is for adding the data1 and data2 and to put the addition into alu result
        assign #1.9 out = data1 + data2;
endmodule

module Ann(input [7:0] data1, data2, output [7:0] out); // ann module is for performing and operation to data1 and data2 and to put the answer into alu result
        assign #1 out = data1 & data2;
endmodule

module Orr(input [7:0] data1, data2, output [7:0] out); // orr module is for perform or operation on data1 and data2 and to put the answer into alu result
       assign #1 out = data1 | data2;
endmodule

// W = width of input and output busses
module Alu #(parameter W = 8)(
    input      [W-1:0] data1, data2,
    input      [2:0] operation,
    output reg [W-1:0] result,
    output reg ZERO
);

    wire [7:0] fwd_out, add_out, and_out, orr_out, mul_out, lsft_out, rsft_out;

    Fwd fwd_dut(.data1(data1), .data2(data2), .out(fwd_out)); // instantiation of fwd_dut (fwd module type)
    Add add_dut(.data1(data1), .data2(data2), .out(add_out)); // instantiation of add_dut (add module type)
    Ann and_dut(.data1(data1), .data2(data2), .out(and_out)); // instantiation of and_dut (and module type)
    Orr orr_dut(.data1(data1), .data2(data2), .out(orr_out)); // instantiation of orr_dut (orr module type)
    Mult #(8) mul_dut(.MULTIPLICAND(data1), .MULTIPLIER(data2), .OUT(mul_out)); // instantiation of mult_dut (Mult module type)
    LeftShift lsft_dut(.D1(data1), .D2(data2), .OutPut(lsft_out)); // instantiation of lsft_dut (LeftShift module type)
    RightShift rsft_dut(.D1(data1), .D2(data2), .OutPut(rsft_out)); // instantiation of rsft_dut (RightShift module type)

    // MUX to select the pertaining operation base on ALUOP signal
    always @(*) begin
        case (operation)
            3'b000: result = fwd_out;
            3'b001: result = add_out;
            3'b010: result = and_out;
            3'b011: result = orr_out;
            3'b100: result = mul_out;
            3'b101: result = lsft_out;
            3'b110: result = rsft_out;
        endcase

        // ZERO signal is for jump and beq instructions
        if(add_out == 8'b00000000) ZERO = 1'b1;
        else                       ZERO = 1'b0;
    end

endmodule