`include "Pipeline.sv"
module Pipeline_tb;

  logic clk;
  logic reset;

  // Instantiate DUT
  Pipeline dut(.clk(clk),.reset(reset));

  // Clock generation
  always #5 clk = ~clk;
	
  initial begin
    $dumpfile("Pipeline_tb.vcd");
    $dumpvars(0, Pipeline_tb);
    clk = 0;
    reset = 1;    // Reset để PC = 0
    #10;
    reset = 0;   
    #3 reset  = 1;
    #330;
    $finish;          
  end

endmodule
