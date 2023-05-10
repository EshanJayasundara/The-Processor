module fwd(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #1 out = data2;
endmodule

module add(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #2 out = data1 + data2;
endmodule

module mul(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #1 out = data1 & data2;
endmodule

module orr(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
       #1  out = data1 | data2;
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

module tb;
    reg [7:0] d1, d2;
    reg [2:0] op;
    wire [7:0] out;

    alu dut(.data1(d1), .operation(op), .result(out), .data2(d2));
    //reg [0:4][7:0] operators = {">","+","&","|"};
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,dut);
        $monitor("%b op %b = %b", d1, d2, out);
    end

    initial begin
        op = 0; d1 = 3; d2 = 4;
        // $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        op = 1;
        // $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        op = 2;
        // $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        op = 3;
        // $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        $finish();
    end
endmodule