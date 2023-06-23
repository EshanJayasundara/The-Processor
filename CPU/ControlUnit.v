// Computer Architecture (CO224) - Lab
// Design: control Unit of the Simple Processor
// Author: Eshan Jayasundara, Sasindu Dilshan

`timescale 1ns/100ps

module ControlUnit(
    input  [31:0] INSTRUCTION,
    input BUSYWAIT,
    output reg MUX1, MUX2, MUX3, MUX4, WRITE,
    output reg [2:0] ALUOP,
    output reg READEN, WRITEEN
);
    reg [7:0] OPCODE;
    always @(INSTRUCTION) begin
        OPCODE = INSTRUCTION[31:24];
        case(OPCODE)
            8'b0000_0000: begin//loadi
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b1;    // immediate mux to take immediate value  ------------                                      
                            MUX2  = 1'b0;    // select wire which did not perform 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 or PC + jump_target -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b000;  // select forward operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_0001: begin//add
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which did not perform 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 or PC + jump_target -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b001;  // select add operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_0010: begin//and
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which did not perform 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 or PC + jump_target -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b010;  // select and operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_0011: begin//or
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which did not perform 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 or PC + jump_target -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b011;  // select or operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_0100: begin//sub
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b1;    // select wire which performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 or PC + jump_target -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b001;  // select add operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_0101: begin//mov
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which did not perform 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4  -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b000;  // select forward operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_0110: begin //j
                            WRITE = 1'b0;    // disable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which did not perform 2's complement ---------                                         
                            MUX3  = 1'b1;    // select PC + jump_target -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b001;  // select add operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_0111: begin //beq
                            WRITE = 1'b0;    // disable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b1;    // select wire which have been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b001;  // select add operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1000: begin //bne
                            WRITE = 1'b0;    // disable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b1;    // select wire which have been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b001;  // select add operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1001: begin //mult
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b100;  // select multiply operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1010: begin //sll
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b1;    // immediate mux to take immediate value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b101;  // select Left Shift operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1011: begin //srl
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b1;    // immediate mux to take immediate value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b110;  // select Right Shift operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1100: begin //sra
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b1;    // immediate mux to take immediate value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b110;  // select Right Shift operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1101: begin //ror
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b1;    // immediate mux to take immediate value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b0;    // select alu result as the register write input -----                           
                            ALUOP = 3'b110;  // select Right Shift operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1110: begin //lwd
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b1;    // select cache READ_DATA as the register write input -----                           
                            ALUOP = 3'b000;  // select forward operation in alu -------------------                                           
                            READEN  = 1'b1;  // Datamemory read enable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0000_1111: begin //swd
                            WRITE = 1'b0;    // disable registerfile to write --------------------------                                                      
                            MUX1  = 1'b0;    // immediate mux to take register value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'bx;    // dont care -----                           
                            ALUOP = 3'b000;  // select forward operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b1;  // Datamemory write enable ---------------------------                                                                    
                          end
            8'b0001_0000: begin //lwi
                            WRITE = 1'b1;    // enable registerfile to write --------------------------                                                      
                            MUX1  = 1'b1;    // immediate mux to take immediate value  ------------                                      
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'b1;    // select cache READ_DATA as the register write input -----                        
                            ALUOP = 3'b000;  // select forward operation in alu -------------------                                           
                            READEN  = 1'b1;  // Datamemory read enable ----------------------------                                                      
                            WRITEEN = 1'b0;  // Datamemory write disable ---------------------------                                                                    
                          end
            8'b0001_0001: begin //swi
                            WRITE = 1'b0;    // disable registerfile to write --------------------------                                                      
                            MUX1  = 1'b1;    // immediate mux to take immediate value  ------------   
                            MUX2  = 1'b0;    // select wire which havent been performed 2's complement ---------                                         
                            MUX3  = 1'b0;    // select PC + 4 -----------------                                  
                            MUX4  = 1'bx;    // dont care -----                        
                            ALUOP = 3'b000;  // select forward operation in alu -------------------                                           
                            READEN  = 1'b0;  // Datamemory read disable ----------------------------                                                      
                            WRITEEN = 1'b1;  // Datamemory write enable ---------------------------                                                                    
                          end
        endcase
    end

    always @(BUSYWAIT) begin

        if(BUSYWAIT) begin
            WRITE=1'b0;
        end
        
        else if(!BUSYWAIT) begin
            if(READEN) WRITEEN=1'b1;
            READEN = 1'b0;
            WRITEEN = 1'b0;
        end
    end

endmodule