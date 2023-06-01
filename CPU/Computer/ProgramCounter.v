module program_counter(input RESET, input CLK, output reg [31:0] OUT);
    always@(posedge CLK) begin
        if(RESET) #1 OUT <= 'b0;
        else #1 OUT <= OUT + 4;
    end
endmodule

// module adder(
//     input [31:0] OUT,
//     input [31:0] INSTRUCTION,
//     output reg [31:0] JOUT
// );
//     always @(OUT) JOUT = OUT + INSTRUCTION[7:0];
// endmodule