`timescale 1ns/1ps

module DMEM_tb();
    logic [31:0] addr;
    logic [31:0] dataW;
    logic [31:0] dataR;
    logic clk;
    logic MemRW;
    
    // Instance of DMEM module
    DMEM dut (
        .addr(addr),
        .dataW(dataW),
        .dataR(dataR),
        .clk(clk),
        .MemRW(MemRW)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 10ns clock period
    
    initial begin
      $dumpfile("DMEM_tb.vcd");
      $dumpvars(0,DMEM_tb);
      // Initialize signals
        clk = 0;
        MemRW = 0;
        addr = 0;
        dataW = 0;
        
        // Test Case 1: Write to memory
        #10 addr = 32'd4; dataW = 32'hA5A5A5A5; MemRW = 1; // Write to address 4
        #10 MemRW = 0; // Stop writing
        
        // Test Case 2: Read from memory (should return A5A5A5A5)
        #10 addr = 32'd4;
        
        // Test Case 3: Write another value
        #10 addr = 32'd8; dataW = 32'hFFFFFF; MemRW = 1;
        #10 MemRW = 0;
        
        // Test Case 4: Read from another address
        #10 addr = 32'd8;
        
        // Test Case 5: Read from an uninitialized address (should return unknown value)
        #10 addr = 32'd12;
        
        #20 $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Addr=%h | DataW=%h | MemRW=%b | DataR=%h", 
                 $time, addr, dataW, MemRW, dataR);
    end
endmodule
