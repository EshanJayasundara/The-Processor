`include "CPU.v"

// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne

module cpu_tb;

    reg CLK, RESET;
    wire signed [31:0] PC;
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
    cpu cpu_dut(.PC(PC),
                .INSTRUCTION(INSTRUCTION),
                .CLK(CLK),
                .RESET(RESET)
                );
    
    integer i, j;
    initial
    begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("dump.vcd");
		$dumpvars(0, cpu_tb);
        for (j = 0; j < 8; j = j + 1) begin
            $dumpvars(1, cpu_dut.reg_file_dut.registerfile[j]);
        end

        // Initially CLK = 0
        CLK = 1'b0;

        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution      
        RESET = 1'b1;
        #5
        RESET= 0;

        #300
        // Display register values
        for(i=0; i<8; i++) begin
            $display("R%1d = %d", i, cpu_dut.reg_file_dut.registerfile[i]);
        end

        // finish simulation after some time
        $finish;
    end

    // clock signal generation
    initial forever begin
        #4 CLK = ~CLK;
    end
        
endmodule