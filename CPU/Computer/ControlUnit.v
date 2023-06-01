module controlUnit(
    input [31:0] instruction, 
    output reg MUX1, MUX2, MUX3,
    output reg [2:0] ALUOP,
    output reg WRITE
);
    always @(*) begin
        ALUOP = instruction[26:24];
        if(ALUOP == 3'b110) begin
            WRITE = 1'b0;
            MUX3 = 1'b1;
        end else begin
            WRITE = 1'b1;
            MUX3 = 1'b0;
        end
        if(ALUOP == 3'b111) begin
            WRITE = 1'b0;
            ALUOP = 3'b100;
        end else begin
            WRITE = 1'b1;
            ALUOP = ALUOP;
        end
        if(ALUOP == 3'b000) MUX1 = 1;
        else MUX1 = 0;
        if(ALUOP == 3'b100) MUX2 = 1;
        else MUX2 = 0;
        if(ALUOP == 3'b101) ALUOP = 3'b000;
    end
endmodule