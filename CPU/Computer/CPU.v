`include "Computer/ALU.v"
`include "Computer/ControlUnit.v"
`include "Computer/ProgramCounter.v"
`include "Computer/RegisterFile.v"

module cpu (
    output reg [31:0] PC,
    input [31:0] INSTRUCTION,
    input CLK, RESET
);
    wire [7:0] OUT1,OUT2;
    reg  [7:0] IN;
    reg  [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS; 
    wire WRITE;
    wire ZERO;
    wire mux3, mux4;
    // wire [31:0] PCN, PCJ;

    // program_counter pc_dut(.RESET(RESET), .CLK(CLK), .OUT(PC));

    // adder adder_dut(.OUT(PCN),.INSTRUCTION(INSTRUCTION),.JOUT(PCJ));

    // reg [31:0] PCR;



    // assign PC = PCR;

    reg_file registerFile (.IN(IN), 
                           .OUT1(OUT1), 
                           .OUT2(OUT2), 
                           .INADDRESS(INADDRESS), 
                           .OUT1ADDRESS(OUT1ADDRESS),
                           .OUT2ADDRESS(OUT2ADDRESS), 
                           .WRITE(WRITE), 
                           .CLK(CLK),
                           .RESET(RESET)
                           );

    wire mux1, mux2;
    wire [2:0] ALUOPOUT;

    controlUnit controler(.instruction(INSTRUCTION), .MUX1(mux1), .MUX2(mux2),  .MUX3(mux3), .ALUOP(ALUOPOUT), .WRITE(WRITE));

    wire [7:0] OUT;
    reg  [7:0] IN1,IN2;
    reg  [2:0] ALUOPIN;

    alu ALU(.data1(IN1), .operation(ALUOPIN), .result(OUT), .data2(IN2), .ZERO(ZERO));

    reg[7:0] mux2out;
    always @(*) begin
        // Decoding
        #1
        OUT1ADDRESS = INSTRUCTION[10: 8];
        OUT2ADDRESS = INSTRUCTION[ 2: 0];
        INADDRESS   = INSTRUCTION[18:16];
        
        IN1 = OUT1;
        IN  = OUT; 

        // MUX for selecting subtracting or addition
        if(mux2) begin
            ALUOPIN = 3'b001;
            #1 mux2out = ~OUT2 + 'b1;
        end else begin
            ALUOPIN = ALUOPOUT;
            mux2out = OUT2;
        end
        
        // MUX for selecting immediate or register file output 2
        if(mux1) begin 
            IN2 = INSTRUCTION[7:0];
        end else begin
            IN2 = mux2out;
        end

    end

    //Program Counter
    always @(posedge CLK) begin
        if(RESET == 1'b1) #1 PC <= 0;
        else begin
            if(mux3 == 1'b1 || INSTRUCTION[26:24] == 3'b111 && ZERO == 1'b1) #1 PC <= PC + INSTRUCTION[23:16]*4 + 4;
            else #1 PC <= PC+4;
        end
    end
endmodule