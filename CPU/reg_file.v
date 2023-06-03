// Computer Architecture (CO224) - Lab
// Design: Register File of the Simple Processor
// Author: Eshan Jayasundara

// W = width of a register
// N = number of registers being created
module reg_file #(parameter W = 8, parameter N = 8)(
    input  [7:0] IN, 
    input  [2:0] INADDRESS,OUT1ADDRESS,OUT2ADDRESS, 
    input WRITE, CLK, RESET,
    output [7:0] OUT1,OUT2
);

    // Createing a 8 x 8 register file
    reg [W-1:0] registerfile [0:N-1];

    integer i;
    always @(posedge CLK)begin
        if (RESET==1'b1) begin
        // all set to zero
            #1
            for(i = 0; i < N; i = i + 1) begin
                 registerfile[i] = 'b0;
            end
        end
        // Register Write
        if(WRITE == 1'b1) begin
            #1
            registerfile[INADDRESS] = IN; 
        end
    end
    //Register Read
    assign #1 OUT1 = registerfile[OUT1ADDRESS];
    assign #1 OUT2 = registerfile[OUT2ADDRESS];

endmodule