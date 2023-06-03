// Computer Architecture (CO224) - Lab
// Design: ALU of the Simple Processor
// Author: Eshan Jayasundara

module fwd(input [7:0] data1, data2, output [7:0] out);
        assign #1 out = data2;
endmodule

module add(input [7:0] data1, data2, output [7:0] out);
        assign #1.9 out = data1 + data2;
endmodule

module ann(input [7:0] data1, data2, output [7:0] out);
        assign #1 out = data1 & data2;
endmodule

module orr(input [7:0] data1, data2, output [7:0] out);
       assign #1 out = data1 | data2;
endmodule

// W = width of input and output busses
module alu #(parameter W = 8)(
    input      [W-1:0] data1, data2,
    input      [2:0] operation,
    output reg [W-1:0] result,
    output reg ZERO
);

    wire [7:0] fwd_out, add_out, and_out, orr_out;

    fwd fwd_dut(.data1(data1), .data2(data2), .out(fwd_out));
    add add_dut(.data1(data1), .data2(data2), .out(add_out));
    ann and_dut(.data1(data1), .data2(data2), .out(and_out));
    orr orr_dut(.data1(data1), .data2(data2), .out(orr_out));

    always @(*) begin
        case (operation)
            3'b000: result = fwd_out;
            3'b001: result = add_out;
            3'b010: result = and_out;
            3'b011: result = orr_out;
        endcase

        if(add_out == 8'b00000000) ZERO = 1'b1;
        else                       ZERO = 1'b0;
    end

endmodule