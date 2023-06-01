module reg_file(input [7:0] IN, 
                output reg [7:0] OUT1,OUT2,
                input [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS, 
                input WRITE, CLK, RESET
                );

    reg [7:0] registerfile [0:7];
    integer i;
    always @(*)begin
        if (RESET=='b1) begin
            // all set to zero
            for(i = 0; i < 8; i = i + 1) begin
                registerfile[i] = 'b0;
            end
            //registerfile = '0;
        end
        OUT1 = registerfile[OUT1ADDRESS];
        OUT2 = registerfile[OUT2ADDRESS];
    end
    always @(posedge CLK) registerfile[INADDRESS] = IN;
endmodule