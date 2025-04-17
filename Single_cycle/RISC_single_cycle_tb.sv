`include "RISC_single_cycle.sv"
module RISC_single_cycle_tb;

  logic clk;
  logic reset;

  // Instantiate DUT
  RISC_single_cycle abc(.clk(clk),.reset(reset));

  // Clock generation
  always #5 clk = ~clk;
	
  initial begin
    $dumpfile("RISC_single_cycle_tb.vcd");
    $dumpvars(0, RISC_single_cycle_tb);
    clk = 0;
    reset = 1;    // Reset để PC = 0
    #10;
    reset = 0;   
  end
  initial begin
    
    abc.IMEM_instance.memory[0]  = 32'h123450b7;   // lui   x1, 0x12345       # x1 = 0x12345000
    abc.IMEM_instance.memory[4]  = 32'h00001117;   // auipc x2, 0x00001       # x2 = PC + 0x1000
    abc.IMEM_instance.memory[8]  = 32'h00a08193;   // addi  x3, x1, 10        # x3 = x1 + 10
    abc.IMEM_instance.memory[12]  = 32'h402082b3;  // add   x4, x1, x2        # x4 = x1 + x2
    abc.IMEM_instance.memory[16]  = 32'h00309333;  // sub   x5, x1, x2        # x5 = x1 - x2
    abc.IMEM_instance.memory[20]  = 32'h0020a3b3;  // sll   x6, x1, x3        # x6 = x1 << x3
    abc.IMEM_instance.memory[24]  = 32'h0020b433;  // slt   x7, x1, x2        # x7 = (x1 < x2) signed
    abc.IMEM_instance.memory[28]  = 32'h0020c4b3;  // sltu  x8, x1, x2        # x8 = (x1 < x2) unsigned
    abc.IMEM_instance.memory[32]  = 32'h0030d533;  // xor   x9, x1, x2        # x9 = x1 ^ x2
    abc.IMEM_instance.memory[36]  = 32'h4030d5b3;  // srl   x10, x1, x3       # x10 = x1 >> x3 (logical)
    abc.IMEM_instance.memory[40]  = 32'h0020e633;  // sra   x11, x1, x3       # x11 = x1 >> x3 (arithmetic)
    abc.IMEM_instance.memory[44]  = 32'h0020f6b3;  // or    x12, x1, x2       # x12 = x1 | x2
    abc.IMEM_instance.memory[48]  = 32'h00102023;  // and   x13, x1, x2       # x13 = x1 & x2
    abc.IMEM_instance.memory[52]  = 32'h00002703;  // sw    x1, 0(x0)         # store word x1 to memory[0]
    abc.IMEM_instance.memory[56]  = 32'h00200223;  // lw    x14, 0(x0)        # load word to x14 from memory[0]
    abc.IMEM_instance.memory[60]  = 32'h00400783;  // lb    x15, 4(x0)        # load byte signed
    abc.IMEM_instance.memory[64]  = 32'h00404803;  // lbu   x16, 4(x0)        # load byte unsigned
    abc.IMEM_instance.memory[68]  = 32'h00801883;  // lh    x17, 8(x0)        # load half signed
    abc.IMEM_instance.memory[72]  = 32'h00805903;  // lhu   x18, 8(x0)        # load half unsigned
    abc.IMEM_instance.memory[76]  = 32'h00208c63;  // beq   x1, x2, 24    
    abc.IMEM_instance.memory[80]  = 32'h00209c63;  // bne   x1, x2, 24    
    abc.IMEM_instance.memory[84]  = 32'h0020c863;  // blt   x1, x2, 16
    abc.IMEM_instance.memory[88]  = 32'h0020d863;  // bge   x1, x2, 16
    abc.IMEM_instance.memory[92]  = 32'h0020e463;  // bltu  x1, x2, 8
    abc.IMEM_instance.memory[96]  = 32'h0020f463;  // bgeu  x1, x2, 8
    abc.IMEM_instance.memory[100]  = 32'h004009ef; //jal x19 4
    abc.IMEM_instance.memory[104]  = 32'h00008a67; //jalr x20 x1 0

    // Run simulation
    #210;
    $finish;          
  end

endmodule
