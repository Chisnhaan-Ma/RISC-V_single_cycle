module IMEM_tb;
  // Tín hiệu kiểm thử
  logic [31:0] addr;
  logic [31:0] inst;
  logic [4:0] inst_rsw, inst_rs1, inst_rs2;

  // Khởi tạo module IMEM
  IMEM dut (
    .addr(addr),
    .inst(inst),
    .inst_rsw(inst_rsw),
    .inst_rs1(inst_rs1),
    .inst_rs2(inst_rs2)
  );

  // Bộ nhớ giả lập
  initial begin
    $dumpfile("IMEM_tb.vcd");
    $dumpvars(0,IMEM_tb);
    // Load dữ liệu vào bộ nhớ (giả lập)
	//add  x4, x1, x2   
    sub  x5, x1, x2  
    sll  x6, x2, x1  
    slt  x7, x2, x1   
    sltu x8, x3, x1  
    xor  x9, x1, x2   
    srl  x10, x1, x2  
    sra  x11, x1, x2  
    or   x12, x1, x2  
    and  x13, x1, x2  
    dut.memory[0]=32'h00208233;//add  x4, x1, x2
    dut.memory[4]=32'h402082b3;//sub  x5, x1, x2
    dut.memory[8]=32'h00111333;//sll  x6, x2, x1  
    dut.memory[12]=32'h001123b3;//slt  x7, x2, x1
    dut.memory[16]=32'h0011b433;//sltu x8, x3, x1 
    dut.memory[20]=32'h0020c4b3;//xor  x9, x1, x2 
    dut.memory[24]=32'h0020d533;//srl  x10, x1, x2 
    dut.memory[28]=32'h4020d5b3;//sra  x11, x1, x2 
    dut.memory[32]=32'h0020e633;//or   x12, x1, x2  
    dut.memory[36]=32'h0020f6b3;//and  x13, x1, x2 

    for (int i = 0; i < 50; i = i + 4) begin
      addr = i; 
      #10;  
      $display("Addr: %0d | Inst: %h | rd: %0d | rs1: %0d | rs2: %0d", addr, inst, inst_rsw, inst_rs1, inst_rs2);
    end

   
    $finish;
  end
endmodule
