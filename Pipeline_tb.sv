`include "Pipeline.sv"
`timescale 1ps/1ps
module Pipeline_tb;

  logic clk;
  logic reset;
  logic [31:0]Write_scoreboard;
  logic [4:0]rsw_scoreboard;
  // Instantiate DUT
  Pipeline dut(
  .clk(clk),
  .reset(reset),
  .Write_scoreboard(Write_scoreboard),
  .rsw_scoreboard(rsw_scoreboard));

  // Clock generation
  always #5 clk = ~clk;
	
  initial begin
    $dumpfile("Pipeline_tb.vcd");
    $dumpvars(0, Pipeline_tb);
    clk = 0;
    reset = 1;    // Reset để PC = 0
    #10;
    reset = 0;   
    #5 reset  = 1;
    #700;
    $finish;          
  end
initial begin 
  #50 begin 
    $display(" START TEST R-TYPE, S-TYPE, LOAD & Data Hazarad");
    if (rsw_scoreboard == 1 && Write_scoreboard == 32'h12345000) 
      $display("At %d PASSED LUI", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 2 && Write_scoreboard == 3) 
      $display("At %d PASSED ADDI", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 3 && Write_scoreboard == 5) 
      $display("At %d PASSED ADDI", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 5 && Write_scoreboard == (5-3) ) 
      $display("At %d PASSED SUB", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 6 && Write_scoreboard == (32'h12345000 + 5)) 
      $display("At %d PASSED ADD", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 7 && Write_scoreboard == $signed(3 < 32'h12345000)) 
      $display("At %d PASSED SLT", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 8 && Write_scoreboard == (32'h12345000 < 3)) 
      $display("At %d PASSED SLTU", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 9 && Write_scoreboard == (32'h12345000 ^ 3)) 
      $display("At %d PASSED XOR", $time);
    else 
      $display("FAILED At %d", $time);
  end
    #10 begin 
    if (rsw_scoreboard == 10 && Write_scoreboard == (32'h12345000 >> 3)) 
      $display("At %d PASSED SRL", $time);
    else 
      $display("FAILED At %d", $time);
  end
    #10 begin 
    if (rsw_scoreboard == 11 && Write_scoreboard == (32'h12345000 >>> 3)) 
      $display("At %d PASSED SRA", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 12 && Write_scoreboard == (32'h12345000 | 3)) 
      $display("At %d PASSED OR", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 13 && Write_scoreboard == (32'h12345000 & 3)) 
      $display("At %d PASSED AND", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 1 && Write_scoreboard == (32'h12345000 + 12'h7ff)) 
      $display("At %d PASSED ADDI", $time);
    else 
      $display("FAILED At %d", $time);
      $display("End R_type and forwarding");
  end

    #10
    #10
    #10
    #10
    #10
    #10


    #10 begin 
    if (rsw_scoreboard == 18 && Write_scoreboard == (32'h12345000 + 12'h7ff)) 
      $display("At %d PASSED SW & LW", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 19 && Write_scoreboard == (32'hffffffff)) 
      $display("At %d PASSED LB", $time);
    else 
      $display("FAILED At %d", $time);
      //$display("End Load_type and forwarding");
  end
  
    #10 begin 
    if (rsw_scoreboard == 20 && Write_scoreboard == (32'h00005000 + 12'h7ff)) 
      $display("At %d PASSED LH", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 21 && Write_scoreboard == (32'h123457ff & 32'h0000FFFF)) 
      $display("At %d PASSED LHU", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 0)
      $display("At %d PASSED STALLING", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 2 && Write_scoreboard == ((32'h123457ff & 32'h0000FFFF) + 1 )) 
      $display("At %d PASSED LOAD HAZZARD ", $time);
    else 
      $display("FAILED At %d", $time);
  end

    #10 begin 
    if (rsw_scoreboard == 22 && Write_scoreboard == 32'h000058ff)
      $display("At %d PASSED Forwarding after load hazzard ", $time);
    else 
      $display("FAILED At %d", $time);
  end
end
endmodule
