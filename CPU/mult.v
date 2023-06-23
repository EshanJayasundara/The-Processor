// Computer Architecture (CO224) - Lab
// Design: Multiplier of the Simple Processor
// Author: Eshan Jayasundara

module Mult #(
    parameter W = 8
) (
    input  [W-1:0] MULTIPLICAND,
    input  [W-1:0] MULTIPLIER,
    output [W-1:0] OUT
);
    
    // normal multiplication as we do on decimal numbers
    assign #2 OUT = {MULTIPLICAND * MULTIPLIER[0]    } + 
                    {MULTIPLICAND * MULTIPLIER[1],1'b0} + 
                    {MULTIPLICAND * MULTIPLIER[2],2'b00} + 
                    {MULTIPLICAND * MULTIPLIER[3],3'b000} + 
                    {MULTIPLICAND * MULTIPLIER[4],4'b0000} + 
                    {MULTIPLICAND * MULTIPLIER[5],5'b00000} + 
                    {MULTIPLICAND * MULTIPLIER[6],6'b000000} + 
                    {MULTIPLICAND * MULTIPLIER[7],7'b0000000};
	
endmodule


// module tb;
// parameter W = 8;
//     reg [W-1:0] d1, d2;
//     wire [W-1:0] result;
//     multiplier #(.W(W)) mult_dut (d1, d2, result);
//     initial begin
//         d1 = 3;
//         d2 = 2;
//         $display("%d",result);
//     end
// endmodule