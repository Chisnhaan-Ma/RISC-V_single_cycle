
module Control_unit_tb;
  // Inputs
  logic [31:0] inst;
  logic BrEq, BrLt;

  // Outputs
  logic PCSel;
  logic [2:0] Imm_Sel;
  logic regWEn;
  logic BrUn;
  logic Bsel;
  logic Asel;
  logic [3:0] ALU_sel;
  logic MemRW;
  logic [1:0] WBSel;
  logic [2:0]load_type;

  // Instantiate the Control Unit
  Control_unit uut (
    .inst(inst),
    .BrEq(BrEq),
    .BrLt(BrLt),
    .PCSel(PCSel),
    .Imm_Sel(Imm_Sel),
    .regWEn(regWEn),
    .BrUn(BrUn),
    .Bsel(Bsel),
    .Asel(Asel),
    .ALU_sel(ALU_sel),
    .MemRW(MemRW),
    .WBSel(WBSel),
    .load_type(load_type)
  );
  initial begin
    $dumpfile ("Control_unit_tb.vcd");
    $dumpvars (0,Control_unit_tb);
    BrEq = 0;
    BrLt = 0;
    
    //R type//
		#10 inst = 32'h00208233; //add x4 x1 x2
		#10 inst = 32'h402082b3; //sub x5 x1 x2
		#10 inst = 32'h00111333; //sll x6 x2 x1
		#10 inst = 32'h001123b3; //slt x7 x2 x1
		#10 inst = 32'h0011b433; //sltu x8 x3 x1
		#10 inst = 32'h0020c4b3; //xor x9 x1 x2
		#10 inst = 32'h0020d533; //srl x10 x1 x2
		#10 inst = 32'h4020d5b3; //sra x11 x1 x2
		#10 inst = 32'h0020e633; //or x12 x1 x2
		#10 inst = 32'h0020f6b3; //and x13 x1 x2
    
	//I type//
		#10 inst = 32'h00508213;// addi x4, x1, 5  
		#10 inst = 32'h0060f293;// andi x5, x1, 6   
		#10 inst = 32'h0060e313;// ori  x6, x1, 6
		#10 inst = 32'h0060c393;// xori x7, x1, 6 
		#10 inst = 32'h00a12413;// slti x8, x2, 10
		#10 inst = 32'h0011b493;// sltiu x9, x3, 1
		#10 inst = 32'h00211513;// slli x10, x2, 2
		#10 inst = 32'h00115593;// srli x11, x2, 1
		#10 inst = 32'h4011d613;// srai x12, x3, 1 

    //Load//
		#10 inst = 32'h00008203;//lb x4 0(x1)
		#10 inst = 32'h0000c283;//lbu x5 0(x1)
		#10 inst = 32'h00209303;//lh x6 2(x1)
		#10 inst = 32'h0020d383;//lhu x7 2(x1)
		#10 inst = 32'h0040a403;//lw x8 4(x1)
    
    //Store word//
		#10 inst = 32'h0030a223; //sw x3 4(x1)
		#10 inst = 32'h123452b7; //lui x5, 0x12345 
		#10 inst = 32'h00010317; //auipc x6 16
		#10 inst = 32'h00c000ef; //jal x1 8
		#10 inst = 32'h00040067; //jalr x0 x8 0
		#10 inst = 32'h00000013; // NOP = addi x0 x0 0 (I type)
	
    //B type//
		#10inst = 32'h00728663; //beq x5 x7 12
		#5 BrEq = 1'b1;
		#5 inst = 32'h00629663;	//bne x5 x6 12
		#5 BrEq = 1'b0;
		#5 inst = 32'h00544663;	//blt x8 x5 12
		#5 BrLt= 1'b1;
		#5 inst = 32'h00535663;	//bge x6 x5 12
		#5 BrLt = 1'b0;
		#5 inst = 32'h0092e663;	//bltu x5 x9 12
		#5 BrLt = 1'b1;
		#5 inst = 32'h00537663;	//bgeu x6 x5 12
		#5 BrLt = 1'b0;
		#20
    $finish;
  end
endmodule