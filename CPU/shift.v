// Computer Architecture (CO224) - Lab
// Design: Shifter of the Simple Processor
// Author: Eshan Jayasundara

module shift #(
    parameter W = 8
) (
    input       [W-1:0] data,
    input       [W-1:0] shift_amt,
    input       [1:0] shift_type,
    output reg  [W-1:0] result
);
    integer i;
    always @(*) begin
        #3
        result = data;
        case(shift_type)
            2'b00:  begin // LSL
                    for (i = 0; i < shift_amt; i = i + 1) result = {result[W-2:0], 1'b0};
                    end

            2'b01:  begin // LSR
                    for (i = 0; i < shift_amt; i = i + 1) result = {1'b0, result[W-1:1]};
                    end

            2'b10:  begin // SRA
                    for (i = 0; i < shift_amt; i = i + 1) result = {data[W-1], result[W-1:1]};
                    end

            2'b11:  begin // ROR
                    for (i = 0; i < shift_amt; i = i + 1) result = {data[0], result[W-1:1]};
                    end
        endcase
    end
endmodule


// module tb;
// parameter W = 8;
//     reg [W-1:0] d;
//     reg [3:0] shift_amt;
//     reg shift_type = 0;
//     wire [W-1:0] result;
//     shift #(.W(8)) shift_dut (.data(d), .shift_amt(shift_amt), .shift_type(shift_type), .result(result));
//     initial begin
//         #5
//         shift_amt = 3;
//         shift_type = 1;
//         #3
//         d = 8'b11111111;
//         #3
//         $display("%b",result);
//     end
// endmodule