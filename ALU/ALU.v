// module fwd(input [7:0] data1, data2, output [7:0] out);
//     assign #2 out = data2;
// endmodule

// module add(input [7:0] data1, data2, output [7:0] out);
//     assign #2 out = data1 + data2;
// endmodule

// module mul(input [7:0] data1, data2, output [7:0] out);
//     assign #1 out = data1 & data2;
// endmodule

// module orr(input [7:0] data1, data2, output [7:0] out);
//     assign #1  out = data1 | data2;
// endmodule

// module alu(
//     input [7:0] data1, data2,
//     input [2:0] operation,
//     output reg [7:0] result
// );
//     wire [7:0] out1, out2, out3, out4;

//     fwd fwd_dut(.data1(data1), .data2(data2), .out(out1));
//     add add_dut(.data1(data1), .data2(data2), .out(out2));
//     mul mul_dut(.data1(data1), .data2(data2), .out(out3));
//     orr orr_dut(.data1(data1), .data2(data2), .out(out4));

//     always @(*) begin
//         case (operation)
//             3'b000: result = out1; 
//             3'b001: result = out2;
//             3'b010: result = out3;
//             3'b011: result = out4;
//         endcase
//     end
// endmodule

module fwd(input [7:0] data1, data2, output reg [7:0] out);
    always @(*) begin
        #1 out = data2;
    end
endmodule

module add(input [7:0] data1, data2, output reg [7:0] out);
    always @(*) begin
        #2 out = data1 + data2;
    end
endmodule

module mul(input [7:0] data1, data2, output reg [7:0] out);
    always @(*) begin
        #1 out = data1 & data2;
    end
endmodule

module orr(input [7:0] data1, data2, output reg [7:0] out);
    always @(*) begin
        #1  out = data1 | data2;
    end
endmodule


module alu(
    input [7:0] data1, data2,
    input [2:0] operation,
    output reg [7:0] result
);
    wire [7:0] out1, out2, out3, out4;

    fwd fwd_dut(.data1(data1), .data2(data2), .out(out1));
    add add_dut(.data1(data1), .data2(data2), .out(out2));
    mul mul_dut(.data1(data1), .data2(data2), .out(out3));
    orr orr_dut(.data1(data1), .data2(data2), .out(out4));

    always @(*) begin
        case (operation)
            3'b000: result = out1; 
            3'b001: result = out2;
            3'b010: result = out3;
            3'b011: result = out4;
        endcase
    end
endmodule