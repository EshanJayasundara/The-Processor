// Computer Architecture (CO224) - Lab
// Design: CPU of the Simple Processor
// Author: Eshan Jayasundara

`include "ALU.v"
`include "ControlUnit.v"
`include "reg_file.v"

module cpu (
    input [31:0] INSTRUCTION,
    input CLK, RESET,
    output reg signed [31:0] PC
);

    wire [7:0] OUT1,OUT2, OUT;
    reg  [7:0] IN, IN1, IN2, OPCODE, mux2out;
    reg  [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS;
    wire [2:0] ALUOP;
    wire WRITE, ZERO, mux1, mux2, mux3;

    reg_file #(.W(8), .N(8)) reg_file_dut (.IN(OUT), 
                                           .OUT1(OUT1), 
                                           .OUT2(OUT2), 
                                           .INADDRESS(INADDRESS), 
                                           .OUT1ADDRESS(OUT1ADDRESS),
                                           .OUT2ADDRESS(OUT2ADDRESS), 
                                           .WRITE(WRITE),
                                           .CLK(CLK),
                                           .RESET(RESET)
                                           );

    controlUnit controlUnit_dut(.OPCODE(OPCODE),
                                .MUX1(mux1),
                                .MUX2(mux2),
                                .MUX3(mux3),
                                .ALUOP(ALUOP),
                                .WRITE(WRITE)
                                );

    alu #(.W(8)) alu_dut(.data1(OUT1),
                         .operation(ALUOP),
                         .result(OUT),
                         .data2(IN2),
                         .ZERO(ZERO)
                         );

    // Decoder
    always @(*) begin
        #1
        OPCODE      = INSTRUCTION[31:24];
        OUT1ADDRESS = INSTRUCTION[10: 8];
        OUT2ADDRESS = INSTRUCTION[ 2: 0];
        INADDRESS   = INSTRUCTION[18:16];
    end

    // MUX 2 for selecting subtracting or addition
    always @(*) begin
        if(mux2) begin
            #1
            mux2out = ~OUT2 + 'b1;
        end else begin
            mux2out = OUT2;
        end
    end
    
    // MUX 1 for selecting immediate or register file output 2
    always @(*) begin
        if(mux1) begin
            IN2 = INSTRUCTION[7:0];
        end else begin
            IN2 = mux2out;
        end
    end

    //Program Counter
    wire signed [22:0] signBits = {22{INSTRUCTION[23]}};
    wire signed [31:0] target = {signBits, INSTRUCTION[23:16], 2'b00};
  
    always @(posedge CLK) begin
        if(RESET == 1'b1) #1 PC <= 0;
        else begin
            if(mux3 == 1'b1 || (INSTRUCTION[26:24] == 3'b111 && ZERO == 1'b1)) #1 PC <= PC + target + 4;
            else #1 PC <= PC+4;
        end
    end

endmodule