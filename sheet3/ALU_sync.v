module ALU_sync (
  input  wire        clk,          // Clock signal
  input  wire [15:0] A, B,         // 16-bit input operands A and B
  input  wire [3:0]  ALU_FUN,      // 4-bit operation selector
  output reg  [15:0] ALU_OUT,      // 16-bit ALU output result
  output reg         Carry_flag,   // Carry flag (for addition and subtraction)
  output reg         Arith_flag,   // Indicates an arithmetic operation
  output reg         Logic_flag,   // Indicates a logic operation
  output reg         CMP_flag,     // Indicates a comparison operation
  output reg         Shift_flag    // Indicates a shift operation
);

always @(posedge clk ) begin
     // Reset  flags at every clock cycle.
    Carry_flag  <= 0;
    Arith_flag  <= 0;
    Logic_flag  <= 0;
    CMP_flag    <= 0;
    Shift_flag  <= 0;
    
    case (ALU_FUN)

    
        // ------------------- Arithmetic Operations -------------------
        4'b0000:begin // Addition
        {Carry_flag,ALU_OUT} <= A+B;
        Arith_flag<=1;
        end

        4'b0001: begin  // Subtraction
        {Carry_flag, ALU_OUT} <= {1'b0, A} - {1'b0, B};
        Arith_flag <= 1;
      end
        
        4'b0010: begin  // Multiplication
        ALU_OUT <= A*B;
        Arith_flag <= 1;
      end
        
        4'b0011: begin  // Division
        ALU_OUT <= (B != 0) ? A / B : 16'b0;  // Avoid divide-by-zero
        Arith_flag <= 1;
      end

              // ------------------- Logic Operations -------------------

      4'b0100: begin  // AND
        ALU_OUT <= A & B;
        Logic_flag <= 1;
      end
      4'b0101: begin  // OR
        ALU_OUT <= A | B;
        Logic_flag <= 1;
      end  
        
      4'b0110: begin  // NAND
        ALU_OUT <= ~(A & B);
        Logic_flag <= 1;
      end
        
      4'b0111: begin  // NOR
        ALU_OUT <= ~(A | B);
        Logic_flag <= 1;
      end        
        
      4'b1000: begin  // XOR
        ALU_OUT <= A ^ B;
        Logic_flag <= 1;
      end  
      4'b1001: begin  // XNOR
        ALU_OUT <= ~(A ^ B);
        Logic_flag <= 1;
      end        
        
         // ------------------- Comparison Operations -------------------
      4'b1010: begin  // Equality Check
        if (A==B) 
            ALU_OUT<=1;
            else
            ALU_OUT<=0;
        

        CMP_flag <= 1;
      end

      4'b1011: begin  // Greater Than
       if (A>B) 
            ALU_OUT<=2;
            else
            ALU_OUT<=0;
        

        CMP_flag <= 1;
      end 
 
      4'b1100: begin  // Less Than
        if (A<B) 
            ALU_OUT<=3;
            else
            ALU_OUT<=0;
        

        CMP_flag <= 1;
      end

    // ------------------- Shift Operations -------------------
      4'b1101: begin  // Shift Right by 1
        ALU_OUT <= A >> 1;
        Shift_flag <= 1;
      end

      4'b1110: begin  // Shift Left by 1
        ALU_OUT <= A << 1;
        Shift_flag <= 1;
      end

      // ------------------- Default Case -------------------
      default: begin
        ALU_OUT <= 16'b0;
    
      end 

    endcase

end

endmodule