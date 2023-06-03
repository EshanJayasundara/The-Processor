// Computer Architecture (CO224) - Lab
// Design: control Unit of the Simple Processor
// Author: Eshan Jayasundara

module controlUnit(
    input [7:0] OPCODE,
    output reg MUX1, MUX2, MUX3, WRITE,
    output reg [2:0] ALUOP
);

    always @(*) begin
        case(OPCODE)
            8'b0000_0000: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b1;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            ALUOP = 3'b000;
                          end
            8'b0000_0001: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            ALUOP = 3'b001;
                          end
            8'b0000_0010: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            ALUOP = 3'b010;
                          end
            8'b0000_0011: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            ALUOP = 3'b011;
                          end
            8'b0000_0100: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b1;
                            MUX3  = 1'b0;
                            ALUOP = 3'b001;
                          end
            8'b0000_0101: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            ALUOP = 3'b000;
                          end
            8'b0000_0110: begin
                            WRITE = 1'b0;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b1;
                            ALUOP = 3'b100;
                          end
            8'b0000_0111: begin
                            WRITE = 1'b0;
                            MUX1  = 1'b0;
                            MUX2  = 1'b1;
                            MUX3  = 1'b0;
                            ALUOP = 3'b100;
                          end
        endcase
    end

endmodule