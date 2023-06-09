// Computer Architecture (CO224) - Lab
// Design: control Unit of the Simple Processor
// Author: Eshan Jayasundara

`timescale 1ns/100ps

module controlUnit(
    input [7:0] OPCODE,
    output reg MUX1, MUX2, MUX3, WRITE,
    output reg [1:0] MUX4,
    output reg [2:0] ALUOP,
    output reg [1:0] shift_type
);

    always @(*) begin
        case(OPCODE)
            8'b0000_0000: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b1;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b000;
                          end
            8'b0000_0001: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b001;
                          end
            8'b0000_0010: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b010;
                          end
            8'b0000_0011: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b011;
                          end
            8'b0000_0100: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b1;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b001;
                          end
            8'b0000_0101: begin
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b000;
                          end
            8'b0000_0110: begin
                            WRITE = 1'b0;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b1;
                            MUX4  = 2'b00;
                            ALUOP = 3'b001;
                          end
            8'b0000_0111: begin
                            WRITE = 1'b0;
                            MUX1  = 1'b0;
                            MUX2  = 1'b1;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b001;
                          end
            8'b0000_1000: begin //bne
                            WRITE = 1'b0;
                            MUX1  = 1'b0;
                            MUX2  = 1'b1;
                            MUX3  = 1'b0;
                            MUX4  = 2'b00;
                            ALUOP = 3'b001;
                          end
            8'b0000_1001: begin //mult
                            WRITE = 1'b1;
                            MUX1  = 1'b0;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b01;
                          end
            8'b0000_1010: begin //sll
                            WRITE = 1'b1;
                            MUX1  = 1'b1;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b10;
                            shift_type = 2'b00;
                          end
            8'b0000_1011: begin //srl
                            WRITE = 1'b1;
                            MUX1  = 1'b1;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b11;
                            shift_type = 2'b01;
                          end
            8'b0000_1100: begin //sra
                            WRITE = 1'b1;
                            MUX1  = 1'b1;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b11;
                            shift_type = 2'b10;
                          end
            8'b0000_1101: begin //ror
                            WRITE = 1'b1;
                            MUX1  = 1'b1;
                            MUX2  = 1'b0;
                            MUX3  = 1'b0;
                            MUX4  = 2'b11;
                            shift_type = 2'b11;
                          end
        endcase
    end

endmodule