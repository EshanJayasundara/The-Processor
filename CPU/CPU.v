module fwd(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #1 out = data2;
endmodule

module add(input [7:0] data1, data2, output reg [7:0] out);
    always @(*)
        #2 out = data1 + data2;
endmodule

module ann(input [7:0] data1, data2, output reg [7:0] out);
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
    ann and_dut(.data1(data1), .data2(data2), .out(out3));
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

module reg_file(
    input [7:0] IN, 
    output reg [7:0] OUT1,OUT2,
    input [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS, 
    input WRITE, CLK, RESET
);
    reg [0:7][7:0] registerfile;
    integer i;
    always @(posedge CLK)begin

        if (RESET==1'b1) begin
            // all set to zero
            for(i = 0; i < 8; i = i + 1) begin
                registerfile[i] = 'b0;
            end
            //registerfile = '0;
        end
        else if(WRITE == 1'b1) begin
            #1
            registerfile[INADDRESS] = IN;
        end
    end
    always @(*) begin
        #2 
        OUT1 = registerfile[OUT1ADDRESS];
        OUT2 = registerfile[OUT2ADDRESS];
    end
endmodule

module controlUnit(
    input [31:0] instruction, 
    output reg MUX1, MUX2, 
    output reg [2:0] ALUOP
);
    always @(*) begin
        ALUOP = instruction[26:24];
        if(ALUOP == 3'b000) MUX1 = 1;
        else MUX1 = 0;
        if(ALUOP == 3'b100) MUX2 = 1;
        else MUX2 = 0;
        if(ALUOP == 3'b101) ALUOP = 3'b000;
    end
endmodule

module program_counter(input RESET, input CLK, output reg [31:0] OUT);
    always@(posedge CLK, RESET) begin
        if(RESET) OUT <= 'b0;
        else #1 OUT <= OUT + 4;
    end
endmodule

module cpu (
    output [31:0] PC,
    input [31:0] INSTRUCTION, 
    input CLK, RESET
);
    wire [7:0] OUT1,OUT2;
    reg  [7:0] IN;
    reg  [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS; 
    reg WRITE = 1;

    program_counter pc_dut(.RESET(RESET), .CLK(CLK), .OUT(PC));

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

    controlUnit controler(.instruction(INSTRUCTION), .MUX1(mux1), .MUX2(mux2), .ALUOP(ALUOPOUT));

    wire [7:0] OUT;
    reg  [7:0] IN1,IN2;
    reg  [2:0] ALUOPIN;

    alu ALU(.data1(IN1), .operation(ALUOPIN), .result(OUT), .data2(IN2));

    reg[7:0] mux2out;

    always @(*) begin
        // Decoding
        #1
        INADDRESS   = INSTRUCTION[18:16];
        OUT1ADDRESS = INSTRUCTION[10: 8];
        OUT2ADDRESS = INSTRUCTION[ 2: 0];
        
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
endmodule

// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    reg [31:0] INSTRUCTION;
    reg [7:0] instr_mem [1023:0];
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
    integer i;
    initial
    begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        // METHOD 1: manually loading instructions to instr_mem
        //{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000001000000000000000101;
        //{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b00000000000000100000000000001001;
        //{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]} = 32'b00000010000001100000010000000010;
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        $readmemb("instr_mem.mem", instr_mem);
    end
    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);

    initial
    begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("dump.vcd");
		$dumpvars(0, cpu_tb);
        CLK = 1'b0;
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution      
        RESET = 1'b1;
        #5
        RESET= 0;
        for(i =0; i<7; i=i+1) begin
            #1 INSTRUCTION = {instr_mem[3+PC], instr_mem[2+PC], instr_mem[1+PC], instr_mem[PC]};
            // $dumpvars(1,cpu_dut.registerfile[i]);
            @(posedge CLK);
        end
        // finish simulation after some time
        #500
        $finish;
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule

// module tb;

//     wire [31:0] PC;
//     reg [31:0] INSTRUCTION;
//     reg CLK = 0, RESET = 1;

//     reg [7:0] instr_mem [1023:0];

//     cpu cpu_dut (.PC(PC), .INSTRUCTION(INSTRUCTION), .CLK(CLK), .RESET(RESET));

//     initial forever begin
//         #4 CLK = ~CLK;
//     end

//     integer i;
//     initial begin
//         $monitor();
//         $readmemb("instr_mem.mem", instr_mem);
//         $dumpfile("dump.vcd");
//         // for(i=0; i<8; i++) begin
//         //     $dumpvars(0,cpu_dut.registerFile.reg_file.registerfile[i]);
//         //     // $dumpvars(1,cpu_dut.registerFile.reg_file[1]);
//         // end
//         $dumpvars(0, cpu_dut);

//         #5 RESET = 0;
//         #2 INSTRUCTION = {instr_mem[3+PC], instr_mem[2+PC], instr_mem[1+PC], instr_mem[PC]};
//         #500
//         $finish();
//     end

// endmodule


        
        // @(posedge CLK);
        // #1 RESET = 0;
        // @(posedge CLK);
        // #1 INSTRUCTION = 'b00000000_00000000_00000000_00001011; // loadi r0, #11 
        // #2
        // @(posedge CLK);
        // #1 INSTRUCTION = 'b00000000_00000001_00000000_00000011; // loadi r1, #3
        // #2
        // @(posedge CLK);
        // #1 INSTRUCTION = 'b00000100_00000010_00000000_00000001; // sub r2, r0, r1 
        // #2
        // @(posedge CLK);
        // #1 INSTRUCTION = 'b00000001_00000011_00000000_00000001; // add r3, r0, r1 
        // #2
        // @(posedge CLK);
        // #1 INSTRUCTION = 'b00000010_00000100_00000000_00000001; // and r4, r0, r1 
        // #2
        // @(posedge CLK);
        // #1 INSTRUCTION = 'b00000011_00000101_00000000_00000001; // or r5, r0, r1 
        // #2
        // @(posedge CLK);
        // #1 INSTRUCTION = 'b00000101_00000110_00000000_00000001; // mov r6, r1 
        // #20


        // ins_reg[0] = 32'b00000000_00000000_00000000_00001011;//loadi r0, #11
        // ins_reg[1] = 32'b00000000_00000001_00000000_00000011;// loadi r1, #3
        // ins_reg[2] = 32'b00000100_00000010_00000000_00000001;// sub r2, r0, r1
        // ins_reg[3] = 32'b00000001_00000011_00000000_00000001;// add r3, r0, r1
        // ins_reg[4] = 32'b00000010_00000100_00000000_00000001;// and r4, r0, r1 
        // ins_reg[5] = 32'b00000011_00000101_00000000_00000001;// or r5, r0, r1 
        // ins_reg[6] = 32'b00000101_00000110_00000000_00000001;// mov r6, r1 