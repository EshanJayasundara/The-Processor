`include "ALU.v"

module tb;
    reg [7:0] d1, d2;
    reg [2:0] op;
    wire [7:0] out;

    alu dut(.data1(d1), .operation(op), .result(out), .data2(d2));
    reg [0:4][7:0] operators;
    
    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0,dut);
    end

    initial begin
        operators[0] = ">";
        operators[1] = "+";
        operators[2] = "&";
        operators[3] = "|";
        op = 0; d1 = 3; d2 = 4;
        #5 $display("%b %s %b = %b", d1, operators[op], d2, out);
        op = 1;
        #5 $display("%b %s %b = %b", d1, operators[op], d2, out);
        op = 2;
        #5 $display("%b %s %b = %b", d1, operators[op], d2, out);
        op = 3;
        #5 $display("%b %s %b = %b", d1, operators[op], d2, out);
        $finish();
    end
endmodule