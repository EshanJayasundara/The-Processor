// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne

`include "cpu.v"
`include "dataMemory.v"
`include "dcache.v"
`timescale 1ns/100ps

module cpuTb;

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

    wire BUSYWAIT,READEN,WRITEEN,MEM_BUSYWAIT,MEM_READ,MEM_WRITE;
    wire [7:0] ADDRESS,WRITE_DATA,READ_DATA;
    wire [31:0] MEM_IN,MEM_OUT;
    wire [5:0] MEM_ADDRESS;

    Cpu Cpu_dut(.PC(PC),
                .INSTRUCTION(INSTRUCTION),
                .CLK(CLK),
                .RESET(RESET),
                .READ_DATA(READ_DATA),
                .BUSYWAIT(BUSYWAIT),//input
                .WRITEEN(WRITEEN),
                .READEN(READEN),
                .ADDRESS(ADDRESS),
                .WRITE_DATA(WRITE_DATA)
                );

    dcache dcache_dut(.busywait(BUSYWAIT),
		              .mem_read(MEM_READ),        
		              .mem_write(MEM_WRITE),
		              .mem_writedata(MEM_IN),
		              .mem_address(MEM_ADDRESS),
		              .readdata(READ_DATA),
		              .mem_busywait(MEM_BUSYWAIT),
		              .mem_readdata(MEM_OUT),
		              .address(ADDRESS),
		              .writedata(WRITE_DATA),
		              .read(READEN),
		              .write(WRITEEN),
		              .clk(CLK),
		              .reset(RESET)
	                  );
    
    DataMemory DataMemory_dut(
	.clock(CLK),
    .reset(RESET),
    .read(MEM_READ),
    .write(MEM_WRITE),
    .address(MEM_ADDRESS),
    .writedata(MEM_IN),
    .readdata(MEM_OUT),
    .busywait(MEM_BUSYWAIT)//output
);

    integer i, j;
    initial
    begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("dump.vcd");
		$dumpvars(0, cpuTb);
        for (j = 0; j < 8; j = j + 1) begin
            $dumpvars(1, Cpu_dut.RegFile_dut.registerfile[j]);
        end

        for (j = 0; j < 256; j = j + 1) begin
            $dumpvars(1, DataMemory_dut.memory_array[j]);
        end

        // Initially CLK = 0
        CLK = 1'b0;

        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution      
        RESET = 1'b1;
        #5
        RESET= 0;

        #5000
        // Display register values
        for(i=0; i<8; i++) begin
            $display("R%1d = %b", i, Cpu_dut.RegFile_dut.registerfile[i]);
            // $display("%d", dmem_dut.memory_array[1]);
        end
        for(i=0; i<8; i++) begin
            $display("Index %1d = %b_%b_%b_%b", i, dcache_dut.cache[i][31:24], dcache_dut.cache[i][23:16], dcache_dut.cache[i][15:8], dcache_dut.cache[i][7:0]);
            // $display("%d", dmem_dut.memory_array[1]);
        end
        // finish simulation after some time
        $finish;
    end

    // clock signal generation
    initial forever begin
        #4 CLK = ~CLK;
    end
        
endmodule