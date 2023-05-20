module fwd(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #1 out = data2;
endmodule

module add(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #2 out = data1 + data2;
endmodule

module mul(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #1 out = data1 & data2;
endmodule

module orr(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
       #1  out = data1 | data2;
endmodule

module alu(
    input [7:0] data1, data2,
    input [2:0] operation,
    output reg [7:0] result 
);
    wire [7:0] out1, out2, out3, out4;

    fwd fwd_dut(.data1(data1), .data2(data2), .out(out1));
    add add_dut(.data1(data1), .data2(data2), .out(out2));
    mul mul_dut(.data1(data1), .data2(data2), .out(out3));
    orr orr_dut(.data1(data1), .data2(data2), .out(out4));

    always @(*) begin
        case (operation)
            3'b000: result = out1; 
            3'b001: result = out2;
            3'b010: result = out3;
            3'b011: result = out4;
        endcase
    end
endmodule

module reg_file(input [7:0] IN, 
                output reg [7:0] OUT1,OUT2,
                input [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS, 
                input WRITE, CLK, RESET
                );

    reg [0:7][7:0] registerfile;
    integer i;
    always @(*)begin

        if (RESET=='b1) begin
            // all set to zero
            for(i = 0; i < 8; i = i + 1) begin
                registerfile[i] = 'b0;
            end
            //registerfile = '0;
        end
        case (INADDRESS) 
            3'b000 : registerfile[0] = IN;
            3'b001 : registerfile[1] = IN;
            3'b010 : registerfile[2] = IN;
            3'b011 : registerfile[3] = IN;
            3'b100 : registerfile[4] = IN;
            3'b101 : registerfile[5] = IN;
            3'b110 : registerfile[6] = IN;
            3'b111 : registerfile[7] = IN;
        endcase

        case (OUT1ADDRESS) 
            3'b000 : OUT1 = registerfile[0];
            3'b001 : OUT1 = registerfile[1];
            3'b010 : OUT1 = registerfile[2];
            3'b011 : OUT1 = registerfile[3];
            3'b100 : OUT1 = registerfile[4];
            3'b101 : OUT1 = registerfile[5];
            3'b110 : OUT1 = registerfile[6];
            3'b111 : OUT1 = registerfile[7];
        endcase

        case (OUT2ADDRESS) 
            3'b000 : OUT2 = registerfile[0];
            3'b001 : OUT2 = registerfile[1];
            3'b010 : OUT2 = registerfile[2];
            3'b011 : OUT2 = registerfile[3];
            3'b100 : OUT2 = registerfile[4];
            3'b101 : OUT2 = registerfile[5];
            3'b110 : OUT2 = registerfile[6];
            3'b111 : OUT2 = registerfile[7];
        endcase
        
    end
endmodule

module controlUnit(input [31:0] instruction, output reg MUX1, MUX2, output [2:0] ALUOP);
    assign ALUOP = instruction[31:29];
    always @(*) begin
        if(ALUOP == 3'b000) MUX1 = 1;
        else MUX1 = 0;
        if(ALUOP == 3'b100) MUX2 = 1;
        else MUX2 = 0;
    end
endmodule

module cpu(input [31:0] PC, input [31:0] INSTRUCTION, input CLK, RESET);
    wire [7:0] OUT1,OUT2;
    reg [7:0] IN1,IN2;
    reg [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS; 
    reg WRITE = 0;

    wire mux1, mux2;
    wire [2:0] ALUOPOUT;
    reg [2:0] ALUOPIN;

    wire [7:0] OUT;
    reg [7:0] IN;

    always @(*) begin
        INADDRESS = INSTRUCTION[18:16];
        OUT1ADDRESS = INSTRUCTION[10:8];
        OUT2ADDRESS = INSTRUCTION[2:0];
        IN = OUT;
        IN1 = OUT1;

        // MUX for selecting immediate or register file output 2
        if(mux1) begin 
            WRITE = 1;
            IN2 = INSTRUCTION[7:0];
        end else begin
            WRITE = 0;
            IN2 = OUT2;
        end
        // MUX for selecting subtracting or addition
        if(mux2) begin
            ALUOPIN = 3'b001;
            IN2 = ~OUT2 + 'b1;
        end else begin
            ALUOPIN = ALUOPOUT;
        end
    end

    controlUnit controler(INSTRUCTION, mux1, mux2, ALUOPOUT);
    alu ALU(.data1(IN1), .operation(ALUOPIN), .result(OUT), .data2(IN2));
    reg_file registerFile(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);

endmodule

module tb;
    reg [31:0] PC = 0;
    reg  [31:0] INSTRUCTION;
    reg  CLK = 0, RESET = 1;
    cpu CPU (PC, INSTRUCTION, CLK, RESET);

    initial forever begin
        #5 CLK = ~CLK;
    end

    initial begin
        $monitor();
        $dumpfile("dump.vcd");
        $dumpvars(0, CPU);
        #5
        RESET = 0;
        @(posedge CLK);
        #1 INSTRUCTION = 'b00000000_00000000_00000000_00001011; // loadi r0, #11 
        #10
        @(posedge CLK);
        #1 INSTRUCTION = 'b00000000_00000001_00000000_00000011; // loadi r1, #3
        #10
        @(posedge CLK);
        #1 INSTRUCTION = 'b10000000_00000010_00000000_00000001; // sub r2, r0, r1 
        #10
        @(posedge CLK);
        #1 INSTRUCTION = 'b00100000_00000011_00000000_00000001; // add r3, r0, r1 
        #10
        @(posedge CLK);
        #1 INSTRUCTION = 'b01000000_00000100_00000000_00000001; // and r4, r0, r1 
        #10
        @(posedge CLK);
        #1 INSTRUCTION = 'b01100000_00000101_00000000_00000001; // or r5, r0, r1 
        #200
        $finish();
    end

endmodule