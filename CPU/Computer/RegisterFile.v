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
            #1
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
        OUT1 = registerfile[OUT1ADDRESS];
        OUT2 = registerfile[OUT2ADDRESS];
    end

endmodule