`include "ALU.v"

module tb;
    reg [7:0] d1, d2;
    reg [2:0] op;
    wire [7:0] out;

    alu dut(.data1(d1), .operation(op), .result(out), .data2(d2));
    reg [0:4][7:0] operators;
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,dut);
    end

    initial begin
        operators[0] = ">";
        operators[1] = "+";
        operators[2] = "&";
        operators[3] = "|";
        // $monitor("%b op %b = %b", d1, operators[op], d2, out); //error
        op = 0; d1 = 3; d2 = 4;
        $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        op = 1;
        $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        op = 2;
        $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        op = 3;
        $display("%b %s %b = %b", d1, operators[op], d2, out);
        #5
        $finish();
    end
endmodule