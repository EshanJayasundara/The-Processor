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