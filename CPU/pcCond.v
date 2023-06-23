module PcCond(
    input P, Q, R, S, T,
    output reg F
);
    wire A;
    And and_dut_sr(.S(S), .T(T), .F(A));
    always @(*) begin
        case ({P,Q,R})
            3'b000: F = A;
            3'b001: F = A;
            3'b010: F = A;
            3'b011: F = 1;
            3'b100: F = 1;
            3'b101: F = 1;
            3'b110: F = 1;
            3'b111: F = 1;
        endcase
    end
endmodule

module And(
    input S, T,
    output reg F
);
    always @(*) begin
        case (S)
            1'b0: F = 0;
            1'b1: F = T;
        endcase
    end
endmodule