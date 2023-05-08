module alu(
    input [7:0] data1, data2,
    input [2:0] operation,
    output [7:0] result,
    output co
);

    always @(*) begin
        case (operation)
            3'b000: {co, result} = data2; 
            3'b001: {co, result} = data1 + data2;
            3'b010: {co, result} = data1 & data2;
            3'b011: {co, result} = data1 | data2;
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
        $monitor("%d op %d = %d", d1, d2, result);
    end

    initial begin
        d1 = 3; d2 = 4; op = 1;
        #5
        d1 = 4; d2 = 4; op = 2;
        #5
    end
endmodule