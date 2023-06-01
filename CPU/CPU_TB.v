`include "Computer/CPU.v"

// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    reg [7:0] instr_mem [1023:0];
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
    assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};

    
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
    ------
     CPU |
    ------
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);
    
    // integer i;
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
        // finish simulation after some time
        #300
        // for(i=0; i<8; i++) begin
        //     $display("R%1d = %d", i, mycpu.registerFile.registerfile[i]);
        //     // $dumpvars(1, mycpu.registerFile.registerfile[i]);
        // end
        #10
        $finish;
    end

    integer j;
    initial begin
        $dumpfile("dump.vcd");
        for(j=0; j<8; j++) begin
            $dumpvars(1, mycpu.registerFile.registerfile[j]);
        end
    end
    
    // clock signal generation
    always begin
        #4 CLK = ~CLK;
    end
        
        

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