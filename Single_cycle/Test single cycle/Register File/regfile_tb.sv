
`timescale 1ns / 1ps

module regfile_tb;
    logic clk;
    logic regWEn;
    logic [31:0] data_W;
    logic [4:0] rsW, rs1, rs2;
    logic [31:0] data_1, data_2;
    
    // Instantiate the regfile module
    regfile uut (
        .clk(clk),
        .regWEn(regWEn),
        .data_W(data_W),
        .rsW(rsW),
        .rs1(rs1),
        .rs2(rs2),
        .data_1(data_1),
        .data_2(data_2)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
      $dumpfile("regfile_tb.vcd");
      $dumpvars(0,regfile_tb);
        clk = 0;
        regWEn = 0;
        data_W = 0;
        rsW = 0;
        rs1 = 0;
        rs2 = 0;
        
        // Test case 1: Write to register 1
        #10 regWEn = 1; rsW = 5'd1; data_W = 32'h12345678;
        
        // Test case 2: Read from register 1
        #10 regWEn = 0; rs1 = 5'd1; rs2 = 5'd0;
        
        // Test case 3: Write to register 2
        #10 regWEn = 1; rsW = 5'd2; data_W = 32'h87654321;
        
        // Test case 4: Read from register 2
        #10 regWEn = 0; rs1 = 5'd2; rs2 = 5'd1;
        
        // Test case 5: Ensure register 0 stays 0
        #10 regWEn = 1; rsW = 5'd0; data_W = 32'hFFFFFFFF;
        
        // Test case 6: Read from register 0
        #10 regWEn = 0; rs1 = 5'd0; rs2 = 5'd2;
        
        // Test case 7: Write and read from register 3
        #10 regWEn = 1; rsW = 5'd3; data_W = 32'hA5A5A5A5;
        #10 regWEn = 0; rs1 = 5'd3;
        
        // Test case 8: Write and read from register 4
        #10 regWEn = 1; rsW = 5'd4; data_W = 32'h5A5A5A5A;
        #10 regWEn = 0; rs1 = 5'd4;
        
        // Test case 9: Write to register 5 and check persistence
        #10 regWEn = 1; rsW = 5'd5; data_W = 32'hDEADBEEF;
        #10 regWEn = 0; rs1 = 5'd5;
        
        // Test case 10: Read two different registers simultaneously
        #10 rs1 = 5'd1; rs2 = 5'd5;
        
        #10 $finish;
    end
endmodule
