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