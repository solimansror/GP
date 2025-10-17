`timescale 1us/1ns

module tb_ALU_sync;

// Declare testbench signals
  reg clk;
  reg [15:0] A, B;
  reg [3:0]  ALU_FUN;
  wire[15:0] ALU_OUT ;
  wire Carry_flag;
  wire Arith_flag;
  wire Logic_flag;
  wire CMP_flag;
  wire Shift_flag;

// Instantiate the ALU module 
  ALU_sync uut (
    .clk(clk),
    .A(A), .B(B), .ALU_FUN(ALU_FUN),
    .ALU_OUT(ALU_OUT),
    .Carry_flag(Carry_flag),
    .Arith_flag(Arith_flag),
    .Logic_flag(Logic_flag),
    .CMP_flag(CMP_flag),
    .Shift_flag(Shift_flag)
  ); 

// Clock generation: 10us clock period (5us high, 5us low)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

// Monitor signals on every change  
  initial begin
    $monitor("Time = %0t | A = %b | B = %b | ALU_FUN = %b | ALU_OUT = %b | Carry_flag= %b | Arith_flag = %b | Logic_flag = %b | CMP_flag = %b | Shift_flag = %b ",
             $time, A, B, ALU_FUN, ALU_OUT, Carry_flag, Arith_flag, Logic_flag,CMP_flag,Shift_flag);
  end



  // Apply test cases on positive edge of clk
  initial begin
    $dumpfile("alu_sync.vcd");
    $dumpvars;
    
    // Test Case 1: Addition
    A = 16'd100; B = 16'd200; ALU_FUN = 4'b0000;
    #10
    $display("Addition: ALU_OUT = %d", ALU_OUT);
    if (ALU_OUT == 16'd300)
     $display("Test 1 PASSED"); 
     else $display("Test 1 FAILED");
     
    // Test Case 2: Subtraction
    A = 16'd200; B = 16'd100; ALU_FUN = 4'b0001;
    #10
    $display("Subtraction: ALU_OUT = %d", ALU_OUT);
    if (ALU_OUT == 16'd100) $display("Test 2 PASSED");
    else $display("Test 2 FAILED"); 
 
    // Test Case 3: Multiplication
    A = 16'd5; B = 16'd10; ALU_FUN = 4'b0010;
    #10
    $display("Multiplication: ALU_OUT = %d", ALU_OUT);
    if (ALU_OUT == 16'd50) $display("Test 3 PASSED"); 
    else $display("Test 3 FAILED");

    // Test Case 4: Division
    A = 16'd100; B = 16'd5; ALU_FUN = 4'b0011;
    #10
    $display("Division: ALU_OUT = %d", ALU_OUT);
    if (ALU_OUT == 16'd20) $display("Test 4 PASSED"); 
    else $display("Test 4 FAILED");

   // Test Case 5: AND
    A = 16'b0000000000001100; B = 16'b0000000000000011; ALU_FUN = 4'b0100;
    #10
    if (ALU_OUT == 16'h0000) $display("Test 5 PASSED");
    else $display("Test 5 FAILED");

    // Test Case 6: OR
    ALU_FUN = 4'b0101;
    #10
    if (ALU_OUT == 16'b0000000000001111) $display("Test 6 PASSED");
    else $display("Test 6 FAILED");     

    // Test Case 7: NAND
    ALU_FUN = 4'b0110;
    #10
    if (ALU_OUT == 16'b1111111111111111) $display("Test 7 PASSED"); 
    else $display("Test 7 FAILED");  

    // Test Case 8: NOR
    ALU_FUN = 4'b0111;
    #10
    if (ALU_OUT == 16'b1111111111110000   ) $display("Test 8 PASSED");
    else $display("Test 8 FAILED");

    // Test Case 9: XOR
    ALU_FUN = 4'b1000;
    #10
    if (ALU_OUT == 16'b0000000000001111) $display("Test 9 PASSED");
    else $display("Test 9 FAILED"); 
    
    // Test Case 10: XNOR
    ALU_FUN = 4'b1001;
    #10
    if (ALU_OUT == 16'b1111111111110000) $display("Test 10 PASSED"); 
    else $display("Test 10 FAILED");
    
    // Test Case 11: Equal
    A = 16'd55; B = 16'd55; ALU_FUN = 4'b1010;
    #10
    if (ALU_OUT == 16'd1) $display("Test 11 PASSED"); 
    else $display("Test 11 FAILED");
    
    // Test Case 12: Greater Than
    A = 16'd70; B = 16'd10; ALU_FUN = 4'b1011;
    #10
    if (ALU_OUT == 16'd2) $display("Test 12 PASSED"); 
    else $display("Test 12 FAILED");

    // Test Case 13: Less Than
    A = 16'd5; B = 16'd50; ALU_FUN = 4'b1100;
    #10
    if (ALU_OUT == 16'd3) $display("Test 13 PASSED"); 
    else $display("Test 13 FAILED"); 
    
    // Test Case 14: Shift Right
    A = 16'b1000000000000000; ALU_FUN = 4'b1101;
    #10
    if (ALU_OUT == 16'b0100000000000000) $display("Test 14 PASSED"); 
    else $display("Test 14 FAILED");
    
    // Test Case 15: Shift Left
    A = 16'b0000000000000001; ALU_FUN = 4'b1110;
    #10
    if (ALU_OUT == 16'b0000000000000010) $display("Test 15 PASSED");
    else $display("Test 15 FAILED");
    
    // Test Case 16: Default case (unrecognized ALU_FUN)
    ALU_FUN = 4'b1111;
    #10
    if (ALU_OUT == 16'd0) $display("Test 16 PASSED");
    else $display("Test 16 FAILED");

    ALU_FUN = 0;  A = 16'b0000000000000001; B = 16'b0000000000000011;
    #50
    $stop;

  end

endmodule
