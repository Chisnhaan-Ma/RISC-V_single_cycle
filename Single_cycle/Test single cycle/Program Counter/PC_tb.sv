`timescale 1ns/1ps

module PC_tb();
    logic clk;
    logic [31:0] data_in;
    logic Write_enable;
    logic [31:0] data_out;
    
    // Instantiate PC module
    PC uut (
        .clk(clk),
        .data_in(data_in),
        .Write_enable(Write_enable),
        .data_out(data_out)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
      $dumpfile("PC_tb.vcd");
      $dumpvars(0,PC_tb);
        // Initialize signals
        clk = 0;
        Write_enable = 0;
        data_in = 32'h00000000;
        
        // Wait some time and check default output
        #10;
        $display("Initial data_out: %h", data_out);
        
        // Write first value
        Write_enable = 1;
        data_in = 32'h12345678;
        #10;
        $display("After writing 0x12345678, data_out: %h", data_out);
        
        // Disable writing and change data_in
        Write_enable = 0;
        data_in = 32'hABCDEF01;
        #10;
        $display("After disabling write, data_out should remain same: %h", data_out);
        
        // Write a new value
        Write_enable = 1;
        data_in = 32'h87654321;
        #10;
        $display("After writing 0x87654321, data_out: %h", data_out);
        
        // Finish simulation
        $stop;
    end
endmodule
