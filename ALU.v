module alu(
    input [7:0] data1, data2,
    input [2:0] operation,
    output reg [7:0] result, 
    output reg co
);

    always @(*) begin
        case (operation)
            3'b000: #1 {co, result} = data2; 
            3'b001: #2 {co, result} = data1 + data2;
            3'b010: #1 {co, result} = data1 & data2;
            3'b011: #1 {co, result} = data1 | data2;
        endcase
    end
    
endmodule

module tb;
    reg [7:0] d1, d2;
    reg [2:0] op;
    wire [7:0] out;
    wire co;

    alu dut(.data1(d1), .operation(op), .result(out), .co(co), .data2(d2));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,dut);
        $monitor("%b op %b = %b %b", d1, d2, co, out);
    end

    initial begin
        op = 0; d1 = 1; d2 = 4;
        #5
        op = 1;
        #5
        op = 2;
        #5
        op = 3;
        #5
        $finish();
    end
endmodule