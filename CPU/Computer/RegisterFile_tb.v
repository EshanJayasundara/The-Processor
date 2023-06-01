`include "RegisterFile.v"

module tb;
    reg [7:0] IN;
    wire [7:0] OUT1,OUT2;
    reg [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS; 
    reg WRITE = 0, RESET = 0;
    reg CLK = 0;

    initial forever begin
        #5 CLK = ~CLK;
    end

    reg_file dut(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);

    integer i;
    initial begin
        $dumpfile("RegisterFile.vcd");
        $dumpvars(0, dut);
        RESET = 1; WRITE = 1; #5 RESET=0;

        for (i = 0; i < 8; i = i + 1) begin
            #1 @(posedge CLK); IN = i; INADDRESS = i;
        end

        
        for(i = 0; i < 8; i=i+1) begin
            #1 @(posedge CLK); OUT1ADDRESS = i;
            #1 @(posedge CLK); OUT2ADDRESS = 7-i;
        end

        #20
        $finish();
        
    end
endmodule